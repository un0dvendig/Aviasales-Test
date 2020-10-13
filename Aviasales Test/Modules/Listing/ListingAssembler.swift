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
        // Navigation controller
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
        
        // View controller
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
            return viewController
        }
        
        // Model controller
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
    }
}

