//
//  ListingAPI.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Moya

// MARK: - API
enum ListingAPI {
    case places(
        keyword: String
    )
}

// MARK: - TargetType
extension ListingAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppConstants.serverAPI)!
    }
    
    var path: String {
        switch self {
        case .places:
            return "places"
        }
    }
    
    var method: Method {
        switch self {
        case .places: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .places(
            let keyword
        ):
            var parameters: [String: Any] = [:]
            parameters.updateValue(
                keyword,
                forKey: "term"
            )
            // Adding localization
            parameters.updateValue(
                "ru",
                forKey: "locale"
            )
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .places: return [:]
        }
    }
}
