//
//  UpcomingMoviesGateway.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesGateway {
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming, ClientError>) -> Void)
    func fetchFiltered(page: Int, query: String, completion: @escaping (Result<Upcoming, ClientError>) -> Void)
}

class UpcomingMoviesGatewayImpl: UpcomingMoviesGateway {
    private let client: ClientProtocol
    private let adapter: UpcomingMoviesAdapter
    private var genres: [Int: String] = [:]
    private lazy var queue: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 1
        operation.qualityOfService = .userInteractive
        return operation
    }()

    init(client: ClientProtocol, adapter: UpcomingMoviesAdapter) {
        self.client = client
        self.adapter = adapter
    }

    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming, ClientError>) -> Void) {
        if self.genres.isEmpty { fetchGenres() }
        queue.addOperation { [weak self] in
            guard let gateway = self else { return }
            gateway.client.requestData(with: UpcomingMoviesGatewaySetup.upcoming(page: page)) { (result: Result<UpcomingResponseModel, ClientError>) in
                switch result {
                case let .success(upcomingResponse):
                    let upcoming = gateway.adapter.transform(from: upcomingResponse, genres: gateway.genres)
                    completion(.success(upcoming))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func fetchGenres() {
        queue.addOperation { [weak self] in
            guard let gateway = self else { return }
            gateway.client.requestData(with: UpcomingMoviesGatewaySetup.genre) { (result: Result<GenresResponseModel, ClientError>) in
                if case let .success(genreResponse) = result {
                    let movieGenres = gateway.adapter.transform(from: genreResponse)
                    movieGenres.genres.forEach { gateway.genres[$0.id] = $0.name }
                }
            }
        }
    }

    func fetchFiltered(page: Int, query: String, completion: @escaping (Result<Upcoming, ClientError>) -> Void) {
        if self.genres.isEmpty { fetchGenres() }
        queue.addOperation { [weak self] in
            guard let gateway = self else { return }
            gateway.client.requestData(with: UpcomingMoviesGatewaySetup.search(movie: query, page: page)) {
                (result: Result<UpcomingResponseModel, ClientError>) in
                switch result {
                case let .success(filteredMoviesResponse):
                    let filteredMovies = gateway.adapter.transform(from: filteredMoviesResponse, genres: gateway.genres)
                    completion(.success(filteredMovies))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
