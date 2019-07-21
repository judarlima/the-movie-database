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
    func moviesGenres()
}

class UpcomingMoviesInteractor: UpcomingMoviesInteractorProtocol {
    private lazy var queue: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 1
        operation.qualityOfService = .userInteractive
        return operation
    }()
    private let gateway: UpcomingMoviesGatewayProtocol
    private let presenter: UpcomingMoviesPresenterProtocol
    private var cache: [Upcoming.Movie] = []
    private var totalPages = 0
    private var page = 1
    private var genres: [Int: String] = [:]

    init(gateway: UpcomingMoviesGatewayProtocol, presenter: UpcomingMoviesPresenterProtocol) {
        self.gateway = gateway
        self.presenter = presenter
    }

    func listUpcomingMovies() {
        self.moviesGenres()
        queue.addOperation {
            self.gateway.fetchUpcomingMovies(page: self.page) { (result) in
                switch result {
                case let .success(upcoming):
                    self.totalPages = upcoming.totalPages
                    self.cache = upcoming.movies
                    self.presenter.presentMovies(movies: upcoming.movies, genres: self.genres)
                case .failure(_): break
                }
            }
        }
    }

    func nextMoviesPage() {
        if page < totalPages {
            page += 1
            queue.addOperation {
                self.gateway.fetchUpcomingMovies(page: self.page) { (result) in
                    switch result {
                    case let .success(upcoming):
                        self.cache.append(contentsOf: upcoming.movies)
                        self.presenter.presentMovies(movies: self.cache, genres: self.genres)
                    case .failure(_):
                        return
                    }
                }
            }
        }
    }

    func moviesGenres() {
        queue.addOperation {
            self.gateway.fetchGenres { (result) in
                switch result {
                case let .success(movieGenres):
                    movieGenres.genres.forEach { self.genres[$0.id] = $0.name }
                case .failure(_): return
                }
            }
        }
    }
}
