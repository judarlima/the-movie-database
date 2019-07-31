//
//  UpcomingMoviesPresenter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//


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

final class UpcomingMoviesPresenterImpl: UpcomingMoviesPresenter {
    weak var viewController: UpcomingMoviesDisplay?

    func presentMovies(movies: [Upcoming.Movie]) {
        let moviesViewModel = movies.map { movie -> MovieViewModel in
            return MovieViewModel(id: movie.id,
                                  title: movie.title,
                                  poster: movie.poster,
                                  backdrop: movie.backdrop,
                                  genre: "Genre: \(movie.genres)",
                overview: movie.overview,
                releaseDate: "Release Date: \(movie.releaseDate)",
                accessibilityLabel: shortAccessibilityString(movie: movie))
        }
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayMovies(viewModels: moviesViewModel)
        }
    }

    private func shortAccessibilityString(movie: Upcoming.Movie) -> String {
        let accessibilityString = movie.title + "Genre: \(movie.genres)" +
        "Release Data: \(movie.releaseDate)"

        return accessibilityString
    }

    private func detailedAccessibilityString(movie: Upcoming.Movie) -> String {
        let accessibilityString = movie.title + "Overview: \(movie.overview)" +
            "Genre: \(movie.genres)" + "Release Data: \(movie.releaseDate)"

        return accessibilityString
    }

    func presentMovieDetails(movie: Upcoming.Movie) {
        let viewModel = MovieViewModel(id: movie.id,
                                       title: movie.title,
                                       poster: movie.poster,
                                       backdrop: movie.backdrop,
                                       genre: movie.genres,
                                       overview: movie.overview,
                                       releaseDate: movie.releaseDate,
                                       accessibilityLabel: detailedAccessibilityString(movie: movie))
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
