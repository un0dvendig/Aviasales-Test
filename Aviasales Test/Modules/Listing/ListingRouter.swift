//
//  ListingRouter.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import UIKit
import SwinjectAutoregistration

final class ListingRouter: Router {
    enum Destination {
        case map(
            initialPlace: Place?,
            finishPlace: Place
        )
    }

    private weak var navigationContext: UIViewController?
    private let mapAssembler: MapAssembler

    // MARK: - Initializer
    init(
        navigationContext: UIViewController,
        mapAssembler: MapAssembler
    ) {
        self.navigationContext = navigationContext
        self.mapAssembler = mapAssembler
    }

    // MARK: - Navigator
    func navigate(
        to destination: ListingRouter.Destination
    ) {
        switch destination {
        case .map(
            let initialPlace,
            let finishPlace
        ):
            let vc = self.mapAssembler.resolver ~> (
                MapViewController.self,
                arguments: (
                    initialPlace,
                    finishPlace
                )
            )
            vc.modalPresentationStyle = .fullScreen
            self.navigationContext?.navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }
}

