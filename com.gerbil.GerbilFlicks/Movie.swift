//
//  Movie.swift
//  com.gerbil.GerbilFlicks
//
//  Created by R-J Lim on 10/14/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import Foundation

class Movie {
    
    let id: Int
    let title: String
    let overview: String
    let smallImageUrl: String
    let imageUrl: String
    let backgroundUrl: String
    let releaseDate: Date?
    
    init(id: Int, title: String, overview: String, smallImageUrl: String, imageUrl: String, backgroundUrl: String, releaseDate: Date?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.smallImageUrl = smallImageUrl
        self.imageUrl = imageUrl
        self.backgroundUrl = backgroundUrl
        self.releaseDate = releaseDate
    }
    
    var description: String {
        return "id=\(id) title=\(title) overview=\(overview) imageUrl=\(imageUrl)"
    }
}
