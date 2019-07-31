//
//  URLSessionProtocol.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//
import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
