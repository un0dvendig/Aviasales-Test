//
//  AppFont.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

enum AppFont {
    // MARK: - Bold
    static let bold20: UIFont = bold(size: 20)

    // MARK: - Medium
    static let medium17: UIFont = medium(size: 17)
    static let medium15: UIFont = medium(size: 15)

    // MARK: - Regular
    static let regular15: UIFont = regular(size: 15)

    // MARK: - Private
    private static func bold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SFProDisplay-Bold", size: size) else {
            assertionFailure()
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }

    private static func medium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SFProDisplay-Medium", size: size) else {
            assertionFailure()
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }

    private static func regular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SFProDisplay-Regular", size: size) else {
            assertionFailure()
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}

