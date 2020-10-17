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
    
    // Flight properties
    private var flightPolyline: MKPolyline?
    private var planeAnnotation: MKPointAnnotation?
    private var planeAnnotationView: MKAnnotationView?
    private var planeDirection: CLLocationDirection = .init()
    private var planeAnnotationPosition: Int = 0
    
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
            // Adding annotaions
            if !self.mapView.annotations.isEmpty {
                self.mapView.removeAnnotations(
                    self.mapView.annotations
                )
            }
            self.mapView.addAnnotations(
                annotations
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
        renderer.alpha = 0.5
        renderer.strokeColor = .blue
        
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
}
