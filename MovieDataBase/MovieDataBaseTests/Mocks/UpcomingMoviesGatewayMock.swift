//
//  UpcomingMoviesGatewayMock.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
@testable import MovieDataBase

class UpcomingMoviesGatewayMock: UpcomingMoviesGateway {
    var error: ClientError?

    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Upcoming, ClientError>) -> Void) {
        guard let clientError = error else {
            completion(.success(generateUpcoming()))
            return
        }
        completion(.failure(clientError))
    }

    func fetchFiltered(page: Int, query: String, completion: @escaping (Result<Upcoming, ClientError>) -> Void) {
        guard let clientError = error else {
            completion(.success(generateUpcoming()))
            return
        }
        completion(.failure(clientError))
    }

    private func generateUpcoming() -> Upcoming {
        let movie = Upcoming.Movie(id: 10,
                                   title: "Mocked Movie",
                                   originalTitle: "Original Mocked Movie",
                                   poster: "",
                                   backdrop: "",
                                   genres: "",
                                   releaseDate: "",
                                   overview: "")
        return Upcoming(movies: [movie], totalPages: 2)
    }
}

