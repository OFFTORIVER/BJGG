//
//  Extension+\.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/22.
//

import UIKit

extension UIColor {
    // Brading Colors
    static let bbagaBlue = UIColor(rgb: 0x00ACBD)
    static let bbagaGreen = UIColor(rgb: 0x18ECC6)
    
    // Grayscale
    static let bbagaGray1 = UIColor(rgb: 0x000000)
    static let bbagaGray2 = UIColor(rgb: 0xA0A0A0)
    static let bbagaGray3 = UIColor(rgb: 0xDFDFDF)
    static let bbagaGray4 = UIColor(rgb: 0xFFFFFF)
    static let bbagaBack = UIColor(rgb: 0xEAF2F3)
    
    // Icon Color
    static let bbagaSunny = UIColor(rgb: 0xFFA24B)
    static let bbagaRain = UIColor(rgb: 0x609AF0)
    
    // alpha 1 고정, rgb값 입력 간소화 init
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    // Hex값 rgb 변환 init
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


