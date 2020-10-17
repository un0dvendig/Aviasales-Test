//
//  MapRouter.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import UIKit
import SwinjectAutoregistration

final class MapRouter: Router {
    enum Destination {
        case listing
    }

    private weak var navigationContext: UIViewController?

    // MARK: - Initializer
    init(
        navigationContext: UIViewController
    ) {
        self.navigationContext = navigationContext
    }

    // MARK: - Navigator
    func navigate(
        to destination: MapRouter.Destination
    ) {
        switch destination {
        case .listing:
            self.navigationContext?.navigationController?.popViewController(
                animated: true
            )
        }
    }
}


