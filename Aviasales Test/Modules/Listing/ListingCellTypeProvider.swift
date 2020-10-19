//
//  ListingCellTypeProvider.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

// MARK: - TableViewCellTypeProvider
final class ListingCellTypeProvider: TableViewCellTypeProvider {
    // MARK: Properites
    let allCellTypes: [TableViewCell.Type] = [
        ListingPlaceCell.self,
        NoResultCell.self,
        // Add new cells here

        FallbackCell.self
    ]

    // MARK: Methods
    func cellType(
        forViewModel viewModel: TableViewCellViewModel
    ) -> TableViewCell.Type {
        let cellType: TableViewCell.Type
        // Add new viewModels here

        switch viewModel {
        case is ListingPlaceCell.ViewModel:
            cellType = ListingPlaceCell.self
        case is NoResultCell.ViewModel:
            cellType = NoResultCell.self
        default:
            assertionFailure(
                "Unknown viewModel type."
            )
            return FallbackCell.self
        }

        guard self.allCellTypes.contains(where: { String(describing: cellType) == String(describing: $0) }) else {
            assertionFailure(
                "You should add cell type to `allCellTypes`."
            )
            return FallbackCell.self
        }

        return cellType
    }
}

