//
//  Location.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

// MARK: - Location
struct Location {
    // MARK: Properties
    let longitude: Double
    let latitude: Double
}

// MARK: - Decodable
extension Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        self.longitude = try container.decode(
            Double.self,
            forKey: .longitude
        )
        self.latitude = try container.decode(
            Double.self,
            forKey: .latitude
        )
    }
}
