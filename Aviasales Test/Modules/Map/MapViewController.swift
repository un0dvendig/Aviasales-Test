//
//  MapViewController.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import UIKit
import SVProgressHUD
import TinyConstraints

// MARK: - View controller
final class MapViewController: UIViewController {
    // MARK: Properties
    var router: MapRouter!
    
    // MARK: Private properties
    private let modelController: MapModelController
    
    // MARK: Subview
    
    // MARK: Initialization
    init(
        modelController: MapModelController
    ) {
        self.modelController = modelController
        
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.view.backgroundColor = .white
        self.setupSubviews()
        
        self.modelController.delegate = self
        
        print("opened MapViewController..")
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
    private func setupSubviews() {
        // TODO: Delete me
        let closeButton = UIButton()
        closeButton.height(40)
        closeButton.aspectRatio(1.0)
        closeButton.backgroundColor = .red
        closeButton.addTarget(
            self,
            action: #selector(self.didTapCloseButton(_:)),
            for: .touchUpInside
        )
        self.view.addSubview(
            closeButton
        )
        closeButton.topToSuperview(
            offset: 15
        )
        closeButton.leadingToSuperview(
            offset: 15
        )
    }
    
    // MARK: Actions
    @objc
    private func didTapCloseButton(
        _ button: UIButton
    ) {
        self.router.navigate(
            to: .listing
        )
    }
}

// MARK: - ListingModelControllerDelegate
extension MapViewController: MapModelControllerDelegate {
    func pageLoading() {
//        SVProgressHUD.show()
    }
    
    func mainPageLoaded(
        with result: PageLoadingResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let annotations):
            // TODO: ...
            break
        case .failure(let error):
            print("Got and error! \(error)")
        }
    }
}
