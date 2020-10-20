//
//  ListingViewController.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit
import SHSearchBar
import SVProgressHUD
import TinyConstraints
import Moya

// MARK: - View controller
final class ListingViewController: UIViewController {
    // MARK: Properties
    var router: ListingRouter!
    
    // MARK: Private properties
    private enum Layout {
        static let searchBarHeight: CGFloat = 50
        static let searchBarVerticalPadding: CGFloat = 10
        static let searchBarHorizontalPadding: CGFloat = 15
        
        static let tableViewVerticalOffset: CGFloat = 10
    }
    
    private let modelController: ListingModelController
    private let tableViewDirector: TableViewDirector
    
    // MARK: Subview
    private let tableView: UITableView
    private let searchBar: SHSearchBar
    
    // MARK: Initialization
    init(
        modelController: ListingModelController
    ) {
        self.tableView = Self.makeTableView()
        self.searchBar = Self.makeSearchBar()
        
        self.tableViewDirector = Self.makeTableViewDirector(
            forTableView: self.tableView
        )
        self.modelController = modelController
        
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.view.backgroundColor = AppColor.tableViewBackground.value
        self.setupSubviews()
        
        self.modelController.delegate = self
        self.searchBar.delegate = self
        self.setupTableView()
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    // MARK: View life cycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelController.loadPage()
    }
    
    // MARK: Private methods
    private func setupTableView() {
        self.tableViewDirector.adapter.scrollEvents.willBeginDragging = { (_) in
            self.handleKeyboard()
        }
        
        self.tableView.dataSource = self.tableViewDirector.adapter
        self.tableView.delegate = self.tableViewDirector.adapter
        
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.handleKeyboard)
        )
        panGesture.delegate = self
        self.tableView.addGestureRecognizer(
            panGesture
        )
    }
    
    private func setupSubviews() {
        self.view.addSubview(
            self.searchBar
        )
        self.searchBar.horizontalToSuperview(
            insets: .horizontal(
                Layout.searchBarHorizontalPadding
            )
        )
        self.searchBar.topToSuperview(
            offset: Layout.searchBarVerticalPadding,
            usingSafeArea: true
        )
        self.searchBar.height(
            Layout.searchBarHeight
        )
        
        self.view.addSubview(
            self.tableView
        )
        self.tableView.topToBottom(
            of: self.searchBar,
            offset: Layout.tableViewVerticalOffset
        )
//        let totalOffsetForSearchBar = Layout.searchBarVerticalPadding
//            + Layout.searchBarHeight
//        self.tableView.topToSuperview(
//            offset: totalOffsetForSearchBar,
//            usingSafeArea: true
//        )
        self.tableView.edgesToSuperview(
            excluding: .top,
            usingSafeArea: false
        )
        

    }
    
    @objc
    private func handleKeyboard() {
        guard self.searchBar.isFirstResponder else {
            return
        }
        self.searchBar.resignFirstResponder()
    }
}

// MARK: - Delegates
// ListingModelControllerDelegate
extension ListingViewController: ListingModelControllerDelegate {
    func pageLoading() {
        SVProgressHUD.show()
    }
    
    func mainPageLoaded(
        with result: PageLoadingResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let viewModels):
            self.tableViewDirector.set(
                viewModels: viewModels
            )
        case .failure(let error):
            print("Got and error! \(error)")
        }
    }
    
    func searchStarted() {
        SVProgressHUD.show()
    }
    
    func searchFinished(
        with result: PageLoadingResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let viewModels):
            self.tableViewDirector.set(
                viewModels: viewModels
            )
        case .failure(let error):
            print("Got and error! \(error)")
        }
    }
    
    func searchReturned(
        toTheStateWith viewModels: [TableViewCellViewModel]
    ) {
        SVProgressHUD.dismiss()
        self.tableViewDirector.set(
            viewModels: viewModels
        )
    }
    
    func openMap(
        usingPlace place: Place
    ) {
        let initialPlace: Place? = nil
        let finishPlace: Place = place
        self.router.navigate(
            to: .map(
                initialPlace: initialPlace,
                finishPlace: finishPlace
            )
        )
    }
}

// UISearchBarDelegate
extension ListingViewController: SHSearchBarDelegate {
    func searchBarShouldClear(
        _ searchBar: SHSearchBar
    ) -> Bool {
        DispatchQueue.main.asyncDeduped(
            target: self,
            after: 0.75
        ) {
            self.modelController.searchPlaces(
                matching: ""
            )
        }
        return true
    }
    
    func searchBar(
        _ searchBar: SHSearchBar,
        textDidChange text: String
    ) {
        DispatchQueue.main.asyncDeduped(
            target: self,
            after: 0.75
        ) {
            self.modelController.searchPlaces(
                matching: text
            )
        }
    }
    
    func searchBarShouldReturn(
        _ searchBar: SHSearchBar
    ) -> Bool {
        guard let searchText = searchBar.text else {
            return false
        }
        DispatchQueue.main.asyncDeduped(
            target: self,
            after: 0.75
        ) {
            self.modelController.searchPlaces(
                matching: searchText
            )
        }
        return true
    }
}

// - UIGestureRecognizerDelegate
extension ListingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

// MARK: - Factory
extension ListingViewController {
    private static func makeTableView() -> UITableView {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColor.tableViewBackground.value
        tableView.isMultipleTouchEnabled = false
        return tableView
    }
    
    private static func makeTableViewDirector(
        forTableView tableView: UITableView
    ) -> TableViewDirector {
        let cellTypeProvider: TableViewCellTypeProvider = ListingCellTypeProvider()
        let cellHeightProvider: TableViewCellHeightProvider = ListingCellHeightProvider(
            cellTypeProvider: cellTypeProvider
        )
        let adapter: TableViewAdapter = TableViewAdapterImpl(
            cellHeightProvider: cellHeightProvider,
            cellTypeProvider: cellTypeProvider
        )
        let updater: TableViewUpdater = TableViewUpdaterImpl()
        
        let tableViewDirector = TableViewDirector(
            tableView: tableView,
            cellTypeProvider: cellTypeProvider,
            cellHeightProvider: cellHeightProvider,
            adapter: adapter,
            updater: updater
        )
        return tableViewDirector
    }
    
    private static func makeSearchBar() -> SHSearchBar {
        var config = SHSearchBarConfig()
        config.useCancelButton = true
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.text.value,
            .font: AppFont.medium15
        ]
        config.textAttributes = textAttributes
        
        let searchBar = SHSearchBar(
            config: config
        )
        
        searchBar.textField.autocapitalizationType = .sentences
        searchBar.textField.autocorrectionType = .no
        
        let placeholderText = NSLocalizedString(
            "Listing.SearchBar.Placeholder.Text",
            comment: ""
        )
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.placeholder.value,
            .font: AppFont.medium15
        ]
        let attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: placeholderAttributes
        )
        searchBar.textField.attributedPlaceholder = attributedPlaceholder
        
        searchBar.updateBackgroundImage(
            withRadius: 10,
            corners: [
                .allCorners
            ],
            color: AppColor.searchBarBackground.value
        )
        return searchBar
    }
}
