//
//  TableViewUpdater.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit
import DifferenceKit

// MARK: TableViewUpdater
protocol TableViewUpdater {
    typealias UpdateCompletion = (Bool) -> Void

    func performUpdate(
        tableView: UITableView,
        adapter: TableViewAdapter,
        viewModels: [TableViewCellViewModel],
        then completion: UpdateCompletion?
    )
}

// MARK: TableViewUpdaterImpl
final class TableViewUpdaterImpl: TableViewUpdater {
    // MARK: Methods
    func performUpdate(
        tableView: UITableView,
        adapter: TableViewAdapter,
        viewModels: [TableViewCellViewModel],
        then completion: TableViewUpdater.UpdateCompletion? = nil
    ) {
        let oldViewModels = adapter.viewModels.map { AnyTableViewCellViewModell(viewModel: $0) }
        let newViewModels = viewModels.map { AnyTableViewCellViewModell(viewModel: $0) }
        
        let difference = StagedChangeset(
            source: oldViewModels,
            target: newViewModels
        )
        guard difference.isEmpty == false else {
            completion?(false)
            return
        }
        
        tableView.reload(
            using: difference,
            with: .automatic
        ) { (data) in
            adapter.viewModels = data.map { $0.viewModel }
            completion?(true)
        }
    }
}

