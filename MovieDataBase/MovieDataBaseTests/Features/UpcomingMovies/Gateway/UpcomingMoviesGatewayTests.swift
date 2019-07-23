//
//  UpcomingMoviesGatewayTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 23/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class ClientMock: ClientProtocol {
    var isFailure = false

    func requestData<T : Decodable>(with setup: ClientSetup, completion: @escaping (Result<T>) -> Void) {
        if isFailure {
            completion(.failure(ClientError.invalidHttpResponse))
            return
        } else {
            completion(generateData())
        }
    }

    private func generateData<T: Decodable>() -> Result<T> {
        guard
            let filePath = Bundle.main.path(forResource: "upcoming", ofType: "json")
            else {
                XCTFail("Could not mock data!")
                return .failure(ClientError.brokenData)
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath),
                                    options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(T.self, from: jsonData)
            return .success(responseModel)
        } catch { }
        return .failure(ClientError.brokenData)
    }
}

class UpcomingMoviesGatewayTests: XCTestCase {
    var sut: UpcomingMoviesGateway!
    var clientMock: ClientMock!
    var adapter: UpcomingMoviesAdapter!

    override func setUp() {
        self.clientMock = ClientMock()
        self.adapter = UpcomingMoviesAdapter()
        self.sut = UpcomingMoviesGateway(client: clientMock, adapter: adapter)
    }

    func test_fetchUpcomingMovies_whenClientReturnsSucess() {
        let gatewayExpectation = expectation(description: #function)
        let expectedMovieId = 617091
        var gatewayResult: Upcoming?

        sut.fetchUpcomingMovies(page: 1) { (result) in
            if case let .success(upcoming) = result {
                gatewayResult = upcoming
            } else {
                XCTFail("Result is different of \(Upcoming.self).")
            }
            gatewayExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { (_) in
            XCTAssertEqual(gatewayResult?.movies.first?.id, expectedMovieId)
        }
    }

    func test_fetchUpcomingMovies_whenClientReturnsFailure() {
        let gatewayExpectation = expectation(description: #function)
        clientMock.isFailure = true
        let expectedError = ClientError.invalidHttpResponse
        var gatewayResult: ClientError?

        sut.fetchUpcomingMovies(page: 1) { (result) in
            if case let .failure(error) = result {
                gatewayResult = error
            } else {
                XCTFail("Result is different of \(ClientError.self).")
            }
            gatewayExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { (_) in
            XCTAssertEqual(gatewayResult?.localizedDescription, expectedError.localizedDescription)
        }
    }

    func test_fetchFiltered_whenClientReturnsSucess() {
        let gatewayExpectation = expectation(description: #function)
        let expectedMovieId = 617091
        var gatewayResult: Upcoming?

        sut.fetchFiltered(page: 7, query: "query") { (result) in
            if case let .success(upcoming) = result {
                gatewayResult = upcoming
            } else {
                XCTFail("Result is different of \(Upcoming.self).")
            }
            gatewayExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { (_) in
            XCTAssertEqual(gatewayResult?.movies.first?.id, expectedMovieId)
        }
    }

    func test_fetchFiltered_whenClientReturnsFailure() {
        let gatewayExpectation = expectation(description: #function)
        clientMock.isFailure = true
        let expectedError = ClientError.invalidHttpResponse
        var gatewayResult: ClientError?

        sut.fetchFiltered(page: 2, query: "query") { (result) in
            if case let .failure(error) = result {
                gatewayResult = error
            } else {
                XCTFail("Result is different of \(ClientError.self).")
            }
            gatewayExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { (_) in
            XCTAssertEqual(gatewayResult?.localizedDescription, expectedError.localizedDescription)
        }
    }


}
