//
//  UIImage+Rotated.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 17.10.2020.
//

import UIKit

extension UIImage {
    /// Get an UIImage, rotated by given radians value.
    /// 
    /// - Note:
    /// If something fails, returns original UIImage.
    func rotated(
        by radians: CGFloat
    ) -> UIImage {
        let rotatedSize = CGRect(
            origin: .zero,
            size: size
        )
        .applying(
            CGAffineTransform(
                rotationAngle: CGFloat(radians)
            )
        )
        .integral
        .size
        
        UIGraphicsBeginImageContext(rotatedSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(
                x: rotatedSize.width / 2.0,
                y: rotatedSize.height / 2.0
            )
            context.translateBy(
                x: origin.x,
                y: origin.y
            )
            context.rotate(
                by: radians
            )
            draw(
                in: CGRect(
                    x: -origin.y,
                    y: -origin.x,
                    width: size.width,
                    height: size.height
                )
            )
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
