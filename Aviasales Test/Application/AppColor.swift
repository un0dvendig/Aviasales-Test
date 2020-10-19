//
//  AppColor.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import UIKit.UIColor

// MARK: - AppColor
enum AppColor {
    case background
    case tableViewBackground
    case searchBarBackground
    
    case text
    case placeholder
    case titleText
    
    case annotationBorder
    
    case custom(
        hexString: String,
        alpha: Double
     )
    
    func with(
        alpha: Double
    ) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension AppColor {
    var value: UIColor {
        var instanceColor: UIColor = .clear
        
        switch self {
        case .background:
            instanceColor = .white
        case .tableViewBackground:
            instanceColor = .lightGray
        case .searchBarBackground:
            instanceColor = .white
            
        case .text:
            instanceColor = .black
        case .placeholder:
            instanceColor = .blue
        case .titleText:
            instanceColor = .purple
            
        case .annotationBorder:
            instanceColor = .init(
                hexString: "5CB3D3"
            )
            
        case .custom(let hexString, let alpha):
            instanceColor = UIColor(
                hexString: hexString
            ).withAlphaComponent(CGFloat(alpha))
        }
        
        return instanceColor
    }
}

