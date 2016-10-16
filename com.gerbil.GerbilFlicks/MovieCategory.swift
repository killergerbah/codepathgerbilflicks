//
//  MovieCategory.swift
//  GerbilFlicks
//
//  Created by R-J Lim on 10/16/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import Foundation

enum MovieCategory {
    case NowPlaying
    case TopRated
    
    var name: String {
        get {
            switch self {
            case .NowPlaying:
                return "Now Playing"
                
            case .TopRated:
                return "Top Rated"
            }
        }
    }
}
