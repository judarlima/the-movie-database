//
//  UpcomingMoviesInteractor.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesInteractorProtocol {
    func listUpcomingMovies()
    func nextMoviesPage()
    func seeDetails(viewModel: MovieViewModel)
    func searchMovies(query: String)
    func cancelSearch()
}

class UpcomingMoviesInteractor: UpcomingMoviesInteractorProtocol {
    private let gateway: UpcomingMoviesGatewayProtocol
    private let presenter: UpcomingMoviesPresenterProtocol

    private var cache: [Upcoming.Movie] = []
    private var totalPages = 0
    private var currentPage = 1
    private var isFiltered = false
    private var searchText = ""

    init(gateway: UpcomingMoviesGatewayProtocol, presenter: UpcomingMoviesPresenterProtocol) {
        self.gateway = gateway
        self.presenter = presenter
    }

    func listUpcomingMovies() {
        self.gateway.fetchUpcomingMovies(page: self.currentPage) { (result) in
            switch result {
            case let .success(upcoming):
                self.isFiltered = false
                self.totalPages = upcoming.totalPages
                self.cache = upcoming.movies
                self.presenter.presentMovies(movies: upcoming.movies)
            case .failure(_): break
            }
        }
    }

    func searchMovies(query: String) {
        guard query != "" else { self.listUpcomingMovies(); return }
        self.searchText = query
        self.gateway.fetchFiltered(page: 1, query: query) { (result) in
            switch result {
            case let .success(filteredMovies):
                self.isFiltered = true
                self.cache.removeAll()
                self.cache = filteredMovies.movies
                self.totalPages = filteredMovies.totalPages
                self.presenter.presentMovies(movies: filteredMovies.movies)
            case .failure(_): return
            }
        }
    }

    func nextMoviesPage() {
        if currentPage < totalPages {
            currentPage += 1
            if self.isFiltered {
                self.nextFilteredPage()
            } else {
                self.nextUpcoming()
            }
        } else {
            presenter.presentEndList()
        }
    }

    private func nextFilteredPage() {
        self.gateway.fetchFiltered(page: self.currentPage, query: self.searchText) { (result) in
            switch result {
            case let .success(filteredMovies):
                self.cache.append(contentsOf: filteredMovies.movies)
                self.presenter.presentMovies(movies: filteredMovies.movies)
            case .failure(_): return
            }
        }
    }

    private func nextUpcoming() {
        self.gateway.fetchUpcomingMovies(page: self.currentPage) { (result) in
            switch result {
            case let .success(upcoming):
                self.cache.append(contentsOf: upcoming.movies)
                self.presenter.presentMovies(movies: self.cache)
            case .failure(_):
                return
            }
        }
    }

    func cancelSearch() {
        cache.removeAll()
        isFiltered = false
        currentPage = 1
        listUpcomingMovies()
    }

    func seeDetails(viewModel: MovieViewModel) {
        guard let selectedMovie = (cache.first { $0.id == viewModel.id }) else { return }
        presenter.presentMovieDetails(movie: selectedMovie)
    }
}
