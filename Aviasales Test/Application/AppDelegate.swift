//
//  AppDelegate.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit
import SwinjectAutoregistration

// MARK: - UIResponder
@main
class AppDelegate: UIResponder {
    // MARK: Properties
    let assembler: AppAssembler
    var window: UIWindow?
    
    // MARK: Initialization
    override init() {
        let assembler = AppAssembler(
            parent: nil
        )
        self.assembler = assembler
        super.init()
    }
    
    // MARK: Private methods
    private func createWindow() {
        let window = UIWindow(
            frame: UIScreen.main.bounds
        )
        
        let placeKeyword: String = "париж"
        let navigationController = self.assembler.resolver ~> (
            ListingNavigationController.self,
            argument: placeKeyword
        )
        navigationController.isNavigationBarHidden = true
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
