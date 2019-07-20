//
//  APIService.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    func requestData<T: Decodable>(with setup: ServiceSetup, completion: @escaping (Result<T>) -> Void)
}

class HttpClient: ServiceProtocol {
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func requestData<T: Decodable>(with setup: ServiceSetup, completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: setup.endpoint) else {
            completion(.failure(.urlNotFound))
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let client = self else { return }
            client.urlSession.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(.unknown(error.localizedDescription)))
                }

                guard let data = data else {
                    completion(.failure(.brokenData))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknown("Could not cast to HTTPURLResponse object.")))
                    return
                }
                completion(client.convertResponse(httpResponse, data: data))
                }.resume()
        }
    }

    private func convertResponse<T: Decodable>(_ response: HTTPURLResponse, data: Data) -> Result<T> {
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
