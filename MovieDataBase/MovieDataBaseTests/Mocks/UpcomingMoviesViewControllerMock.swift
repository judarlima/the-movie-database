//
//  UpcomingMoviesViewControllerMock.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

@testable import MovieDataBase

class UpcomingMoviesViewControllerMock: UpcomingMoviesDisplay {
    var presentedMovies: [MovieViewModel] = []
    var presentedDetails: MovieViewModel?
    var errorWasPresented = false
    var tryAgainWasCalled = false
    var displayEndListWasCalled = false

    func displayMovies(viewModels: [MovieViewModel]) {
        self.presentedMovies = viewModels
    }

    func showDetails(viewModel: MovieViewModel) {
        self.presentedDetails = viewModel
    }

    func showError(viewModel: ErrorViewModel) {
        self.errorWasPresented = true
    }

    func tryAgain() {
        tryAgainWasCalled = true
    }

    func displayEndList() {
        displayEndListWasCalled = true
    }
}
