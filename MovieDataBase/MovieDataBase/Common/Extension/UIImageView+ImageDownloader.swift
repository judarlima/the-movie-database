//
//  UIImageView+ImageDownloader.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(url: String) {
        let imageDownloader = ImageDownloader()
        guard let imageUrl = URL(string: url) else { return }

        imageDownloader.loadImage(from: imageUrl) { (image) in
            self.image = image
        }
    }
}
