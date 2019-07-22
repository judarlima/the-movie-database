//
//  UpcomingMoviesPresenter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {
    let id: Int
    let title: String
    let poster: String
    let backdrop: String
    let genre: String
    let overview: String
    let releaseDate: String
}

protocol UpcomingMoviesPresenterProtocol {
    func presentMovies(movies: [Upcoming.Movie], genres: [Int: String])
    func presentMovieDetails(movie: Upcoming.Movie, genres: [Int: String])
}

class UpcomingMoviesPresenter: UpcomingMoviesPresenterProtocol {
    weak var viewController: UpcomingMoviesDisplayProtocol?

    func presentMovies(movies: [Upcoming.Movie], genres: [Int: String]) {
        let moviesViewModel = movies.map { movie -> MovieViewModel in

            let genresString = generateGenreString(genreIDS: movie.genreIDS,
                                                   genres: genres)

            return MovieViewModel(id: movie.id,
                                  title: movie.title,
                                  poster: movie.poster,
                                  backdrop: movie.backdrop,
                                  genre: "Genre: \(genresString)",
                overview: movie.overview,
                releaseDate: "Release Date: \(movie.releaseDate)")
        }
        DispatchQueue.main.async {
            self.viewController?.displayMovies(viewModels: moviesViewModel)
        }
    }

    func presentMovieDetails(movie: Upcoming.Movie, genres: [Int : String]) {
        let genresString = generateGenreString(genreIDS: movie.genreIDS,
                                               genres: genres)
        let viewModel = MovieViewModel(id: movie.id,
                                       title: movie.title,
                                       poster: movie.poster,
                                       backdrop: movie.backdrop,
                                       genre: genresString,
                                       overview: movie.overview,
                                       releaseDate: movie.releaseDate)
        DispatchQueue.main.async {
            self.viewController?.showDetails(viewModel: viewModel)
        }
    }

    private func generateGenreString(genreIDS: [Int], genres: [Int: String]) -> String {
        return genreIDS.compactMap { genre -> String? in
            return genres[genre]
            }.joined(separator: ", ")
    }
}
