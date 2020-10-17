//
//  MapViewController.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import UIKit
import MapKit
import SVProgressHUD
import TinyConstraints

// MARK: - View controller
final class MapViewController: UIViewController {
    // MARK: Properties
    var router: MapRouter!
    
    // MARK: Private properties
    private let modelController: MapModelController
    
    // MARK: Subview
    private let mapView: MKMapView
    
    // MARK: Initialization
    init(
        modelController: MapModelController
    ) {
        self.modelController = modelController
        
        self.mapView = Self.makeMapView()
        
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.view.backgroundColor = .white
        self.setupSubviews()
        
        self.modelController.delegate = self
        self.setupMapView()
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
        self.view.addSubview(
            self.mapView
        )
        self.mapView.edgesToSuperview(
            usingSafeArea: false
        )
        
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
            offset: 15,
            usingSafeArea: true
        )
        closeButton.leadingToSuperview(
            offset: 15
        )
    }
    
    private func setupMapView() {
        self.mapView.register(
            IATAAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: IATAAnnotationView.reuseIdentifier
        )
        
        self.mapView.delegate = self
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

// MARK: - Delegates
// ListingModelControllerDelegate
extension MapViewController: MapModelControllerDelegate {
    func pageLoading() {
        SVProgressHUD.show()
    }
    
    func mainPageLoaded(
        with result: PageLoadingResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let annotations):
            if !self.mapView.annotations.isEmpty {
                self.mapView.removeAnnotations(
                    self.mapView.annotations
                )
            }
            self.mapView.addAnnotations(
                annotations
            )
        case .failure(let error):
            print("Got and error! \(error)")
        }
    }
}

// MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        // Bail out, if this is user location annotation.
        // Currently, this is an unnecessary check.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let aitaAnnotation = annotation as? IATAAnnotation {
            let aitaAnnotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: IATAAnnotationView.reuseIdentifier,
                for: aitaAnnotation
            )
            annotationView = aitaAnnotationView
        }
        
        return annotationView
    }
}

// MARK: - Factory
extension MapViewController {
    private static func makeMapView() -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsUserLocation = false
        mapView.showsTraffic = false
        return mapView
    }
}
