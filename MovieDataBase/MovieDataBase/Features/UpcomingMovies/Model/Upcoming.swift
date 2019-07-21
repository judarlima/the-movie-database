//
//  Upcoming.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
import UIKit

struct Upcoming {
    
    struct Movie {
        let title: String
        let originalTitle: String
        let poster: String
        let backdrop: String
        let genreIDS: [Int]
        let releaseDate: String
        let overview: String
    }

    let movies: [Movie]
    let totalPages: Int
}
