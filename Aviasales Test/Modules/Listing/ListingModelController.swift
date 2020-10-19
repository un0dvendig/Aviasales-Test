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
    
    /// Handles start of the searching process.
    func searchStarted()
    
    /// Handles result of the searching query.
    ///
    /// - Parameters:
    ///    - result: The result of searching query.
    func searchFinished(
        with result: PageLoadingResult
    )
    
    /// Handles the event of clearing the search bar.
    /// (i.e. the event of returning the collection view's state to the initial one)
    ///
    /// - Parameters:
    ///    - models: View models from the initial state of the search page,
    ///    those, that the result of the page loading process contained.
    func searchReturned(
        toTheStateWith viewModels: [TableViewCellViewModel]
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
    
    /// Search places matching given text.
    ///
    /// - Parameters:
    ///    - query: The text that should be included in the search query.
    func searchPlaces(
        matching query: String
    ) {
        DispatchQueue.main.async {
            self.delegate?.searchStarted()
        }
        
        guard !query.isEmpty else {
            let items = self.places.map {
                self.makeListingCellViewModel(
                    usingPlace: $0
                )
            }
            DispatchQueue.main.async {
                self.delegate?.searchReturned(
                    toTheStateWith: items
                )
            }
            return
        }
        
        var filteredPlacesViewModels: [TableViewCellViewModel] = []
        filteredPlacesViewModels = self.places.filter {
            $0.name.lowercased().contains(
                query.lowercased()
            )
        }.map {
            self.makeListingCellViewModel(
                usingPlace: $0
            )
        }
        if filteredPlacesViewModels.isEmpty {
            let noResultViewModel = self.makeNoMatchViewModel(
                forSearchQuery: query
            )
            filteredPlacesViewModels.append(
                noResultViewModel
            )
        }
        DispatchQueue.main.async {
            self.delegate?.searchFinished(
                with: .success(filteredPlacesViewModels)
            )
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
    ) -> TableViewCellViewModel {
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
    
    private func makeNoMatchViewModel(
        forSearchQuery query: String
    ) -> TableViewCellViewModel {
        let title = NSLocalizedString(
            "Listing.NoResultCell.Title.Text",
            comment: ""
        )
        let subtitleTextFormat = NSLocalizedString(
            "Listing.NoResultCell.Subtitle.Text",
            comment: ""
        )
        let subtitle = String(
            format: subtitleTextFormat,
            query
        )
        
        let viewModel = NoResultCell.ViewModel(
            title: title,
            subtitle: subtitle
        )
        return viewModel
    }
}
