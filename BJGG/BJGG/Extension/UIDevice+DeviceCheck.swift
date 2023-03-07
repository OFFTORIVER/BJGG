//
//  UIDevice+DeviceCheck.swift
//  BJGG
//
//  Created by 황정현 on 2022/10/02.
//

import UIKit

// https://developer.apple.com/forums/thread/709997
extension UIDevice {
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return false }
        
        return window.safeAreaInsets.top > 20
    }
}
