//
//  ListingPlaceCellViewModel.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

// MARK: - View model
extension ListingPlaceCell {
    struct ViewModel: TableViewCellViewModel, Hashable, Equatable {
        // MARK: Properties
        // TableViewCellViewModel properties
        let cellEventHandler: CellEventHandler = DefaultCellEventHandler()
        
        // View model properties
        let name: String
        let airportName: String
        let searchesCount: Int
        
        let tapAction: () -> Void
        
        // MARK: Hashable
        func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(self.name)
            hasher.combine(self.airportName)
            hasher.combine(self.searchesCount)
        }
        
        // MARK: Equatable
        static func == (
            lhs: ListingPlaceCell.ViewModel,
            rhs: ListingPlaceCell.ViewModel
        ) -> Bool {
            return lhs.name == rhs.name
                && lhs.airportName == rhs.airportName
                && lhs.searchesCount == rhs.searchesCount
        }
    }
}

