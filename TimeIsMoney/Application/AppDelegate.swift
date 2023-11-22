//
//
// TimeIsMoney
// AppDelegate.swift
//
// Created by Alexander Kist on 16.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navController = UINavigationController()

        appCoordinator = AppCoordinator(navigationController: navController)

        appCoordinator?.start()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
}
