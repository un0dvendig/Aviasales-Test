//
//  ListingPlaceCell.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import TinyConstraints
import UIKit
import SwiftRichString

// MARK: - UITableViewCell
final class ListingPlaceCell: UITableViewCell {
    // MARK: Private properties
    private enum Layout {
        static let cellCornerRadius: CGFloat = 10
        static let contentContainerBackgroundInsets: UIEdgeInsets = .init(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        
        static let contentContainerInsets: UIEdgeInsets = .init(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        static let contentContainerSpacing: CGFloat = 5
        
        static let placeNameLabelHeight: CGFloat = 20
        static let airportNameLabelHeight: CGFloat = 20
        static let searchesCountLabelHeight: CGFloat = 30
    }
    
    private enum Style {
        static let placeNameLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.bold20
            $0.color = UIColor.purple
        }
        static let airportNameLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium15
            $0.color = UIColor.black
        }
        static let searchesCountLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.regular15
            $0.color = UIColor.black
        }
    }
    
    private var viewModel: ViewModel?
    
    // MARK: Subviews
    private let contentContainerBackgroundView: UIView
    private let contentContainer: UIStackView
    private let placeNameLabel: UILabel
    private let airportNameLabel: UILabel
    private let searchesCountLabel: UILabel
    
    // MARK: Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        self.contentContainerBackgroundView = Self.makeContentContainerBackgroundView()
        self.contentContainer = Self.makeContentContainer()
        self.placeNameLabel = Self.makePlaceNameLabel()
        self.airportNameLabel = Self.makeAirportNameLabel()
        self.searchesCountLabel = Self.makeSearchesCountLabel()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        self.setupSelf()
        self.setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableView methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.placeNameLabel.styledText = nil
        self.airportNameLabel.styledText = nil
        self.searchesCountLabel.styledText = nil
    }
    
    // MARK: Private methods
    private func setupSelf() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
        let tapAction: UITapGestureRecognizer = .init(
            target: self,
            action: #selector(self.cellTappedAction(_:))
        )
        self.addGestureRecognizer(tapAction)
    }
    
    private func setupSubviews() {
        self.contentView.addSubview(
            self.contentContainerBackgroundView
        )
        self.contentContainerBackgroundView.edgesToSuperview(
            insets: Layout.contentContainerBackgroundInsets
        )
        
        self.contentContainerBackgroundView.addSubview(
            self.contentContainer
        )
        self.contentContainer.edgesToSuperview(
            insets: Layout.contentContainerInsets
        )
        
        self.contentContainer.addArrangedSubview(
            self.placeNameLabel
        )
        self.contentContainer.addArrangedSubview(
            self.airportNameLabel
        )
        self.contentContainer.addArrangedSubview(
            self.searchesCountLabel
        )
    }
    
    @objc
    private func cellTappedAction(
        _ tap: UITapGestureRecognizer
    ) {
        self.viewModel?.tapAction()
    }
}

// MARK: - TableViewConfigurableCell
extension ListingPlaceCell: TableViewConfigurableCell {
    func configure(
        with viewModel: TableViewCellViewModel
    ) {
        guard let viewModel = viewModel as? ViewModel else {
            return
        }
        
        self.placeNameLabel.styledText = viewModel.name
        self.airportNameLabel.styledText = viewModel.airportName
        self.searchesCountLabel.styledText = String(viewModel.searchesCount)
        
        self.viewModel = viewModel
    }
}

// MARK: - TableViewCellSelfHeightProvider
extension ListingPlaceCell: TableViewCellSelfHeightProvider {
    static func height(
        boundingSize: CGSize,
        viewModel: TableViewCellViewModel
    ) -> CGFloat {
        guard viewModel is ViewModel else {
            return .zero
        }
        
        let contentContainerHeight = Layout.contentContainerInsets.top
            + Layout.placeNameLabelHeight
            + Layout.contentContainerSpacing
            + Layout.airportNameLabelHeight
            + Layout.contentContainerSpacing
            + Layout.searchesCountLabelHeight
            + Layout.contentContainerInsets.bottom
        
        let height = Layout.contentContainerBackgroundInsets.top
            + contentContainerHeight
            + Layout.contentContainerBackgroundInsets.bottom
        
        return height
    }
}

// MARK: - Factory
extension ListingPlaceCell {
    private static func makeContentContainerBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Layout.cellCornerRadius
        return view
    }
    
    private static func makeContentContainer() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.contentContainerSpacing
        return stackView
    }
    
    private static func makePlaceNameLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.placeNameLabelStyle
        label.height(
            Layout.placeNameLabelHeight
        )
        return label
    }
    
    private static func makeAirportNameLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.airportNameLabelStyle
        label.height(
            Layout.airportNameLabelHeight
        )
        return label
    }
    
    private static func makeSearchesCountLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.searchesCountLabelStyle
        label.height(
            Layout.searchesCountLabelHeight
        )
        return label
    }
}

