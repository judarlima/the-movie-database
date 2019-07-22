//
//  UpcomingMoviesViewController.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

protocol UpcomingMoviesDisplayProtocol: AnyObject {
    func displayMovies(viewModels: [MovieViewModel])
    func showDetails(viewModel: MovieViewModel)
}

class UpcomingMoviesViewController: UIViewController {
    private let cellIdentifier = String(describing: MovieTableViewCell.self)
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    private let interactor: UpcomingMoviesInteractorProtocol
    private let coordinator: UpcomingCoordinatorProtocol
    private var movies: [MovieViewModel] = []

    init(interactor: UpcomingMoviesInteractorProtocol, coordinator: UpcomingCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
        super.init(nibName: String(describing: UpcomingMoviesViewController.self),
                   bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor.listUpcomingMovies()
    }

    private func setup() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main),
                           forCellReuseIdentifier: cellIdentifier)
    }
}

extension UpcomingMoviesViewController: UpcomingMoviesDisplayProtocol {
    func displayMovies(viewModels: [MovieViewModel]) {
        self.movies = viewModels
        tableView.reloadData()
        loadingView.isHidden = true 
    }

    func showDetails(viewModel: MovieViewModel) {
        coordinator.movieDetails(viewModel: viewModel)
    }
}

extension UpcomingMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = movies[indexPath.row]
        interactor.seeDetails(viewModel: viewModel)
    }
}

extension UpcomingMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? MovieTableViewCell
            else { return UITableViewCell() }
        let viewModel = movies[indexPath.row]
        cell.bind(viewModel: viewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastMovieAtList = movies.count - 1
        if indexPath.row == lastMovieAtList  {
            interactor.nextMoviesPage()
        }
    }
}

extension UpcomingMoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        let indexPath = IndexPath(item: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath,
                                   at: UITableView.ScrollPosition.middle, animated: true)
        interactor.cancelSearch()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        guard let textToSearch = searchBar.text else { return }
        let trimmedString = textToSearch.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor.searchMovies(text: trimmedString)
    }
}
