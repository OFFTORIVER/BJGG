//
//  BbajiHomeBackgroundImageView.swift
//  BJGG
//
//  Created by 이재웅 on 2023/03/15.
//

import UIKit

final class BbajiHomeBackgroundImageView: UIImageView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.image = UIImage(named: UIDevice.current.hasNotch ? "homeBackgroundImage" : "homeBackgroundImageNotNotch")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
