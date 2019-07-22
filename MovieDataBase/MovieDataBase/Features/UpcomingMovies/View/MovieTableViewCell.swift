//
//  MovieTableViewCell.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.genreLabel.text = nil
        self.releaseLabel.text = nil
        self.movieImageView.image = UIImage(named: "image_placeholder")
    }

    private func setup() {
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
    }

    func bind(viewModel: MovieViewModel) {
        self.titleLabel.text = viewModel.title
        self.genreLabel.text = viewModel.genre
        self.releaseLabel.text = viewModel.releaseDate
        self.movieImageView.loadImage(url: viewModel.poster)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.setSelected(false, animated: true)
    }
    
}
