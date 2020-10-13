//
//  AppDelegate.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - UIResponder
@main
class AppDelegate: UIResponder {
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: Initialization
    override init() {
        super.init()
    }
    
    // MARK: Private methods
    private func createWindow() {
        let window = UIWindow(
            frame: UIScreen.main.bounds
        )
        let listingViewController = ViewController()
        let navigationController = UINavigationController(
            rootViewController: listingViewController
        )
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.createWindow()
        return true
    }
}
