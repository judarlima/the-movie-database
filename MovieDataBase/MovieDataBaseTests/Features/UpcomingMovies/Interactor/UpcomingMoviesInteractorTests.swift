//
//  UpcomingMoviesInteractorTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class UpcomingMoviesInteractorTests: XCTestCase {
    var sut: UpcomingMoviesInteractorImpl!
    var gatewayMock: UpcomingMoviesGatewayMock!
    var presenterMock: UpcomingMoviesPresenterMock!

    override func setUp() {
        self.presenterMock = UpcomingMoviesPresenterMock()
        self.gatewayMock = UpcomingMoviesGatewayMock()

        self.sut = UpcomingMoviesInteractorImpl(gateway: gatewayMock,
                                            presenter: presenterMock)
    }

    func test_listUpcomingMovies_whenGatewayReturnSucess_thenPresentMovies() {
        let expectedMovie = generateMovie()
        sut.listUpcomingMovies()
        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_listUpcomingMovies_whenGatewayReturnFailure_thenPresentError() {
        let expectedError = ClientError.couldNotFindHost
        gatewayMock.error = expectedError

        sut.listUpcomingMovies()

        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)
    }

    func test_searchMovies_whenGatewayReturnSucess_thenPresentMovies() {
        let expectedMovie = generateMovie()
        sut.searchMovies(query: "query")
        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_searchMovies_whenGatewayReturnFailure_thenPresentError() {
        let expectedError = ClientError.invalidHttpResponse
        gatewayMock.error = expectedError

        sut.searchMovies(query: "query")

        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)
    }

    func test_nextMoviesPage_withCurrentPageLessThanTotalPages_whenGatewayReturnSuccess_thenPresentMovies() {
        let expectedMovie = generateMovie()
        sut.listUpcomingMovies()
        sut.nextMoviesPage()

        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_nextMoviesPage_withCurrentPageGreaterThanTotalPages_thenPresentEndList() {
        sut.listUpcomingMovies()
        sut.nextMoviesPage()

        sut.nextMoviesPage()

        XCTAssertTrue(presenterMock.presentEndListWasCalled)
    }

    func test_nextMoviesPage_withSearchQuery_whenGatewayReturnSuccess_thenPresentMovies() {
        let expectedMovie = generateMovie()
        sut.searchMovies(query: "query")
        sut.nextMoviesPage()

        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_nextMoviesPage_withSearchQuery_whenGatewayReturnFailure_thenPresentError() {
        let expectedError = ClientError.brokenData

        sut.searchMovies(query: "query")
        gatewayMock.error = expectedError
        sut.nextMoviesPage()

        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)
    }

    func test_nextMoviesPage_whenGatewayReturnFailure_thenPresentError() {
        let expectedError = ClientError.badRequest

        sut.listUpcomingMovies()
        gatewayMock.error = expectedError
        sut.nextMoviesPage()

        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)
    }

    func test_cancelSearch_thenPresentMovies() {
        let expectedMovie = generateMovie()
        sut.cancelSearch()

        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_seeDetails_whenFoundMovieIdAtCache_thenPresentMovieDetails() {
        let viewModel = generateMovieViewModel(id: 10)

        sut.listUpcomingMovies()
        sut.seeDetails(viewModel: viewModel)

        XCTAssertEqual(viewModel.id, presenterMock.presentedMovieDetail?.id)
        XCTAssertEqual(viewModel.title, presenterMock.presentedMovieDetail?.title)
    }

    func test_seeDetails_whenNotFoundMovieIdAtCache_thenDoesNotCallPresentMovieDetails() {
        let viewModel = generateMovieViewModel(id: 33)

        sut.listUpcomingMovies()
        sut.seeDetails(viewModel: viewModel)

        XCTAssertNil(presenterMock.presentedMovieDetail)
    }

    func test_listUpcomingMoviesPresentsError_thenTryAgainPresentMovies() {
        let expectedMovie = generateMovie()
        let expectedError = ClientError.authenticationRequired
        gatewayMock.error = expectedError

        sut.listUpcomingMovies()

        XCTAssertTrue(presenterMock.presentedMovies.isEmpty)
        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)

        gatewayMock.error = nil
        sut.tryAgain()

        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_searchMoviesPresentsError_thenTryAgainPresentMovies() {
        let expectedMovie = generateMovie()
        let expectedError = ClientError.brokenData
        gatewayMock.error = expectedError

        sut.searchMovies(query: "query")

        XCTAssertTrue(presenterMock.presentedMovies.isEmpty)
        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)

        gatewayMock.error = nil
        sut.tryAgain()

        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    func test_nextPagePresentsError_thenTryAgainPresentMovies() {
        let expectedMovie = generateMovie()
        sut.listUpcomingMovies()
        let expectedError = ClientError.authenticationRequired
        gatewayMock.error = expectedError
        sut.nextMoviesPage()

        XCTAssertEqual(expectedError.localizedDescription, presenterMock.presentedError)

        gatewayMock.error = nil
        sut.tryAgain()

        XCTAssertEqual(expectedMovie.id, presenterMock.presentedMovies.first?.id)
        XCTAssertEqual(expectedMovie.title, presenterMock.presentedMovies.first?.title)
        XCTAssertEqual(expectedMovie.originalTitle, presenterMock.presentedMovies.first?.originalTitle)
    }

    private func generateMovie() -> Upcoming.Movie {
        return Upcoming.Movie(id: 10,
                              title: "Mocked Movie",
                              originalTitle: "Original Mocked Movie",
                              poster: "",
                              backdrop: "",
                              genres: "",
                              releaseDate: "",
                              overview: "")
    }

    private func generateMovieViewModel(id: Int) -> MovieViewModel {
        return MovieViewModel(id: id,
                              title: "Mocked Movie",
                              poster: "",
                              backdrop: "",
                              genre: "",
                              overview: "",
                              releaseDate: "",
                              accessibilityLabel: "")
    }
}


