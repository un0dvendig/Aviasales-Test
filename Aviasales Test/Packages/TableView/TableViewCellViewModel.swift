//
//  TableViewCellViewModel.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Foundation
import DifferenceKit

// MARK: - CellEventHandler
protocol CellEventHandler {
    var didSelect: ((TableViewCellViewModel) -> Void)? { get }
}

extension CellEventHandler {
    var didSelect: ((TableViewCellViewModel) -> Void)? { nil }
}

// MARK: - DefaultCellEventHandler
final class DefaultCellEventHandler: CellEventHandler {
    var didSelect: ((TableViewCellViewModel) -> Void)?
}

// MARK: - TableViewCellViewModel
protocol TableViewCellViewModel {
    var hash: AnyHashable { get }
    var cellEventHandler: CellEventHandler { get }
    
    func isEqual(
        to: TableViewCellViewModel
    ) -> Bool
}

extension TableViewCellViewModel where Self: Equatable {
    func isEqual(
        to: TableViewCellViewModel
    ) -> Bool {
        guard let rhs = to as? Self else { return false }
        return self == rhs
    }
}

extension TableViewCellViewModel where Self: Hashable {
    var hash: AnyHashable {
        self.hashValue
    }
}

// MARK: - AnyTableViewCellViewModell
struct AnyTableViewCellViewModell: Differentiable {
    // MARK: Properties
    let viewModel: TableViewCellViewModel
    
    // Differentiable
    var differenceIdentifier: AnyHashable {
        return self.viewModel.hash
    }
    
    func isContentEqual(
        to source: AnyTableViewCellViewModell
    ) -> Bool {
        return viewModel.isEqual(
            to: source.viewModel
        )
    }
}
