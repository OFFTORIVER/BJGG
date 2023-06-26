//
//  UIView+.swift
//  BJGG
//
//  Created by 황정현 on 2023/04/04.
//

import UIKit

// Gesture Recognizer with Combine
extension UIView {
    func gesture(_ gestureType: GestureType = .tap()) ->
    GesturePublisher {
        .init(view: self, gestureType: gestureType)
    }
}
