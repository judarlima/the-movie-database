//
//  UpcomingMoviesPresenter.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {
    let title: String
    let poster: String
    let backdrop: String
    let genre: String
    let overview: String
    let releaseDate: String
}

protocol UpcomingMoviesPresenterProtocol {
    func presentMovies(movies: [Upcoming.Movie])
}

class UpcomingMoviesPresenter: UpcomingMoviesPresenterProtocol {
    weak var viewController: UpcomingMoviesDisplayProtocol?

    func presentMovies(movies: [Upcoming.Movie]) {
        let moviesViewModel = movies.map { MovieViewModel(title: $0.title,
                                                          poster: $0.poster.absoluteString,
                                                          backdrop: $0.backdrop.absoluteString,
                                                          genre: "Gênero",
                                                          overview: $0.overview,
                                                          releaseDate: $0.releaseDate) }
        DispatchQueue.main.async {
            self.viewController?.displayMovies(viewModel: moviesViewModel)
        }
    }
}
