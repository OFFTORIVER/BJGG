//
//  ScreenSizeStatus.swift
//  BJGG
//
//  Created by 황정현 on 2023/04/05.
//

import UIKit

enum ScreenSizeStatus {
    case origin
    case normal
    case full
    
    func changeButtonImage() -> UIImage {
        switch self {
        case .origin, .normal:
            let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return image!
        case .full:
            let image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return image!
        }
    }
}

