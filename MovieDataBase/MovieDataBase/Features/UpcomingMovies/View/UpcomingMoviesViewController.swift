//
//  UpcomingMoviesViewController.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let cellIdentifier = String(describing: MovieTableViewCell.self)

    init() {
        super.init(nibName: String(describing: UpcomingMoviesViewController.self),
                   bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main),
                           forCellReuseIdentifier: cellIdentifier)
    }
}

extension UpcomingMoviesViewController: UITableViewDelegate {

}

extension UpcomingMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? MovieTableViewCell
            else { return UITableViewCell() }
        return cell
    }


}
