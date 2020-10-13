//
//  TableViewDirector.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - TableViewDirector
final class TableViewDirector: NSObject {
    // MARK: Properties
    let adapter: TableViewAdapter
    let cellHeightProvider: TableViewCellHeightProvider
    
    // MARK: Private properties
    private let updater: TableViewUpdater
    private let tableView: UITableView
    private let cellTypeProvider: TableViewCellTypeProvider
    
    // MARK: Initialization
    init(
        tableView: UITableView,
        cellTypeProvider: TableViewCellTypeProvider,
        cellHeightProvider: TableViewCellHeightProvider,
        adapter: TableViewAdapter,
        updater: TableViewUpdater
    ) {
        self.tableView = tableView
        self.cellTypeProvider = cellTypeProvider
        self.cellHeightProvider = cellHeightProvider
        self.updater = updater
        self.adapter = adapter

        super.init()

        cellTypeProvider.allCellTypes.forEach {
            self.tableView.register($0)
        }
    }

    // MARK: Methods
    func set(
        viewModels newViewModels: [TableViewCellViewModel],
        completion: ((Bool) -> Void)? = nil)
    {
        assert(
            Thread.isMainThread,
            "You should update collection view only on main thread."
        )

        self.updater.performUpdate(
            tableView: self.tableView,
            adapter: self.adapter,
            viewModels: newViewModels,
            then: completion
        )
    }

}

