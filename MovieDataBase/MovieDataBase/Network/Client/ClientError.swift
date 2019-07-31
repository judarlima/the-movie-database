//
//  ClientError.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

enum ClientError: Error {
    case urlNotFound
    case authenticationRequired
    case brokenData
    case couldNotFindHost
    case couldNotParseObject
    case badRequest
    case invalidHttpResponse
    case unknown(String)

    var localizedDescription: String {
        switch self {
        case .urlNotFound: return "Could not found URL."
        case .authenticationRequired: return "Authentication is required."
        case .brokenData: return "The received data is broken."
        case .couldNotFindHost: return "The host was not found."
        case .badRequest: return "This is a bad request."
        case .couldNotParseObject: return "Can't convert the data to the object entity."
        case .invalidHttpResponse: return "HTTPURLResponse is nil"
        case let .unknown(message): return message
        }
    }
}

extension ClientError: Equatable {
    static func ==(lhs: ClientError, rhs: ClientError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
