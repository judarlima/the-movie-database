//
//  UpcomingGatewaySetup.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

enum UpcomingGatewaySetup: ClientSetup {
    case upcoming(page: Int)

    var endpoint: String {
        switch self {
        case .upcoming(let page):
            return buildUrlString(API.URL.base + API.Path.upcoming, key: API.key, page: page)
        }
    }

    private func buildUrlString(_ url: String, key: String, page: Int) -> String {
        var urlComponents = URLComponents(string: url)
        let pageString = String(page)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: key),
                                     URLQueryItem(name: "page", value: pageString)]
        guard let urlString = urlComponents?.url?.absoluteString else { return url }
        return urlString
    }
}
