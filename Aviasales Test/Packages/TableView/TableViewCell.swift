//
//  TableViewCell.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import class UIKit.UITableViewCell
import struct CoreGraphics.CGSize
import UIKit

// MARK: - TableViewConfigurableCell
protocol TableViewConfigurableCell: UITableViewCell {
    func configure(
        with viewModel: TableViewCellViewModel
    )
}

// MARK: - TableViewCellSelfHeightProvider
protocol TableViewCellSelfHeightProvider {
    static func height(
        boundingSize: CGSize,
        viewModel: TableViewCellViewModel
    ) -> CGFloat
}

// MARK: - TableViewCell
typealias TableViewCell = TableViewConfigurableCell & TableViewCellSelfHeightProvider
