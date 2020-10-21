//
//  CLLocationCoordinate2D+Location.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import struct MapKit.CLLocationCoordinate2D

// MARK: - Location init
extension CLLocationCoordinate2D {
    init(
        _ location: Location
    ) {
        self = .init(
            latitude: location.latitude,
            longitude: location.longitude
        )
    }
}
