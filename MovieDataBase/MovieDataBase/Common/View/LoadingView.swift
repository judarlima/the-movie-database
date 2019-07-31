//
//  LoadingView.swift
//  MovieDataBase
//
//  Created by Judar Lima on 22/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

final class LoadingView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    public func hide() {
        self.alpha = 0
        self.isHidden = true
        self.loader.stopAnimating()
    }

    public func show() {
        self.alpha = 1
        self.isHidden = false
        self.loader.startAnimating()
    }
}
