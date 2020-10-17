//
//  IATAAnnotation.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import MapKit

// MARK: - AITAAnnotation
final class IATAAnnotation: NSObject, MKAnnotation {
    // MARK: Properties
    let coordinate: CLLocationCoordinate2D
    let iata: String
    
    // MARK: Initialization
    init(
        coordinate: CLLocationCoordinate2D,
        iata: String
    ) {
        self.coordinate = coordinate
        self.iata = iata
    }
}
