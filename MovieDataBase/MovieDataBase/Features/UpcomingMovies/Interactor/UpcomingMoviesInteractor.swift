//
//  UpcomingMoviesInteractor.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesInteractor {
    func listUpcomingMovies()
    func nextMoviesPage()
    func seeDetails(viewModel: MovieViewModel)
    func searchMovies(query: String)
    func cancelSearch()
    func tryAgain()
}

fileprivate enum UpcomingInteractorRetryHandler {
    case listUpcomingMovies
    case searchMovies
    case nextMoviesPage
}

class UpcomingMoviesInteractorImpl: UpcomingMoviesInteractor {

    private let gateway: UpcomingMoviesGateway
    private let presenter: UpcomingMoviesPresenter

    private var cache: [Upcoming.Movie] = []
    private var totalPages = 0
    private var currentPage = 1
    private var isSearching = false
    private var searchQuery = ""
    private var lastUseCase: UpcomingInteractorRetryHandler?

    init(gateway: UpcomingMoviesGateway, presenter: UpcomingMoviesPresenter) {
        self.gateway = gateway
        self.presenter = presenter
    }

    func listUpcomingMovies() {
        self.lastUseCase = .listUpcomingMovies
        self.gateway.fetchUpcomingMovies(page: self.currentPage) { [weak self] (result) in
            guard let interactor = self else { return }
            switch result {
            case let .success(upcoming):
                interactor.isSearching = false
                interactor.totalPages = upcoming.totalPages
                interactor.cache = upcoming.movies
                interactor.presenter.presentMovies(movies: upcoming.movies)
            case let .failure(error):
                interactor.presenter.presentError(error: error.localizedDescription)
            }
        }
    }

    func searchMovies(query: String) {
        guard query != "" else { self.listUpcomingMovies(); return }
        self.searchQuery = query
        self.lastUseCase = .searchMovies
        self.gateway.fetchFiltered(page: 1, query: query) { [weak self] (result) in
            guard let interactor = self else { return }
            switch result {
            case let .success(filteredMovies):
                interactor.isSearching = true
                interactor.cache.removeAll()
                interactor.cache = filteredMovies.movies
                interactor.totalPages = filteredMovies.totalPages
                interactor.presenter.presentMovies(movies: filteredMovies.movies)
            case let .failure(error):
                interactor.presenter.presentError(error: error.localizedDescription)
            }
        }
    }

    func nextMoviesPage() {
        guard !isSearching else {
            presenter.presentEndList()
            return
        }
        if currentPage < totalPages {
            self.lastUseCase = .nextMoviesPage
            currentPage += 1
            self.nextUpcoming()
        } else {
            presenter.presentEndList()
        }
    }

    private func nextFilteredPage() {
        self.gateway.fetchFiltered(page: self.currentPage, query: self.searchQuery) { [weak self] (result) in
            guard let interactor = self else { return }
            switch result {
            case let .success(filteredMovies):
                interactor.cache.append(contentsOf: filteredMovies.movies)
                interactor.presenter.presentMovies(movies: filteredMovies.movies)
            case let .failure(error):
                interactor.presenter.presentError(error: error.localizedDescription)
            }
        }
    }

    private func nextUpcoming() {
        self.gateway.fetchUpcomingMovies(page: self.currentPage) { [weak self] (result) in
            guard let interactor = self else { return }
            switch result {
            case let .success(upcoming):
                interactor.cache.append(contentsOf: upcoming.movies)
                interactor.presenter.presentMovies(movies: interactor.cache)
            case let .failure(error):
                interactor.presenter.presentError(error: error.localizedDescription)
            }
        }
    }

    func cancelSearch() {
        cache.removeAll()
        isSearching = false
        currentPage = 1
        listUpcomingMovies()
    }
    
    func seeDetails(viewModel: MovieViewModel) {
        guard let selectedMovie = (cache.first { $0.id == viewModel.id }) else { return }
        presenter.presentMovieDetails(movie: selectedMovie)
    }

    func tryAgain() {
        guard let useCases = lastUseCase else { return }
        switch useCases {
        case .listUpcomingMovies:
            self.listUpcomingMovies()
        case .nextMoviesPage:
            self.nextMoviesPage()
        case .searchMovies:
            self.searchMovies(query: self.searchQuery)
        }
    }
}
