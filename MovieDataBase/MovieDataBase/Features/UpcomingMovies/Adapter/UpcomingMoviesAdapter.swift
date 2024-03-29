//
//  UpcomingMoviesAdapter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
import UIKit

protocol UpcomingMoviesAdapter {
    func transform(from responseModel: UpcomingResponseModel, genres: [Int: String]) -> Upcoming
    func transform(from responseModel: GenresResponseModel) -> MovieGenres
}

class UpcomingMoviesAdapterImpl: UpcomingMoviesAdapter {

    func transform(from responseModel: UpcomingResponseModel, genres: [Int: String]) -> Upcoming {
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
            guard
                let releaseDate = movie.releaseDate,
                let date = dateFormatterGet.date(from: releaseDate) else { return nil }

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "d MMM, yyyy"
            let dateString = dateFormatterPrint.string(from: date)

            guard
                let genreIDS = movie.genreIDS,
                let id = movie.id,
                let originalTitle = movie.originalTitle,
                let overview = movie.overview,
                let title = movie.title
            else { return nil }
            let genresString = generateGenreString(genreIDS: genreIDS, genres: genres)

            return Upcoming.Movie(id: id,
                                  title: title,
                                  originalTitle: originalTitle,
                                  poster: poster,
                                  backdrop: backdrop,
                                  genres: genresString,
                                  releaseDate: dateString,
                                  overview: overview)
        }
        return Upcoming(movies: movies, totalPages: responseModel.totalPages)
    }

    private func generateGenreString(genreIDS: [Int], genres: [Int: String]) -> String {
        return genreIDS.compactMap { genre -> String? in
            return genres[genre]
            }.joined(separator: ", ")
    }

    func transform(from responseModel: GenresResponseModel) -> MovieGenres {
        let genres = responseModel.genres.map { MovieGenres.Genre(id: $0.id, name: $0.name) }
        return MovieGenres(genres: genres)
    }
}
