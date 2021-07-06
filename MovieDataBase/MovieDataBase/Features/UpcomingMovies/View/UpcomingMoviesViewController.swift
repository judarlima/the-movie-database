//
//  UpcomingMoviesViewController.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

protocol UpcomingMoviesDisplay: AnyObject {
    func displayMovies(viewModels: [MovieViewModel])
    func showDetails(viewModel: MovieViewModel)
    func showError(viewModel: ErrorViewModel)
    func tryAgain()
    func displayEndList()
}

class UpcomingMoviesViewController: UIViewController {
    private let cellIdentifier = String(describing: MovieTableViewCell.self)
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet private weak var tableView: UITableView!
    private let footerView: LoadingView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        let footerView = LoadingView(frame: frame)
        return footerView
    }()
    private let interactor: UpcomingMoviesInteractor
    private let coordinator: UpcomingCoordinatorProtocol
    private var movies: [MovieViewModel] = []

    init(interactor: UpcomingMoviesInteractor, coordinator: UpcomingCoordinatorProtocol) {
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
        loadingView.show()
        interactor.listUpcomingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setup() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = self.footerView
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main),
                           forCellReuseIdentifier: cellIdentifier)
    }
}

extension UpcomingMoviesViewController: UpcomingMoviesDisplay {

    func showError(viewModel: ErrorViewModel) {
        loadingView.hide()
        present(viewModel.alert, animated: true, completion: nil)
    }

    func tryAgain() {
        interactor.tryAgain()
    }

    func displayEndList() {
        footerView.hide()
    }

    func displayMovies(viewModels: [MovieViewModel]) {
        self.footerView.hide()
        self.movies = viewModels
        tableView.reloadData()
        loadingView.hide()
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
            self.footerView.show()
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
        self.loadingView.show()
        guard let textToSearch = searchBar.text else { return }
        let trimmedString = textToSearch.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor.searchMovies(query: trimmedString)
    }
}
