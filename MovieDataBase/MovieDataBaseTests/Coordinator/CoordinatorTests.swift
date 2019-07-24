//
//  CoordinatorTests.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 23/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import XCTest
@testable import MovieDataBase

class CoordinatorTests: XCTestCase {
    var sut: Coordinator!
    var navigationController: UINavigationController!

    override func setUp() {
        self.navigationController = UINavigationController()
        self.sut = Coordinator(navigationController: navigationController)
    }

    func test_start_thenNavigationPushUpcomingMoviesViewController() {
        sut.start()

        XCTAssertEqual(sut.navigationController, navigationController)
        XCTAssertTrue(sut.navigationController.viewControllers.first is UpcomingMoviesViewController)
    }

    func test_movieDetails_thenNavigationPushMovieViewController() {
        let viewModel = MovieViewModel(id: 133, title: "title", poster: "",
                                       backdrop: "", genre: "", overview: "",
                                       releaseDate: "", accessibilityLabel: "")

        sut.movieDetails(viewModel: viewModel)

        XCTAssertEqual(sut.navigationController, navigationController)
        XCTAssertTrue(sut.navigationController.viewControllers.first is MovieViewController)
    }

}
