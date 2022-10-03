//
//  SpotTodayWeatherCollectionViewCell.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/20.
//

import UIKit

final class SpotTodayWeatherCollectionViewCell: UICollectionViewCell {
    
    var currentWeatherImgView = UIImageView()
    var temperatureLabel = UILabel()
    var timeLabel = UILabel()
    
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }

    private func layoutConfigure() {
        
        self.addSubview(currentWeatherImgView)
        currentWeatherImgView.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(48)
            
        })
        
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints({ make in
            make.top.equalTo(currentWeatherImgView.snp.bottom).offset(CGFloat.iconOffset)
            make.leading.equalTo(currentWeatherImgView.snp.leading)
            make.centerX.equalTo(currentWeatherImgView.snp.centerX)
            make.height.equalTo(22)
            make.width.equalTo(48)
        })
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(2)
            make.centerX.equalTo(temperatureLabel.snp.centerX)
            make.height.equalTo(18)
            make.width.equalTo(60)
        })
    }
}
