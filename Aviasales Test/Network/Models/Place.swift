//
//  Place.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

// MARK: - Place
struct Place {
    // MARK: Properties
    let name: String
    let airportName: String?
    let searchesCount: Int
    /// The IATA airport code, defined by the Internatoinal Air Transport Association
    let iata: String
    let location: Location
}

// MARK: - Decodable
extension Place: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case airportName = "airport_name"
        case searchesCount = "searches_count"
        case iata
        case location
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        self.name = try container.decode(
            String.self,
            forKey: .name
        )
        self.airportName = try container.decodeIfPresent(
            String.self,
            forKey: .airportName
        )
        self.searchesCount = try container.decode(
            Int.self,
            forKey: .searchesCount
        )
        self.iata = try container.decode(
            String.self,
            forKey: .iata
        )
        self.location = try container.decode(
            Location.self,
            forKey: .location
        )
    }
}
