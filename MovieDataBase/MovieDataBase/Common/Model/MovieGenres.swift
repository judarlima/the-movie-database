//
//  MovieGenres.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

struct MovieGenres {
    struct Genre {
        let id: Int
        let name: String
    }
    let genres: [Genre]
}
