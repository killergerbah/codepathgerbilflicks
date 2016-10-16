//
//  MovieDetails.swift
//  GerbilFlicks
//
//  Created by R-J Lim on 10/15/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import Foundation

class MovieDetails {
    
    let genres: [String]
    let popularity: Double
    let runtime: TimeInterval
    let tagLine: String
    
    init(genres: [String], popularity: Double, runtime: TimeInterval, tagLine: String) {
        self.genres = genres
        self.popularity = popularity
        self.runtime = runtime
        self.tagLine = tagLine
    }
}
