//
//  UpcomingMoviesPresenter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
import UIKit

struct ErrorViewModel {
    let alert: UIAlertController
}

protocol UpcomingMoviesPresenter {
    func presentEndList()
    func presentMovies(movies: [Upcoming.Movie])
    func presentMovieDetails(movie: Upcoming.Movie)
    func presentError(error: String)
}

class UpcomingMoviesPresenterImpl: UpcomingMoviesPresenter {
    weak var viewController: UpcomingMoviesDisplay?

    func presentMovies(movies: [Upcoming.Movie]) {
        let moviesViewModel = movies.map { movie -> MovieViewModel in

            return MovieViewModel(id: movie.id,
                                  title: movie.title,
                                  poster: movie.poster,
                                  backdrop: movie.backdrop,
                                  genre: "Genre: \(movie.genres)",
                overview: movie.overview,
                releaseDate: "Release Date: \(movie.releaseDate)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayMovies(viewModels: moviesViewModel)
        }
    }

    func presentMovieDetails(movie: Upcoming.Movie) {
        let viewModel = MovieViewModel(id: movie.id,
                                       title: movie.title,
                                       poster: movie.poster,
                                       backdrop: movie.backdrop,
                                       genre: movie.genres,
                                       overview: movie.overview,
                                       releaseDate: movie.releaseDate)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showDetails(viewModel: viewModel)
        }
    }

    func presentError(error: String) {
        let alertView = UIAlertController(title: "Houston, We Have a Problem.",
                                          message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (_) in
            self.viewController?.tryAgain()
        }
        alertView.addAction(action)
        let errorViewModel = ErrorViewModel(alert: alertView)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showError(viewModel: errorViewModel)
        }
    }

    func presentEndList() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayEndList()
        }
    }
}
