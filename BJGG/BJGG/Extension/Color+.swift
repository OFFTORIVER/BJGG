//
//  Extension+\.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/22.
//

import UIKit

extension UIColor {
    // Colors
//    static let bbagaBlue = UIColor(rgb:)
//    static let bbagaGreen = UIColor(rgb:)
    
    // Grayscale
//    static let bbagaGray1 = UIColor(rgb:)
//    static let bbagaGray2 = UIColor(rgb:)
//    static let bbagaGray3 = UIColor(rgb:)
//    static let bbagaGray4 = UIColor(rgb:)
//    static let bbagaBack = UIColor(rgb:)
    
    // Icon Color
//    static let bbagaSunny = UIColor(rgb:)
//    static let bbagaRain = UIColor(rgb:)
    
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


