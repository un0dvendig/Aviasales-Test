//
//  ListingService.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Moya

// MARK: - Protocol
protocol ListingService {
    func getPlaces(
        usingKeyword keyword: String,
        then handler: @escaping (Result<[Place], MoyaError>) -> Void
    )
}
