//
//  Movie.swift
//  MovieSearch
//
//  Created by Darin Marcus Armstrong on 6/28/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let rating: Int
    let overview: String
    let poster: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case rating = "vote_average"
        case overview
        case poster = "poster_path"
    }
    
}
