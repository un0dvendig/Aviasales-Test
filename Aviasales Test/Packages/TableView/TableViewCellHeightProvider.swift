//
//  TableViewCellHeightProvider.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - TableViewCellHeightProvider
protocol TableViewCellHeightProvider {
    func heightForItem(
        tableView: UITableView,
        viewModel: TableViewCellViewModel
    ) -> CGFloat?
    
    /// - WARNING:
    /// You should invalidate cache when tableView.bounds changes.
    func invalidateCache()
}

