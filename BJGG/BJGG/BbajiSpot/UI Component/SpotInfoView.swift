//
//  WeatherInfoView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

class SpotInfoView: UIView {

    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let spotInfoViewDivideLine = UIView()
        self.addSubview(spotInfoViewDivideLine)
        
        spotInfoViewDivideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top).inset(72)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        spotInfoViewDivideLine.backgroundColor = .black
        
        self.layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
