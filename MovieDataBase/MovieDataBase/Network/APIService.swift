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

class APIService: ServiceProtocol {
    func requestData<T: Decodable>(with setup: ServiceSetup, completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: setup.endpoint) else {
            completion(.failure(.urlNotFound))
            return
        }
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
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

                switch httpResponse.statusCode {
                case 200...299:
                    do {
                        let decoder = JSONDecoder()
                        let responseModel = try decoder.decode(T.self, from: data)
                        completion(.success(responseModel))
                    } catch {
                        completion(.failure(.couldNotParseObject))
                    }

                case 403:
                    completion(.failure(.authenticationRequired))

                case 404:
                    completion(.failure(.couldNotFindHost))

                case 500:
                    completion(.failure(.badRequest))

                default: break
                }
                }.resume()
        }
    }
}
