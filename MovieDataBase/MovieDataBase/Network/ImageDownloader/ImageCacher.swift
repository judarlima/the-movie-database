//
//  ImageCacher.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

final class ImageCacher {
    private let cache: NSCache<NSString, UIImage>

    private init() {
        cache = NSCache<NSString, UIImage>()
    }

    static let shared = ImageCacher()

    func loadImage(for key: NSString) -> UIImage? {
        return cache.object(forKey: key)
    }

    func cache(image: UIImage, withKey key: NSString) {
        cache.setObject(image, forKey: key)
    }
}
