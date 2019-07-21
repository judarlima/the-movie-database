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
}

class UpcomingMoviesInteractor: UpcomingMoviesInteractorProtocol {
    private let gateway: UpcomingMoviesGatewayProtocol
    private let presenter: UpcomingMoviesPresenterProtocol

    init(gateway: UpcomingMoviesGatewayProtocol, presenter: UpcomingMoviesPresenterProtocol) {
        self.gateway = gateway
        self.presenter = presenter
    }

    func listUpcomingMovies() {
        gateway.fetchUpcomingMovies(page: 1) { (result) in
            switch result {
            case let .success(upcoming):
                self.presenter.presentMovies(movies: upcoming.movies)
            case .failure(_): break
            }
        }
    }
}
