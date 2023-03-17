//
//  BbajiListCellShadowView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit

class BbajiListCellShadowView: UIView {
    let color1 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    let color2 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6708)
    let color3 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    let gradient: CAGradientLayer = CAGradientLayer()
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradientLayer.locations = [0.0, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.frame = CGRect(x: 0.0, y: bounds.height * 0.4, width: bounds.width, height: bounds.height * 0.6)
        gradientLayer.cornerRadius = 4.0
    }
}
