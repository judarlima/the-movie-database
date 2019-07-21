//
//  UpcomingListGateway.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol UpcomingMoviesGatewayProtocol {
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming>) -> Void)
}

class UpcomingGateway: UpcomingMoviesGatewayProtocol {
    private let client: ClientProtocol
    private let adapter: UpcomingMoviesAdapterProtocol

    init(client: ClientProtocol, adapter: UpcomingMoviesAdapterProtocol) {
        self.client = client
        self.adapter = adapter
    }

    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming>) -> Void) {
        client.requestData(with: UpcomingGatewaySetup.upcoming(page: page)) {
            [weak self] (result: Result<UpcomingResponseModel>) in
            guard let gateway = self else { return }
            switch result {
            case let .success(response):
                let upcoming = gateway.adapter.transform(from: response)
                completion(.success(upcoming))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
