//
//  MainCoordinator.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

class MainCoordinator {
    public static let shared = MainCoordinator()
    let navigationController: UINavigationController

    private init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
//        let presenter = CitiesListPresenter()
//        let manager = CityManager(dataHandler: JsonDataHandler())
//        let interactor = CitiesListInteractor(presenter: presenter, manager: manager)
//        let viewController = CitiesListViewController(interactor: interactor)
//        presenter.viewController = viewController
//        navigationController.pushViewController(viewController, animated: false)
    }
}
