//
//  UpcomingMoviesGatewaySetup.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

enum UpcomingMoviesGatewaySetup: ClientSetup {
    case upcoming(page: Int)
    case genre
    case search(movie: String, page: Int)

    var endpoint: String {
        switch self {
        case .upcoming(let page):
            return upcomingQueryString(API.URL.base + API.Path.upcoming, page: page)
        case .genre:
            return genreQueryString(API.URL.base + API.Path.genre)
        case .search(let text, let page):
            return filteredMoviesQueryString(API.URL.base + API.Path.search,
                                             text: text,
                                             page: page)
        }
    }

    private func upcomingQueryString(_ url: String, page: Int) -> String {
        var urlComponents = URLComponents(string: url)
        let pageString = String(page)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: API.key),
                                     URLQueryItem(name: "page", value: pageString),
                                     URLQueryItem(name: "language", value: "en-US")]
        guard let urlString = urlComponents?.url?.absoluteString else { return url }
        return urlString
    }

    private func genreQueryString(_ url: String) -> String {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: API.key),
                                     URLQueryItem(name: "language", value: "en-US")]
        guard let urlString = urlComponents?.url?.absoluteString else { return url }
        return urlString
    }
    
    private func filteredMoviesQueryString(_ url: String, text: String, page: Int) -> String {
        var urlComponents = URLComponents(string: url)
        let pageString = String(page)
        let textString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        urlComponents?.queryItems = [URLQueryItem(name: "query", value: textString),
                                     URLQueryItem(name: "language", value: "en-US"),
                                     URLQueryItem(name: "api_key", value: API.key),
                                     URLQueryItem(name: "page", value: pageString),
                                     URLQueryItem(name: "include_adult", value: "false")]
        guard let urlString = urlComponents?.url?.absoluteString else { return url }
        return urlString
    }
}
