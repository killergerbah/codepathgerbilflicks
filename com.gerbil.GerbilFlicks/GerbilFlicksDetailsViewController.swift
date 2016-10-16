//
//  GerbilFlicksDetailsTableViewController.swift
//  GerbilFlicks
//
//  Created by R-J Lim on 10/14/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import UIKit

class GerbilFlicksDetailsViewController: UIViewController {
    
    let service = MovieDbService()
    var movie: Movie!
    
    @IBOutlet weak var overviewScrollView: UIScrollView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewContainerView: UIView!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.runtimeLabel.text = ""
        self.popularityLabel.text = ""
        self.detailsView.alpha = 0.0

        service.getDetails(movie.id, callback: { details in
            self.runtimeLabel.text = self.formatRuntime(details.runtime)
            self.popularityLabel.text =  "Rating: " + String(format: "%.2f", details.popularity)
            self.genresLabel.text = details.genres.joined(separator: ", ")
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
                self.contentView.frame.origin.y += self.detailsView.frame.size.height
                self.detailsView.alpha += 1.0
            }, completion:nil)
        },
        failureCallback: { _ in
        })
        
    }
    
    private func formatRuntime(_ runtime: TimeInterval) -> String {
        let hours = Int(runtime) / 3600
        let minutes = Int(runtime) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewLabel.text = movie.overview
        overviewLabel.sizeToFit()
        overviewScrollView.contentSize = CGSize(width: overviewScrollView.frame.size.width, height: overviewContainerView.frame.origin.y + dateLabel.frame.size.height + titleLabel.frame.size.height + overviewLabel.frame.size.height + detailsView.frame.size.height + 150)
        
        if let backgroundUrl = URL(string: movie.backgroundUrl) {
            backgroundImageView.setImageWith(backgroundUrl)
        }
        
        if let date = movie.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        titleLabel.text = movie.title
        
        perform(#selector(autoScroll), with: nil, afterDelay: 0.1)
    }
    
    func autoScroll() {
        overviewScrollView.scrollRectToVisible(CGRect(x: 0, y: overviewContainerView.frame.origin.y + overviewLabel.frame.size.height + 100, width: 1, height: 1), animated: true)
    }

}
