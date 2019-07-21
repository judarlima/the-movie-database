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
}

class UpcomingMoviesGateway: UpcomingMoviesGatewayProtocol {
    private let client: ClientProtocol
    private let adapter: UpcomingMoviesAdapterProtocol

    init(client: ClientProtocol, adapter: UpcomingMoviesAdapterProtocol) {
        self.client = client
        self.adapter = adapter
    }

    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming>) -> Void) {
        client.requestData(with: UpcomingMoviesGatewaySetup.upcoming(page: page)) { (result: Result<UpcomingResponseModel>) in
            switch result {
            case let .success(response):
                let upcoming = self.adapter.transform(from: response)
                completion(.success(upcoming))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
