//
//  AppAssembler.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Moya
import Swinject
import SwinjectAutoregistration

// MARK: - Assembler
public struct AppAssembler {
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
        let assemblies: [Assembly] = [
            AppAssembly(),
            ListingAssembly()
        ]
        let assembler: Assembler = .init(
            assemblies,
            parent: parent
        )
        self.assembler = assembler
    }
}

// MARK: - Assembly
private struct AppAssembly: Assembly {
    func assemble(
        container: Container
    ) {
        // MARK: Assemblers
        container.autoregister(
            AppAssembler.self
        ) {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError(
                    "Could not cast delegate to type AppDelegate."
                )
            }
            return delegate.assembler
        }
        
        // MARK: Services
        container.register(
            ListingService.self
        ) { (_) in
            let provider = MoyaProvider<ListingAPI>(
                callbackQueue: DispatchQueue.global(qos: .utility)
            )
            let service = ListingServiceImpl(
                provider: provider
            )
            return service
        }
    }
}

