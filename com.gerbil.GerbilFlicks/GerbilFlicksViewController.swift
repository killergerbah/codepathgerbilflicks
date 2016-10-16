//
//  ViewController.swift
//  com.gerbil.GerbilFlicks
//
//  Created by R-J Lim on 10/13/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import BFRadialWaveHUD

class GerbilFlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let service = MovieDbService()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorView.isHidden = true
        let shadowPath = UIBezierPath(rect: networkErrorView.bounds)
        networkErrorView.layer.shadowColor = UIColor.black.cgColor
        networkErrorView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        networkErrorView.layer.shadowOpacity = 0.5
        networkErrorView.layer.shadowPath = shadowPath.cgPath
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if service.movies.count == 0 {
            let hud = BFRadialWaveHUD.init(view: self.view, fullScreen: false, circles: 10, circleColor: UIColor.white, mode: BFRadialWaveHUDMode.north, strokeWidth: 4.0)
            
            hud?.show(withMessage: "Gerbil Flicks")
            refresh(callback: { _ in hud?.dismiss() }, failureCallback: { _ in hud?.dismiss() })
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func refresh(callback: (Void) -> Void, failureCallback: (Void) -> Void) {
        service.getNowPlaying(
            { movies in
                self.networkErrorView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                callback()
            },
            failureCallback: { _ in
                self.networkErrorView.isHidden = false
                self.tableView.isHidden = true
                failureCallback()
            }
        )
    }
    
    private func refresh(callback: (Void) -> Void) {
        refresh(callback: callback, failureCallback: { _ in })
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        refresh(callback: { _ in refreshControl.endRefreshing() })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt cellForRowAtIndexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "com.gerbil.GerbilFlicksCell") as? GerbilFlicksTableViewCell else {
            return GerbilFlicksTableViewCell()
        }
        
        let index = (cellForRowAtIndexPath as NSIndexPath).row
        let movie = service.movies[index]
        
        cell.overviewLabel.text = movie.overview
        cell.titleLabel.text = movie.title
        
        if let url = URL(string: movie.imageUrl) {
            cell.movieImageView.setImageWith(url)
        }
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let destination = segue.destination as? GerbilFlicksDetailsViewController, let cell = sender as? UITableViewCell else {
            return
        }
        
        let indexPathOrNil = tableView.indexPath(for: cell)

        if let indexPath = indexPathOrNil, indexPath.row < service.movies.count {
            tableView.deselectRow(at: indexPath, animated:true)
            destination.movie = service.movies[indexPath.row]
        }
    }
}

