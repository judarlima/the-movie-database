//
//  HttpClient.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol ClientProtocol {
    func requestData<T: Decodable>(with setup: ClientSetup, completion: @escaping (Result<T, ClientError>) -> Void)
}

final class APIClient: ClientProtocol {
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func requestData<T: Decodable>(with setup: ClientSetup, completion: @escaping (Result<T, ClientError>) -> Void) {
        guard let url = URL(string: setup.endpoint) else {
            completion(.failure(.urlNotFound))
            return
        }
            self.urlSession.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error {
                    completion(.failure(.unknown(error.localizedDescription)))
                    return
                }

                guard let data = data else {
                    completion(.failure(.brokenData))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidHttpResponse))
                    return
                }
                completion(self.convertResponse(httpResponse, data: data))
                return
            }.resume()
    }

    private func convertResponse<T: Decodable>(_ response: HTTPURLResponse, data: Data) -> Result<T, ClientError> {
        switch response.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(T.self, from: data)
                return .success(responseModel)
            } catch {
                return .failure(.couldNotParseObject)
            }
        case 403:
            return .failure(.authenticationRequired)
        case 404:
            return .failure(.couldNotFindHost)
        case 500:
            return .failure(.badRequest)
        default:
            return .failure(.unknown("Unexpected Error."))
        }
    }
}
