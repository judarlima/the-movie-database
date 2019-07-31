//
//  Result.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failure(ClientError)
}
