//
//  API+Constant.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

enum API {

    static let key = "1f54bd990f1cdfb230adb312546d765d"

    enum URL {
        static let base = "https://api.themoviedb.org/3"
        static let image = "https://image.tmdb.org/t/p/w500"
    }

    enum Path {
        static let upcoming = "/movie/upcoming"
    }
}
