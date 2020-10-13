//
//  TableViewEvents.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - TableViewEvents
final class TableViewEvents {
    // MARK: Displaying
    var willDisplay: ((UITableViewCell, IndexPath) -> Void)?
    var didEndDisplaying: ((UITableViewCell, IndexPath) -> Void)?

    // MARK: Selecting
    var didSelect: ((IndexPath) -> Void)?
    var didDeselect: ((IndexPath) -> Void)?

    // MARK: Highlighting
    var shouldHighlight: ((IndexPath) -> Bool)?
    var didHighlight: ((IndexPath) -> Void)?
    var didUnhighlight: ((IndexPath) -> Void)?
}
