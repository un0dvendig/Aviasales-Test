//
//  ListingModelControllerImpl.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Foundation

// MARK: - Delegate
protocol ListingModelControllerDelegate: AnyObject {
    typealias PageLoadingResult = Result<[TableViewCellViewModel], Error>
    
    /// Handles start of the page loading process.
    func pageLoading()
    
    /// Handles result of the page loading process.
    ///
    /// - Parameters:
    ///    - result: The result of page loading process.
    func mainPageLoaded(
        with result: PageLoadingResult
    )
    
    /// Handles opening map with given place.
    ///
    /// - Parameters:
    ///     - place: A Place object, that should be used with the map.
    func openMap(
        usingPlace place: Place
    )
}

// MARK: - Model controller
final class ListingModelController {
    // MARK: Properties
    weak var delegate: ListingModelControllerDelegate?
    
    // MARK: Private properties
    private let placeKeyword: String
    private let listingService: ListingService
    
    // Data source
    private var places: [Place] = []
    
    // MARK: Initialization
    init(
        placeKeyword: String,
        listingService: ListingService
    ) {
        self.placeKeyword = placeKeyword
        self.listingService = listingService
    }
        
    // MARK: - Methods
    public func loadPage() {
        DispatchQueue.main.async {
            self.delegate?.pageLoading()
        }
        
        self.updateListing { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let items = self.places.map {
                        self.makeListingCellViewModel(
                            usingPlace: $0
                        )
                    }
                    self.delegate?.mainPageLoaded(
                        with: .success(items)
                    )
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.mainPageLoaded(
                        with: .failure(error)
                    )
                }
            }
        }
    }
    
    // MARK: Private methods
    private func updateListing(
        then handler: @escaping (VoidResult) -> Void
    ) {
        let keyword = self.placeKeyword
        
        self.listingService.getPlaces(
            usingKeyword: keyword
        ) { (result) in
            switch result {
            case .success(let places):
                self.places = places
                handler(.success)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

// MARK: - TableViewCell factory
extension ListingModelController {
    private func makeListingCellViewModel(
        usingPlace place: Place
    ) -> ListingPlaceCell.ViewModel {
        let name = place.name
        
        let airportName: String
        if let airport = place.airportName {
            airportName = String(
                format: "%@ (%@)",
                airport,
                place.iata
            )
        } else {
            airportName = String(
                format: "(%@)",
                place.iata
            )
        }
        let searchesCount = place.searchesCount
        let tapAction = {
            DispatchQueue.main.async {
                self.delegate?.openMap(
                    usingPlace: place
                )
            }
        }
        
        let listingPlaceCellViewModel: ListingPlaceCell.ViewModel = .init(
            name: name,
            airportName: airportName,
            searchesCount: searchesCount,
            tapAction: tapAction
        )
        
        return listingPlaceCellViewModel
    }
}
