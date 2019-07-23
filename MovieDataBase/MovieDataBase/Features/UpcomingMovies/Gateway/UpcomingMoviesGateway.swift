//
//  UpcomingMoviesGateway.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesGatewayProtocol {
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming>) -> Void)
    func fetchFiltered(page: Int, query: String, completion: @escaping (Result<Upcoming>) -> Void)
}

class UpcomingMoviesGateway: UpcomingMoviesGatewayProtocol {
    private let client: ClientProtocol
    private let adapter: UpcomingMoviesAdapterProtocol
    private var genres: [Int: String] = [:]
    private lazy var queue: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 1
        operation.qualityOfService = .userInteractive
        return operation
    }()

    init(client: ClientProtocol, adapter: UpcomingMoviesAdapterProtocol) {
        self.client = client
        self.adapter = adapter
    }

    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming>) -> Void) {
        if self.genres.isEmpty { fetchGenres() }
        queue.addOperation {
            self.client.requestData(with: UpcomingMoviesGatewaySetup.upcoming(page: page)) { (result: Result<UpcomingResponseModel>) in
                switch result {
                case let .success(upcomingResponse):
                    let upcoming = self.adapter.transform(from: upcomingResponse, genres: self.genres)
                    completion(.success(upcoming))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func fetchGenres() {
        queue.addOperation {
            self.client.requestData(with: UpcomingMoviesGatewaySetup.genre) { (result: Result<GenresResponseModel>) in
                if case let .success(genreResponse) = result {
                    let movieGenres = self.adapter.transform(from: genreResponse)
                    movieGenres.genres.forEach { self.genres[$0.id] = $0.name }
                }
            }
        }
    }

    func fetchFiltered(page: Int, query: String, completion: @escaping (Result<Upcoming>) -> Void) {
        if self.genres.isEmpty { fetchGenres() }
        queue.addOperation {
            self.client.requestData(with: UpcomingMoviesGatewaySetup.search(movie: query, page: page)) {
                (result: Result<UpcomingResponseModel>) in
                switch result {
                case let .success(filteredMoviesResponse):
                    let filteredMovies = self.adapter.transform(from: filteredMoviesResponse, genres: self.genres)
                    completion(.success(filteredMovies))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
