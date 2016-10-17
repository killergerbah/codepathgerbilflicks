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

class GerbilFlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var displaySegmentedControl: UISegmentedControl!
    
    private let service = MovieDbService()
    private var category: MovieCategory = MovieCategory.NowPlaying
    private var displayingView: UIView!
    private var display: Display = Display.List
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkErrorView.isHidden = true
        let shadowPath = UIBezierPath(rect: networkErrorView.bounds)
        networkErrorView.layer.shadowColor = UIColor.black.cgColor
        networkErrorView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        networkErrorView.layer.shadowOpacity = 0.5
        networkErrorView.layer.shadowPath = shadowPath.cgPath
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        tabBarController?.delegate = self
        
        
        insertRefreshControl(tableView)
        insertRefreshControl(collectionView)
        
        setDisplaying(display)
        refreshView(force: false)
    }
    
    private func insertRefreshControl(_ view: UIView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        view.insertSubview(refreshControl, at: 0)
    }
    
    private func refreshView(force: Bool) {
        title = category.name
        if force || service.movies(category).count == 0 {
            let hud = BFRadialWaveHUD.init(view: self.view, fullScreen: false, circles: 10, circleColor: UIColor.white, mode: BFRadialWaveHUDMode.north, strokeWidth: 4.0)
            
            hud?.show(withMessage: "Gerbil Flicks")
            refresh(callback: { _ in hud?.dismiss() }, failureCallback: { _ in hud?.dismiss() })
        }

    }
    
   
    @IBAction func onSelectedDisplayType(_ sender: AnyObject) {
        guard let sc = sender as? UISegmentedControl else {
            return
        }
        
        switch sc.selectedSegmentIndex {
        case 0:
            setDisplaying(Display.List)
            break
        case 1:
            setDisplaying(Display.Grid)
            break
        default:
            break
        }
    }
    
    private func setDisplaying(_ display: Display) {
        displayingView?.isHidden = true
        displayingView = display == Display.List ? tableView : collectionView
        self.display = display
        displayingView?.isHidden = false
        displaySegmentedControl?.selectedSegmentIndex = display == Display.List ? 0 : 1
    }
    
    private func refresh(callback: (Void) -> Void, failureCallback: (Void) -> Void) {
        service.getList(
            { movies in
                self.networkErrorView.isHidden = true
                self.displayingView.isHidden = false
                self.tableView.reloadData()
                self.collectionView.reloadData()
                callback()
            },
            failureCallback: { _ in
                self.networkErrorView.isHidden = false
                self.displayingView.isHidden = true
                failureCallback()
            },
            category: category
        )
    }
    
    private func refresh(callback: (Void) -> Void) {
        refresh(callback: callback, failureCallback: { _ in })
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        refresh(callback: { _ in refreshControl.endRefreshing() })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.movies(category).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt cellForRowAtIndexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "com.gerbil.GerbilFlicksCell") as? GerbilFlicksTableViewCell else {
            return GerbilFlicksTableViewCell()
        }
        
        let index = (cellForRowAtIndexPath as NSIndexPath).row
        let movie = service.movies(category)[index]
        
        cell.overviewLabel.text = movie.overview
        cell.titleLabel.text = movie.title
        
        if let url = URL(string: movie.imageUrl) {
            cell.movieImageView.setImageWith(url)
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.gerbil.GerbilFlicksCollectionCell", for: indexPath) as? GerbilFlicksCollectionViewCell else {
            return GerbilFlicksCollectionViewCell()
        }
        
        let index = indexPath.row
        let movie = service.movies(category)[index]
        
        if let url = URL(string: movie.imageUrl) {
            cell.movieImage.setImageWith(url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.movies(category).count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width * 3 / 4);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let destination = segue.destination as? GerbilFlicksDetailsViewController else {
            return
        }
        
        var indexPathOrNil: IndexPath? = nil
        if let cell = sender as? UITableViewCell {
            indexPathOrNil = tableView.indexPath(for: cell)
        } else if let cell = sender as? UICollectionViewCell {
            indexPathOrNil = collectionView.indexPath(for: cell)
        } else {
            return
        }
        
        if let indexPath = indexPathOrNil, indexPath.row < service.movies(category).count {
            tableView.deselectRow(at: indexPath, animated:true)
            destination.movie = service.movies(category)[indexPath.row]
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController else {
            return
        }
        
        // Hack: Go back to movies list if details are being shown at the moment
        if navigationController.visibleViewController is GerbilFlicksDetailsViewController {
            navigationController.popViewController(animated: false)
        }

        let destination = navigationController.visibleViewController
        
        if let vc = destination as? GerbilFlicksViewController {
            switch (tabBarController.selectedIndex) {
            case 1:
                vc.category = MovieCategory.TopRated
                break
            default:
                vc.category = MovieCategory.NowPlaying
            }
            
            vc.setDisplaying(self.display)
            vc.refreshView(force: true)
        }
    }
    
    enum Display {
        case List
        case Grid
    }
}

