//
//  Router.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import class UIKit.UIViewController

// MARK: - Router
protocol Router {
    associatedtype Destination

    func navigate(
        to destination: Destination
    )
}
