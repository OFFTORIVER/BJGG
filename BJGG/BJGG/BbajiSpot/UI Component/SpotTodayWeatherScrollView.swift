//
//  SpotTodayWeatherScrollView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/20.
//

import UIKit

final class SpotTodayWeatherScrollView: UIScrollView {

    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.showsVerticalScrollIndicator = false
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
