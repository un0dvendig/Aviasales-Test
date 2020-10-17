//
//  MapModelController.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import Foundation
import MapKit

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
    private let initialPlace: Place
    private let finishPlace: Place
    
    // MARK: Initialization
    init(
        initialPlace: Place?,
        finishPlace: Place
    ) {
        if let initialPlace = initialPlace {
            self.initialPlace = initialPlace
        } else {
            let saintPetersburgLocation: Location = .init(
                longitude: 59.8029,
                latitude: 30.2678
            )
            let saintPetersburgPlace: Place = .init(
                name: "Saint-Petersburg",
                airportName: "Pulkovo",
                searchesCount: 0,
                iata: "LED",
                location: saintPetersburgLocation
            )
            self.initialPlace = saintPetersburgPlace
        }
        self.finishPlace = finishPlace
    }
        
    // MARK: - Methods
    public func loadPage() {
        DispatchQueue.main.async {
            self.delegate?.pageLoading()
        }
        
        var annotations: [MKAnnotation] = []
        let startAnnotation = self.makeIATAAnnotation(
            usingPlace: self.initialPlace
        )
        annotations.append(
            startAnnotation
        )
        let finishAnnotation = self.makeIATAAnnotation(
            usingPlace: self.finishPlace
        )
        annotations.append(
            finishAnnotation
        )
        
        DispatchQueue.main.async {
            self.delegate?.mainPageLoaded(
                with: .success(annotations)
            )
        }
    }
}

// MARK: - MKAnnotation factory
extension MapModelController {
    private func makeIATAAnnotation(
        usingPlace place: Place
    ) -> MKAnnotation {
        let coordinate: CLLocationCoordinate2D = .init(
            place.location
        )
        let iata = place.iata
        
        let iataAnnotation: IATAAnnotation = .init(
            coordinate: coordinate,
            iata: iata
        )
        return iataAnnotation
    }
}
