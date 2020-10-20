//
//  ListingServiceImlp.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Moya

// MARK: - ListingServiceImpl
public class ListingServiceImpl{
    // MARK: Properties
    enum CustomErrors: Error {
        case cannotReadFile
    }
    
    // MARK: Private properties
    private let provider: MoyaProvider<ListingAPI>
    private var currentRequest: Cancellable?
    
    // MARK: Initialization
    init(
        provider: MoyaProvider<ListingAPI>
    ) {
        self.provider = provider
    }
}

// MARK: - ListingService
extension ListingServiceImpl: ListingService {
    func getPlaces(
        usingKeyword keyword: String,
        then handler: @escaping (Result<[Place], MoyaError>) -> Void
    ) {
        if self.currentRequest != nil {
            self.currentRequest?.cancel()
            self.currentRequest = nil
        }
        
        let request = self.provider.request(
            .places(
                keyword: keyword
            )
        ) { (result) in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let places = try filteredResponse.map(
                        [Place].self
                    )
                    handler(.success(places))
                } catch let moyaError as MoyaError {
                    handler(.failure(moyaError))
                } catch {
                    let error = MoyaError.underlying(error, response)
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
            self.currentRequest = nil
        }
        
        self.currentRequest = request
    }
}
