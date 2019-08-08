//
//  MovieViewController.swift
//  MovieDataBase
//
//  Created by Judar Lima on 21/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var overview: UILabel!
    @IBOutlet private weak var genre: UILabel!
    @IBOutlet private weak var backdropImageView: UIImageView!
    private let viewModel: MovieViewModel

    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: MovieViewController.self),
                   bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }

    private func setup() {
        self.title = "Movie Details"
        view.isAccessibilityElement = true
        self.movieTitle.isAccessibilityElement = false
        self.releaseDate.isAccessibilityElement = false
        self.genre.isAccessibilityElement = false
        self.overview.isAccessibilityElement = false
        self.backdropImageView.isAccessibilityElement = false
    }

    private func bindViewModel() {
        self.movieTitle.text = viewModel.title
        self.releaseDate.text = viewModel.releaseDate
        self.genre.text = viewModel.genre
        self.overview.text = viewModel.overview
        self.posterImageView.loadImage(url: viewModel.poster)
        self.backdropImageView.loadImage(url: viewModel.backdrop)
        self.view.accessibilityLabel = viewModel.accessibilityLabel
    }
}
