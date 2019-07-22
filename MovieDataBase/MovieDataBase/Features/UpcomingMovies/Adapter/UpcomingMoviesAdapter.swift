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
    func transform(from responseModel: GenresResponseModel) -> MovieGenres
}

class UpcomingMoviesAdapter: UpcomingMoviesAdapterProtocol {

    func transform(from responseModel: UpcomingResponseModel) -> Upcoming {
        let movies = responseModel.movies.compactMap { movie -> Upcoming.Movie? in
            var poster: String = ""
            var backdrop: String = ""

            if let posterPath = movie.posterPath {
                poster = API.URL.image + posterPath
            }

            if let backdropPath = movie.backdropPath {
                backdrop = API.URL.image + backdropPath
            }

            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatterGet.date(from: movie.releaseDate) else { return nil }

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "d MMM, yyyy"
            let dateString = dateFormatterPrint.string(from: date)

            return Upcoming.Movie(id: movie.id,
                                  title: movie.title,
                                  originalTitle: movie.originalTitle,
                                  poster: poster,
                                  backdrop: backdrop,
                                  genreIDS: movie.genreIDS,
                                  releaseDate: dateString,
                                  overview: movie.overview)
        }
        
        return Upcoming(movies: movies, totalPages: responseModel.totalPages)
    }

    func transform(from responseModel: GenresResponseModel) -> MovieGenres {
        let genres = responseModel.genres.map { MovieGenres.Genre(id: $0.id, name: $0.name) }
        return MovieGenres(genres: genres)
    }
}
