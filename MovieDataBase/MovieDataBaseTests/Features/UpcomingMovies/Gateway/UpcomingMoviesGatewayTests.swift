//
//  UpcomingMoviesGatewayTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 23/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class UpcomingMoviesGatewayTests: XCTestCase {
    var sut: UpcomingMoviesGatewayImpl!
    var clientMock: ClientMock!
    var adapter: UpcomingMoviesAdapterImpl!

    override func setUp() {
        self.clientMock = ClientMock()
        self.adapter = UpcomingMoviesAdapterImpl()
        self.sut = UpcomingMoviesGatewayImpl(client: clientMock, adapter: adapter)
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
