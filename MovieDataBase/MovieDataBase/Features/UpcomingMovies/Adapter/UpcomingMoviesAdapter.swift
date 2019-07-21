//
//  UpcomingMoviesAdapter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
import UIKit

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
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatterGet.date(from: movie.releaseDate) else { return nil }

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "d MMM, yyyy"
            let dateString = dateFormatterPrint.string(from: date)

            return Upcoming.Movie(title: movie.title,
                                  originalTitle: movie.originalTitle,
                                  poster: posterURL,
                                  backdrop: backdropURL,
                                  genreIDS: movie.genreIDS,
                                  releaseDate: dateString,
                                  overview: movie.overview)
        }
        
        return Upcoming(movies: movies)
    }
}
