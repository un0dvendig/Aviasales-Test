//
//  IATAAnnotationView.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import MapKit.MKAnnotationView

// MARK: - AITAAnnotationView
final class IATAAnnotationView: MKAnnotationView {
    // MARK: Properties
    static let reuseIdentifier: String = String(describing: self)
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let iataAnnotation = newValue as? IATAAnnotation else {
                return
            }
            self.titleLabel.text = iataAnnotation.iata
        }
    }
    
    // MARK: Private properties
    private enum Layout {
        static let annotationViewHeight: CGFloat = 60
        static let annotationViewWidth: CGFloat = 100
        
        static let titleLabelInsets: UIEdgeInsets = .init(
            top: 5,
            left: 10,
            bottom: 5,
            right: 10
        )
    }
    
    // MARK: Subviews
    private let titleLabel: UILabel
    
    // MARK: MKAnnotationView methods
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
    
    // MARK: Initialization
    override init(
        annotation: MKAnnotation?,
        reuseIdentifier: String?
    ) {
        self.titleLabel = Self.makeTitleLabel()
        
        super.init(
            annotation: annotation,
            reuseIdentifier: reuseIdentifier
        )
        
        self.setupSelf()
        self.setupSubview()
    }
    
    @available(*, unavailable)
    required init?(
        coder aDecoder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    // MARK: - Private methods
    private func setupSelf() {
        self.canShowCallout = false
        
        self.height(
            Layout.annotationViewHeight
        )
        self.width(
            Layout.annotationViewWidth
        )
        
        self.alpha = 0.8
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = Layout.annotationViewHeight / 2
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 2
    }
    
    private func setupSubview() {
        self.addSubview(
            self.titleLabel
        )
        self.titleLabel.edgesToSuperview(
            insets: Layout.titleLabelInsets
        )
    }
}

// MARK: - Factory
private extension IATAAnnotationView {
    private static func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.textColor = .blue
        return label
    }
}
