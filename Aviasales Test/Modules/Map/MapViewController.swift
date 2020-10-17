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
    private enum Layout {
        static let backButtonHeight: CGFloat = 40
        static let backButtonInsets: UIEdgeInsets = .init(
            top: 15,
            left: 15,
            bottom: 0,
            right: 0
        )
    }
    
    private let modelController: MapModelController
    
    // Flight properties
    private var flightPolyline: MKPolyline?
    private var planeAnnotation: MKPointAnnotation?
    private var planeAnnotationView: MKAnnotationView?
    private var planeDirection: CLLocationDirection = .init()
    private var planeAnnotationPosition: Int = 0
    
    // MARK: Subview
    private let mapView: MKMapView
    private let backButton: UIButton
    
    // MARK: Initialization
    init(
        modelController: MapModelController
    ) {
        self.modelController = modelController
        
        self.mapView = Self.makeMapView()
        self.backButton = Self.makeBackButton()
        
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.view.backgroundColor = .white
        self.setupSubviews()
        
        self.modelController.delegate = self
        self.setupMapView()
        self.setupBackButton()
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
        
        // Forcing UIViewController to use .light style.
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
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
        
        self.view.addSubview(
            self.backButton
        )
        self.backButton.edgesToSuperview(
            excluding: [
                .bottom,
                .right
            ],
            insets: Layout.backButtonInsets,
            usingSafeArea: true
        )
    }
    
    private func setupMapView() {
        self.mapView.register(
            IATAAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: IATAAnnotationView.reuseIdentifier
        )
        
        self.mapView.delegate = self
    }
    
    private func setupBackButton() {
        self.backButton.addTarget(
            self,
            action: #selector(self.backButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    @objc
    private func updatePlanePositionAndDirection() {
        guard let flightPolyline = self.flightPolyline,
              self.planeAnnotation != nil else {
            return
        }
        
        let positionStep: Int = 5
        
        guard self.planeAnnotationPosition + positionStep < flightPolyline.pointCount else {
            return
        }
        
        let flightPoints = flightPolyline.points()
        
        let previousMapPoint = flightPoints[self.planeAnnotationPosition]
        self.planeAnnotationPosition += positionStep
        let nextMapPoint = flightPoints[self.planeAnnotationPosition]
        
        let bearing = MapCommon.getBearingBetweenTwoPoints(
            point1: previousMapPoint,
            point2: nextMapPoint
        )
        
        UIView.animate(
            withDuration: 0.025
        ) {
            self.planeAnnotation?.coordinate = nextMapPoint.coordinate
            self.planeAnnotationView?.transform = self.mapView.transform.rotated(
                by: CGFloat(bearing))
        }
        
        perform(
            #selector(self.updatePlanePositionAndDirection),
            with: nil,
            afterDelay: 0.03
        )
    }
    
    // MARK: Actions
    @objc
    private func backButtonTapped(
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
            // Adding annotaions
            if !self.mapView.annotations.isEmpty {
                self.mapView.removeAnnotations(
                    self.mapView.annotations
                )
            }
            self.mapView.addAnnotations(
                annotations
            )
            
            // Setting proper camera position
            self.mapView.showAnnotations(
                annotations,
                animated: true
            )
            
            // Adding polyline
            let coordinates = annotations.map { $0.coordinate }
            let flightPolyline = MapCommon.createPolyline(
                usingCoordinates: coordinates
            )
            self.flightPolyline = flightPolyline
            self.mapView.addOverlay(
                flightPolyline
            )
            
            // Adding plane
            let planeAnnotation = MKPointAnnotation()
            self.planeAnnotation = planeAnnotation
            self.mapView.addAnnotation(
                planeAnnotation
            )
            
            // Start updating plane's position
            self.updatePlanePositionAndDirection()
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
        
        if let iataAnnotation = annotation as? IATAAnnotation {
            let iataAnnotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: IATAAnnotationView.reuseIdentifier,
                for: iataAnnotation
            )
            annotationView = iataAnnotationView
        } else if let mkPointAnnotation = annotation as? MKPointAnnotation {
            let planeAnnotationIdentifier = "PlaneAnnotation"
            let planeMKAnnotationView: MKAnnotationView

            if let planeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeAnnotationIdentifier) {
                planeMKAnnotationView = planeAnnotationView
            } else {
                planeMKAnnotationView = MKAnnotationView(
                    annotation: mkPointAnnotation,
                    reuseIdentifier: planeAnnotationIdentifier
                )
            }
            let planeImage = UIImage(
                named: "map_plane"
            )?.rotated(
                by: -.pi/2
            )
            planeMKAnnotationView.image = planeImage
            
            self.planeAnnotationView = planeMKAnnotationView
            
            annotationView = planeMKAnnotationView
        }
        
        return annotationView
    }
    
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(
            polyline: polyline
        )
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        renderer.strokeColor = AppColor.annotationBorder.value
        renderer.lineDashPattern = [0, 10]
        
        return renderer
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
    
    private static func makeBackButton() -> UIButton {
        let button = UIButton(
            type: .system
        )
        
        let backButtonImage = UIImage(
            named: "arrow_left"
        )
        button.setImage(
            backButtonImage,
            for: .normal
        )
        
        button.backgroundColor = AppColor.background.value
        button.clipsToBounds = true
        button.layer.cornerRadius = Layout.backButtonHeight / 2
        button.aspectRatio(1.0)
        button.height(
            Layout.backButtonHeight
        )
        
        return button
    }
}
