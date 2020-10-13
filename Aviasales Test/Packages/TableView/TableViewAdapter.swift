//
//  TableViewAdapter.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - TableViewAdapter
protocol TableViewAdapter: UITableViewDataSource, UITableViewDelegate {
    var viewModels: [TableViewCellViewModel] { get set }
    var scrollEvents: ScrollViewEvents { get }
    var tableViewEvents: TableViewEvents { get }
}

// MARK: - TableViewAdapterImpl
final class TableViewAdapterImpl: NSObject, TableViewAdapter {
    // MARK: Properties
    var viewModels: [TableViewCellViewModel] = []
    
    private(set) var scrollEvents: ScrollViewEvents = ScrollViewEvents()
    private(set) var tableViewEvents: TableViewEvents = TableViewEvents()
    
    // MARK: Private properties
    private let cellHeightProvider: TableViewCellHeightProvider
    private let cellTypeProvider: TableViewCellTypeProvider
    
    // MARK: Initialization
    init(
        cellHeightProvider: TableViewCellHeightProvider,
        cellTypeProvider: TableViewCellTypeProvider
    ) {
        self.cellHeightProvider = cellHeightProvider
        self.cellTypeProvider = cellTypeProvider
    }
}

// MARK: - UITableViewDataSource
extension TableViewAdapterImpl: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.viewModels.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let viewModel = self.viewModels[indexPath.row]
        let cellType = self.cellTypeProvider.cellType(
            forViewModel: viewModel
        )
        let cell = tableView.dequeueReusableCell(
            cellType,
            for: indexPath
        )
        
        if let configurableCell = cell as? TableViewConfigurableCell {
            configurableCell.configure(
                with: viewModel
            )
        }
        
        cell.setNeedsLayout()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TableViewAdapterImpl: UITableViewDelegate {
    // MARK: Height
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let viewModel = self.viewModels[indexPath.row]
        return self.cellHeightProvider.heightForItem(
            tableView: tableView,
            viewModel: viewModel
        ) ?? 0
    }
    
    // MARK: Displaying
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        self.tableViewEvents.willDisplay?(cell, indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        self.tableViewEvents.didEndDisplaying?(cell, indexPath)
    }
    
    // MARK: Selecting
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.tableViewEvents.didSelect?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableViewEvents.didDeselect?(indexPath)
    }
    
    // MARK: Highlighting
    func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return self.tableViewEvents.shouldHighlight?(indexPath) ?? true
    }
    
    func tableView(
        _ tableView: UITableView,
        didHighlightRowAt indexPath: IndexPath
    ) {
        self.tableViewEvents.didHighlight?(indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        didUnhighlightRowAt indexPath: IndexPath
    ) {
        self.tableViewEvents.didUnhighlight?(indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension TableViewAdapterImpl: UIScrollViewDelegate {
    func scrollViewDidScroll(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.didScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.willBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let willEndDraggingContext = ScrollViewEvents.WillEndDraggingContext(
            scrollView: scrollView,
            velocity: velocity,
            targetContentOffset: targetContentOffset
        )
        
        self.scrollEvents.willEndDragging?(willEndDraggingContext)
    }

    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        let didEndDraggingContext = ScrollViewEvents.DidEndDraggingContext(
            scrollView: scrollView,
            willDecelerate: decelerate
        )
        self.scrollEvents.didEndDragging?(didEndDraggingContext)
    }

    func scrollViewWillBeginDecelerating(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.willBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.didEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.didEndScrollingAnimation?(scrollView)
    }

    func scrollViewDidScrollToTop(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.didScrollToTop?(scrollView)
    }

    func scrollViewDidChangeAdjustedContentInset(
        _ scrollView: UIScrollView
    ) {
        self.scrollEvents.didChangeAdjustedContentInset?(scrollView)
    }
}
