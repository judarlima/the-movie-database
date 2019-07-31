//
//  UpcomingMoviesPresenterMock.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

@testable import MovieDataBase

class UpcomingMoviesPresenterMock: UpcomingMoviesPresenter {
    var presentEndListWasCalled = false
    var presentedMovies: [Upcoming.Movie] = []
    var presentedMovieDetail: Upcoming.Movie?
    var presentedError: String?

    func presentMovies(movies: [Upcoming.Movie]) {
        self.presentedMovies = movies
    }

    func presentEndList() {
        presentEndListWasCalled = true
    }

    func presentMovieDetails(movie: Upcoming.Movie) {
        presentedMovieDetail = movie
    }

    func presentError(error: String) {
        presentedError = error
    }
}
