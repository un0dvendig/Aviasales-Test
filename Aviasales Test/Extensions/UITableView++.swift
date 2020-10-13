//
//  UITableView__.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

extension UITableView {
    public final func register<C: UITableViewCell>(
        _ cellType: C.Type,
        with identifier: String? = nil
    ) {
        let identifier = identifier ?? String(describing: cellType)
        self.register(
            cellType,
            forCellReuseIdentifier: identifier
        )
    }

    public final func dequeueReusableCell<C: UITableViewCell>(
        _ cellType: C.Type = C.self,
        with identifier: String? = nil,
        for indexPath: IndexPath
    ) -> C {
        let identifier = identifier ?? String(describing: cellType)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? C else {
            assertionFailure(
                "Failed to cast the cell with identifier \(identifier) to \(C.self)."
            )
            return C.init(
                style: .default,
                reuseIdentifier: identifier
            )
        }
        return cell
    }
}
