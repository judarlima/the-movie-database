//
//  UpcomingMoviesPresenterTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class UpcomingMoviesPresenterTests: XCTestCase {
    var sut: UpcomingMoviesPresenterImpl!
    var viewControllerMock: UpcomingMoviesViewControllerMock!

    override func setUp() {
        self.sut = UpcomingMoviesPresenterImpl()
        self.viewControllerMock = UpcomingMoviesViewControllerMock()
        sut.viewController = viewControllerMock
    }

    func test_presentMovies_thenViewControllerDisplayMovies() {
        let expectedMovie = generateMovie()

        sut.presentMovies(movies: [expectedMovie])

        let presenterExpectation = expectation(description: "Test after 0.3 seconds")
        let result = XCTWaiter.wait(for: [presenterExpectation], timeout: 0.3)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(expectedMovie.id, viewControllerMock.presentedMovies.first?.id)
            XCTAssertEqual(expectedMovie.title, viewControllerMock.presentedMovies.first?.title)
            XCTAssertEqual(expectedMovie.poster, viewControllerMock.presentedMovies.first?.poster)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func test_presentError_thenViewControllerDisplayError() {
        sut.presentError(error: ClientError.authenticationRequired.localizedDescription)

        let presenterExpectation = expectation(description: "Test after 0.3 seconds")
        let result = XCTWaiter.wait(for: [presenterExpectation], timeout: 0.3)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(viewControllerMock.errorWasPresented)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func test_presentEndList_thenViewControllerDisplayEndList() {
        sut.presentEndList()

        let presenterExpectation = expectation(description: "Test after 0.3 seconds")
        let result = XCTWaiter.wait(for: [presenterExpectation], timeout: 0.3)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(viewControllerMock.displayEndListWasCalled)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func test_presentMovieDetails_thenViewControllerDisplayMovieDetails() {
        let presentedMovieDetail = generateMovie()

        sut.presentMovieDetails(movie: presentedMovieDetail)

        let presenterExpectation = expectation(description: "Test after 0.3 seconds")
        let result = XCTWaiter.wait(for: [presenterExpectation], timeout: 0.3)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(presentedMovieDetail.id, viewControllerMock.presentedDetails?.id)
            XCTAssertEqual(presentedMovieDetail.title, viewControllerMock.presentedDetails?.title)
            XCTAssertEqual(presentedMovieDetail.poster, viewControllerMock.presentedDetails?.poster)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    private func generateMovie() -> Upcoming.Movie {
        return Upcoming.Movie(id: 777,
                              title: "Mocked Movie",
                              originalTitle: "Original Title",
                              poster: "poster",
                              backdrop: "",
                              genres: "",
                              releaseDate: "",
                              overview: "")
    }
}
