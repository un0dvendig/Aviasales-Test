//
//  MapModelController.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import Foundation
import protocol MapKit.MKAnnotation

// MARK: - Delegate
protocol MapModelControllerDelegate: AnyObject {
    typealias PageLoadingResult = Result<[MKAnnotation], Error>
    
    /// Handles start of the page loading process.
    func pageLoading()
    
    /// Handles result of the page loading process.
    ///
    /// - Parameters:
    ///    - result: The result of page loading process.
    func mainPageLoaded(
        with result: PageLoadingResult
    )
}

// MARK: - Model controller
final class MapModelController {
    // MARK: Properties
    weak var delegate: MapModelControllerDelegate?
    
    // MARK: Private properties
    private let initialLocation: Location
    private let finishLocation: Location
    
    // MARK: Initialization
    init(
        initialLocation: Location?,
        finishLocation: Location
    ) {
        if let initialLocation = initialLocation {
            self.initialLocation = initialLocation
        } else {
            let saintPetersburgLocation: Location = .init(
                longitude: 59.8029,
                latitude: 30.2678
            )
            self.initialLocation = saintPetersburgLocation
        }
        self.finishLocation = finishLocation
    }
        
    // MARK: - Methods
    public func loadPage() {
        DispatchQueue.main.async {
            self.delegate?.pageLoading()
        }
        
        // TODO: ...
    }
    
    // MARK: Private methods
}
