//
//  UpcomingAdapter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesAdapterProtocol {
    func transform(from responseModel: UpcomingResponseModel) -> Upcoming
}

class UpcomingMoviesAdapter: UpcomingAdapterProtocol {
    func transform(from responseModel: UpcomingResponseModel) -> Upcoming {

        let movies = responseModel.movies.map {
            Upcoming.Movie(title: $0.title,
                           originalTitle: $0.originalTitle,
                           posterPath: API.URL.base + $0.posterPath,
                           backdropPath: API.URL.base + $0.backdropPath,
                           genreIDS: $0.genreIDS,
                           releaseDate: $0.releaseDate,
                           overview: $0.overview) }

        return Upcoming(movies: movies)
    }
}
