//
//  UpcomingMoviesAdapterTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 23/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class UpcomingMoviesAdapterTests: XCTestCase {
    var sut: UpcomingMoviesAdapter!

    override func setUp() {
        self.sut = UpcomingMoviesAdapter()
    }

    func test_transforFromGenresResponseModel_thenReturnsGenres() {
        let responseModel = generateGenresResponseModel()

        let transformResult = sut.transform(from: responseModel)

        XCTAssertEqual(responseModel.genres.count, transformResult.genres.count)
        XCTAssertTrue(transformResult.genres.contains { $0.id == responseModel.genres.first?.id })
        XCTAssertTrue(transformResult.genres.contains { $0.name == responseModel.genres.first?.name })
        XCTAssertTrue(transformResult.genres.contains { $0.id == responseModel.genres.last?.id })
        XCTAssertTrue(transformResult.genres.contains { $0.name == responseModel.genres.last?.name })
    }

    func test_transforFromUpcomingResponseModel_thenReturnsUpcoming() {
        let responseModel = generateUpcomingResponseModel()
        let genres = [1: "Action", 2: "Fantasy"]
        let expectedMovie = Upcoming.Movie(id: 2, title: "Ai Que Vida", originalTitle: "",
                                           poster: "https://image.tmdb.org/t/p/w500/posterPath",
                                           backdrop: "https://image.tmdb.org/t/p/w500/backdropPath",
                                           genres: "Action, Fantasy",
                                           releaseDate: "30 Jun, 2019", overview: "overview text")
        let expectedModel = Upcoming(movies: [expectedMovie], totalPages: 1)

        let transformResult = sut.transform(from: responseModel, genres: genres)

        XCTAssertEqual(transformResult.totalPages, expectedModel.totalPages)
        XCTAssertEqual(transformResult.movies.first?.id, expectedModel.movies.first?.id)
        XCTAssertEqual(transformResult.movies.first?.title, expectedModel.movies.first?.title)
        XCTAssertEqual(transformResult.movies.first?.poster, expectedModel.movies.first?.poster)
        XCTAssertEqual(transformResult.movies.first?.backdrop, expectedModel.movies.first?.backdrop)
        XCTAssertEqual(transformResult.movies.first?.overview, expectedModel.movies.first?.overview)
        XCTAssertEqual(transformResult.movies.first?.releaseDate, expectedModel.movies.first?.releaseDate)
        XCTAssertEqual(transformResult.movies.first?.genres, expectedModel.movies.first?.genres)
    }

    private func generateGenresResponseModel() -> GenresResponseModel {
        let firstGenre = GenresResponseModel.Genre(id: 1, name: "Action")
        let lastGenre = GenresResponseModel.Genre(id: 2, name: "Fantasy")
        return GenresResponseModel(genres: [firstGenre, lastGenre])
    }

    private func generateUpcomingResponseModel() -> UpcomingResponseModel {
        let movie = UpcomingResponseModel.Movie(voteCount: 100, id: 2, video: false, voteAverage: 7.5,
                                            title: "Ai Que Vida", popularity: 100.0, posterPath: "/posterPath",
                                            originalLanguage: "", originalTitle: "",
                                            genreIDS: [1, 2], backdropPath: "/backdropPath", adult: false,
                                            overview: "overview text", releaseDate: "2019-06-30")
        return UpcomingResponseModel(movies: [movie], page: 1, totalResults: 1, totalPages: 1)
    }
}
