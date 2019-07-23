//
//  HttpClientMocks.swift
//  MovieDataBaseTests
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation
@testable import MovieDataBase

struct MockEntity: Decodable {
    let title: String
    let subtitle: String
}

class MockDataTask: URLSessionDataTaskProtocol {
    func resume() { }
}

enum MockClientSetup: ClientSetup {
    case none
    case some

    var endpoint: String {
        switch self {
        case .none:
            return ""
        case .some:
            return "https://www.google.com"
        }
    }
}

class URLSessionMock: URLSessionProtocol {
    var nextDataTask = MockDataTask()
    var statusCode: Int = 200
    var nextData: Data?
    var nextError: Error?
    var isInvalidResponse: Bool = false
    private (set) var lastURL: URL?

    func dataTask(with request: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request
        if isInvalidResponse {
            completionHandler(nextData, nil, nextError)
        } else {
            completionHandler(nextData, httpURLResponse(request: request, statusCode: statusCode), nextError)
        }
        nextDataTask.resume()
        return nextDataTask
    }

    func httpURLResponse(request: URL, statusCode: Int) -> URLResponse {
        return HTTPURLResponse(url: request, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
}
