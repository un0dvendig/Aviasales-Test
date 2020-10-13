//
//  ScrollViewEvents.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import UIKit

// MARK: - ScrollViewEvents
final class ScrollViewEvents {
    struct WillEndDraggingContext {
        let scrollView: UIScrollView
        let velocity: CGPoint
        let targetContentOffset: UnsafeMutablePointer<CGPoint>
    }

    struct DidEndDraggingContext {
        let scrollView: UIScrollView
        let willDecelerate: Bool
    }

    var didScroll: ((UIScrollView) -> Void)?
    var willBeginDragging: ((UIScrollView) -> Void)?
    var willEndDragging: ((WillEndDraggingContext) -> Void)?
    var didEndDragging: ((DidEndDraggingContext) -> Void)?
    var willBeginDecelerating: ((UIScrollView) -> Void)?
    var didEndDecelerating: ((UIScrollView) -> Void)?
    var didEndScrollingAnimation: ((UIScrollView) -> Void)?
    var didScrollToTop: ((UIScrollView) -> Void)?
    var didChangeAdjustedContentInset: ((UIScrollView) -> Void)?
}
