//
//  ListingCellHeightProvider.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - ListingCellHeightProvider
final class ListingCellHeightProvider {
    // MARK: Private properties
    private let cache = Cache<AnyHashable, CGFloat>()
    private let cellTypeProvider: TableViewCellTypeProvider
    
    // MARK: Initialization
    init(
        cellTypeProvider: TableViewCellTypeProvider
    ) {
        self.cellTypeProvider = cellTypeProvider
    }
}

// MARK: - TableViewCellHeightProvider
extension ListingCellHeightProvider: TableViewCellHeightProvider {
    func heightForItem(
        tableView: UITableView,
        viewModel: TableViewCellViewModel
    ) -> CGFloat? {
        if let cachedHeight = cache[viewModel.hash] {
            return cachedHeight
        }
        
        let width = tableView.bounds.size.width
            - tableView.contentInset.left
            - tableView.contentInset.right
        let height = tableView.bounds.size.height
            - tableView.contentInset.top
            - tableView.contentInset.bottom
        let boundingSize = CGSize(
            width: width,
            height: height
        )
        let cellType = self.cellTypeProvider.cellType(
            forViewModel: viewModel
        )
        let heightProvider = cellType as TableViewCellSelfHeightProvider.Type
        
        let itemHeight = heightProvider.height(
            boundingSize: boundingSize,
            viewModel: viewModel
        )
        self.cache[viewModel.hash] = itemHeight
        
        return itemHeight
    }

    func invalidateCache() {
        self.cache.removeAll()
    }
}
