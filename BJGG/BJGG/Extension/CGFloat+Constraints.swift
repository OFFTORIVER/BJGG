//
//  CGFloat+Constraints.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/23.
//

import UIKit

extension CGFloat {
    // label 간 간격 constraint
    static let labelOffset: CGFloat = 4.0
    
    // icon 간 간격 constraint
    static let iconOffset: CGFloat = 8.0
    
    // view 내의 component 간 간격 constraint
    static let componentOffset: CGFloat = 12.0
    
    // superView와 내부 view 간 간격 constraint
    static let superViewInset: CGFloat = 16.0
    
    // view와 내부 component 간 간격 constraint
    static let viewInset: CGFloat = UIDevice.current.hasNotch ? 20.0 : 16.0
}
