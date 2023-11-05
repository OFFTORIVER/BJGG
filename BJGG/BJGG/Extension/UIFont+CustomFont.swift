//
//  UIFont+CustomFont.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/27.
//

import UIKit

extension UIFont {
    enum Esamanru: String {
        case medium = "esamanruOTFMedium"
        case light = "esamanruOTFLight"
        case bold = "esamanruOTFBold"
    }
    
    enum Pretendard: String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
    }
    
    enum BbajiFontStyle {
        case heading1
        case heading2
        case heading3
        case heading4
        case heading5
        case heading6
        case heading7
        case heading8
        case body1
        case button1
        case rainyCaption
    }
    
    static func bbajiFont(_ style: BbajiFontStyle) -> UIFont {
        switch style {
        case .heading1:
            return UIFont(name: Pretendard.black.rawValue, size: 48.0) ?? UIFont()
        case .heading2:
            return UIFont(name: Esamanru.bold.rawValue, size: 25.0) ?? UIFont()
        case .heading3:
            return UIFont(name: Pretendard.black.rawValue, size: 24.0) ?? UIFont()
        case .heading4:
            return UIFont(name: Esamanru.bold.rawValue, size: 22.0) ?? UIFont()
        case .heading5:
            return UIFont(name: Pretendard.medium.rawValue, size: 20.0) ?? UIFont()
        case .heading6:
            return UIFont(name: Esamanru.bold.rawValue, size: 22.0) ?? UIFont()
        case .heading7:
            return UIFont(name: Pretendard.bold.rawValue, size: 20.0) ?? UIFont()
        case .heading8:
            return UIFont(name: Pretendard.bold.rawValue, size: 16.0) ?? UIFont()
        case .body1:
            return UIFont(name: Pretendard.medium.rawValue, size: 15.0) ?? UIFont()
        case .button1:
            return UIFont(name: Pretendard.medium.rawValue, size: 15.0) ?? UIFont()
        case .rainyCaption:
            return UIFont(name: Pretendard.medium.rawValue, size: 16.0) ?? UIFont()
        }
    }
    
}
