//
//  ListingAssembler.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Swinject
import SwinjectAutoregistration

// MARK: - Assembler
struct ListingAssembler {
    // MARK: Properties
    let assembler: Assembler
    
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
                ListingAssembly()
            ],
            parent: parent
        )
    }
}

// MARK: - Assembly
struct ListingAssembly: Assembly {
    func assemble(
        container: Container
    ) {
        // MARK: Navigation controller
        container.register(
            ListingNavigationController.self
        ) { (
            resolver,
            placeKeyword: String
        ) -> ListingNavigationController in
            let viewController = resolver ~> (
                ListingViewController.self,
                argument: placeKeyword
            )
            let navigationController = ListingNavigationController(
                rootViewController: viewController
            )
            return navigationController
        }
        
        // MARK: View controller
        container.register(
            ListingViewController.self
        ) { (
            resolver,
            placeKeyword: String
        ) -> ListingViewController in
            let modelController = resolver ~> (
                ListingModelController.self,
                argument: placeKeyword
            )
            let viewController = ListingViewController(
                modelController: modelController
            )
            viewController.router = resolver.resolve(
                ListingRouter.self,
                argument: viewController as UIViewController
            )
            return viewController
        }
        
        // MARK: Model controller
        container.register(
            ListingModelController.self
        ) { (
            resolver,
            placeKeyword: String
        ) -> ListingModelController in
            let listingService = resolver ~> ListingService.self
            let modelController = ListingModelController(
                placeKeyword: placeKeyword,
                listingService: listingService
            )
            return modelController
        }
        
        // MARK: Router
        container.register(
            ListingRouter.self
        ) { (
            resolver,
            navigationContext: UIViewController
        ) -> ListingRouter in
            let mapAssembler = resolver ~> MapAssembler.self
            return ListingRouter(
                navigationContext: navigationContext,
                mapAssembler: mapAssembler
            )
        }
        
        // MARK: Assemblers
        container.register(
            MapAssembler.self
        ) {
            let listingAssembler = $0 ~> ListingAssembler.self
            return MapAssembler(
                parent: listingAssembler.assembler
            )
        }
    }
}

