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
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return false }
            
            return window.safeAreaInsets.top > 20
        }
        
        if #available(iOS 11.0, *) {
            let top = UIApplication.shared.windows[0].safeAreaInsets.top
            return top > 20
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}
