//
//  MapAssembler.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import Swinject
import SwinjectAutoregistration

// MARK: - Assembler
struct MapAssembler {
    // MARK: Properties
    private let assembler: Assembler
    
    // MARK: Private properties
    public var resolver: Resolver {
        self.assembler.resolver
    }
    
    // MARK: Initialization
    public init(
        parent: Assembler?
    ) {
        self.assembler = Assembler(
            [
                MapAssembly()
            ],
            parent: parent
        )
    }
}

// MARK: - Assembly
struct MapAssembly: Assembly {
    func assemble(
        container: Container
    ) {
        // MARK: View controller
        container.register(
            MapViewController.self
        ) { (
            resolver,
            initialPlace: Place?,
            finishPlace: Place
        ) -> MapViewController in
            let modelController = resolver ~> (
                MapModelController.self,
                arguments: (
                    initialPlace,
                    finishPlace
                )
            )
            let viewController = MapViewController(
                modelController: modelController
            )
            viewController.router = resolver.resolve(
                MapRouter.self,
                argument: viewController as UIViewController
            )
            return viewController
        }
        
        // MARK: Model controller
        container.register(
            MapModelController.self
        ) { (
            resolver,
            initialPlace: Place?,
            finishPlace: Place
        ) -> MapModelController in
            let modelController = MapModelController(
                initialPlace: initialPlace,
                finishPlace: finishPlace
            )
            return modelController
        }
        
        // MARK: Router
        container.register(
            MapRouter.self
        ) { (
            _,
            navigationContext: UIViewController
        ) -> MapRouter in
            let router = MapRouter(
                navigationContext: navigationContext
            )
            return router
        }
    }
}


