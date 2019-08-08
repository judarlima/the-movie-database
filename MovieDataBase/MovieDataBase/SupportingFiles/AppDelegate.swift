//
//  AppDelegate.swift
//  MovieDataBase
//
//  Created by Judar Lima on 20/07/19.
//  Copyright © 2019 Judar Lima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let coordinator = Coordinator(navigationController: navigationController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()

        coordinator.start()

        return true
    }
}

