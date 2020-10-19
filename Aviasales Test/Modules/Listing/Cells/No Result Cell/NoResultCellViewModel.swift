//
//  NoResultCellViewModel.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 19.10.2020.
//

// MARK: - View model
extension NoResultCell {
    struct ViewModel: TableViewCellViewModel, Hashable, Equatable {
        // MARK: Properties
        // TableViewCellViewModel properties
        let cellEventHandler: CellEventHandler = DefaultCellEventHandler()
        
        // View model properties
        let title: String
        let subtitle: String
        
        // MARK: Hashable
        func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(self.title)
            hasher.combine(self.subtitle)
        }
        
        // MARK: Equatable
        static func == (
            lhs: NoResultCell.ViewModel,
            rhs: NoResultCell.ViewModel
        ) -> Bool {
            return lhs.title == rhs.title
                && lhs.subtitle == rhs.subtitle
        }
    }
}


