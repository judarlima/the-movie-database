//
//  UpcomingMoviesAdapter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesAdapterProtocol {
    func transform(from responseModel: UpcomingResponseModel) -> Upcoming
}

class UpcomingMoviesAdapter: UpcomingMoviesAdapterProtocol {
    func transform(from responseModel: UpcomingResponseModel) -> Upcoming {

        let movies = responseModel.movies.compactMap { movie -> Upcoming.Movie? in
            guard
                let posterURL = URL(string: API.URL.image + movie.posterPath),
                let backdropURL = URL(string: API.URL.image + movie.backdropPath) else
            { return nil }

            return Upcoming.Movie(title: movie.title,
                           originalTitle: movie.originalTitle,
                           posterPath: posterURL,
                           backdropPath: backdropURL,
                           genreIDS: movie.genreIDS,
                           releaseDate: movie.releaseDate,
                           overview: movie.overview)
        }

        return Upcoming(movies: movies)
    }
}
