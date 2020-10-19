//
//  NoResultCell.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 19.10.2020.
//

import TinyConstraints
import UIKit
import SwiftRichString

// MARK: - UITableViewCell
final class NoResultCell: UITableViewCell {
    // MARK: Private properties
    private enum Layout {
        static let cellCornerRadius: CGFloat = 10
        static let contentContainerBackgroundInsets: UIEdgeInsets = .init(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        
        static let cellWidth: CGFloat = UIScreen.main.bounds.width
            - Layout.contentContainerBackgroundInsets.left
            - Layout.contentContainerInsets.left
            - Layout.contentContainerInsets.right
            - Layout.contentContainerBackgroundInsets.right
        
        static let contentContainerInsets: UIEdgeInsets = .init(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        static let contentContainerSpacing: CGFloat = 5
        
        static let titleLabelHeight: CGFloat = 30
    }
    
    private enum Style {
        static let titleStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.bold17
            $0.color = AppColor.text.value
        }
        
        static let subtitleLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.regular15
            $0.color = AppColor.text.value
        }
    }
    
    private var viewModel: ViewModel?
    
    // MARK: Subviews
    private let contentContainerBackgroundView: UIView
    private let contentContainer: UIStackView
    private let titleLabel: UILabel
    private let searchTextLabel: UILabel
    
    // MARK: Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        self.contentContainerBackgroundView = Self.makeContentContainerBackgroundView()
        self.contentContainer = Self.makeContentContainer()
        self.titleLabel = Self.makeTitleLabel()
        self.searchTextLabel = Self.makeSubtitleTextLabel()
        
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
        
        self.titleLabel.styledText = nil
        self.searchTextLabel.styledText = nil
    }
    
    // MARK: Private methods
    private func setupSelf() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
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
            self.titleLabel
        )
        self.contentContainer.addArrangedSubview(
            self.searchTextLabel
        )
    }
}

// MARK: - TableViewConfigurableCell
extension NoResultCell: TableViewConfigurableCell {
    func configure(
        with viewModel: TableViewCellViewModel
    ) {
        guard let viewModel = viewModel as? ViewModel else {
            return
        }
        
        self.titleLabel.styledText = viewModel.title
        self.searchTextLabel.styledText = viewModel.subtitle
        
        self.viewModel = viewModel
    }
}

// MARK: - TableViewCellSelfHeightProvider
extension NoResultCell: TableViewCellSelfHeightProvider {
    static func height(
        boundingSize: CGSize,
        viewModel: TableViewCellViewModel
    ) -> CGFloat {
        guard let viewModel = viewModel as? ViewModel else {
            return .zero
        }
        
        guard let subtitleFont = Style.subtitleLabelStyle.font as? UIFont else {
            return .zero
        }
        let subtitleText = viewModel.subtitle
        let width = Layout.cellWidth
        
        let subtitleTextLabelHeight = Self.calculateHeight(
            for: subtitleText,
            width: width,
            andFont: subtitleFont
        )
        
        let contentContainerHeight = Layout.contentContainerInsets.top
            + Layout.titleLabelHeight
            + Layout.contentContainerSpacing
            + subtitleTextLabelHeight
            + Layout.contentContainerInsets.bottom
        
        let height = Layout.contentContainerBackgroundInsets.top
            + contentContainerHeight
            + Layout.contentContainerBackgroundInsets.bottom
        
        return height
    }
}

// MARK: - Factory
extension NoResultCell {
    private static func makeContentContainerBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = AppColor.background.value
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
    
    private static func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.style = Style.titleStyle
        label.height(
            Layout.titleLabelHeight
        )
        return label
    }
    
    private static func makeSubtitleTextLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .left
        label.style = Style.subtitleLabelStyle
        return label
    }
    
    // MARK: Helping methods
    static func calculateHeight(
        for text: String,
        width: CGFloat,
        andFont font: UIFont
    ) -> CGFloat {
        let textFrame = NSString(
            string: text
        ).boundingRect(
            with: CGSize(
                width: width,
                height: .infinity
            ),
            options: [
                .usesFontLeading,
                .usesLineFragmentOrigin
            ],
            attributes: [
                .font: font
            ],
            context: nil
        )

        return textFrame.size.height.rounded(.up)
    }
}

