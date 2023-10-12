//
//  Constraints.swift
//  BJGG
//
//  Created by 이재웅 on 2023/02/22.
//

import UIKit

final class BbajiConstraints {
    // label 간 간격 constraint
    static let space4: CGFloat = 4.0
    
    static let space6: CGFloat = 6.0
    
    // icon 간 간격 constraint
    static let space8: CGFloat = 8.0
    
    // view 내의 component 간 간격 constraint
    static let space12: CGFloat = 12.0
    
    // superView와 내부 view 간 간격 constraint
    static let space16: CGFloat = 16.0
    
    // view와 내부 component 간 간격 constraint
    static let viewInset: CGFloat = UIDevice.current.hasNotch ? 20.0 : 16.0
    
    static let space20: CGFloat = 20.0
    
    private init() { }
}
