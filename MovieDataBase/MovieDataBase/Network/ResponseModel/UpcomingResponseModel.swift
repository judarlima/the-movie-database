//
//  UpcomingResponseModel.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

struct UpcomingResponseModel: Decodable {

    struct Movie: Decodable {
        let voteCount, id: Int
        let video: Bool
        let voteAverage: Double
        let title: String
        let popularity: Double
        let posterPath: String
        let originalLanguage: String
        let originalTitle: String
        let genreIDS: [Int]
        let backdropPath: String
        let adult: Bool
        let overview: String
        let releaseDate: String

        enum CodingKeys: String, CodingKey {
            case voteCount = "vote_count"
            case id, video
            case voteAverage = "vote_average"
            case title, popularity
            case posterPath = "poster_path"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case genreIDS = "genre_ids"
            case backdropPath = "backdrop_path"
            case adult, overview
            case releaseDate = "release_date"
        }
    }

    struct Dates: Decodable {
        let maximum, minimum: String
    }

    let movies: [Movie]
    let page, totalResults: Int
    let dates: Dates
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalResults = "total_results"
        case dates, page
        case totalPages = "total_pages"
    }
}
