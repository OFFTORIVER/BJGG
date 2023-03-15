//
//  SpotLiveCameraGradientView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/05.
//

import UIKit

final class SpotLiveCameraGradientView: UIView {
    
    let color1 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
    let color2 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
    }
}
