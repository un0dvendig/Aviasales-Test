//
//  MapCommon.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import MapKit

// MARK: - MapCommon
final class MapCommon {
    // MARK: Initialization
    private init() {}

    // MARK: Methods
    static func createPolyline(
        usingCoordinates coordinates: [CLLocationCoordinate2D]
    ) -> MKPolyline {
        assert(
            coordinates.count == 2,
            "Should create popyline using 2 coordiantes, but used \(coordinates.count) instead"
        )
        
        var coordinates = coordinates
        let count = coordinates.count
        
        let geodesycalPolyline: MKGeodesicPolyline = .init(
            coordinates: &coordinates,
            count: count
        )
        return geodesycalPolyline
    }
    
    static func getBearingBetweenTwoPoints(
        point1 : MKMapPoint,
        point2 : MKMapPoint,
        inRadians: Bool = true
    ) -> Double {
        let lat1 = convertDegreesToRadians(point1.coordinate.latitude)
        let lon1 = convertDegreesToRadians(point1.coordinate.longitude)

        let lat2 = convertDegreesToRadians(point2.coordinate.latitude)
        let lon2 = convertDegreesToRadians(point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        if inRadians {
            return radiansBearing
        } else {
            return convertRadiansToDegrees(radiansBearing)
        }
    }
    
    static func convertRadiansToDegrees(
        _ radians: Double
    ) -> Double {
        return radians * 180 / .pi
    }

    static func convertDegreesToRadians(
        _ degrees: Double
    ) -> Double {
        return degrees * .pi / 180
    }
}
