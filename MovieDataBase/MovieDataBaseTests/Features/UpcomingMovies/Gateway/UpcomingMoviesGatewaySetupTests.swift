//
//  UpcomingMoviesGatewaySetupTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 23/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class UpcomingMoviesGatewaySetupTests: XCTestCase {
    var sut: UpcomingMoviesGatewaySetup!

    override func setUp() { }

    func test_UpcomingMoviesGatewaySetup_whenCaseUpcoming() {
        let expectedEndpoint = "https://api.themoviedb.org/3/" +
        "movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&page=10&language=en-US"

        sut = .upcoming(page: 10)

        XCTAssertEqual(sut.endpoint, expectedEndpoint)
    }

    func test_UpcomingMoviesGatewaySetup_whenCaseGenre() {
        let expectedEndpoint = "https://api.themoviedb.org/3/" +
        "genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US"

        sut = .genre

        XCTAssertEqual(sut.endpoint, expectedEndpoint)
    }

    func test_UpcomingMoviesGatewaySetup_whenCaseSearchMovie() {
        let expectedEndpoint = "https://api.themoviedb.org/3/" +
            "search/movie?query=Terminator&language=en-US&" +
        "api_key=1f54bd990f1cdfb230adb312546d765d&page=1&include_adult=false"

        sut = .search(movie: "Terminator", page: 1)

        XCTAssertEqual(sut.endpoint, expectedEndpoint)
    }
}
