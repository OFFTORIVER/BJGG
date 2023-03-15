//
//  SpotTodayWeatherCollectionViewCell.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/20.
//

import UIKit

final class SpotTodayWeatherCollectionViewCell: UICollectionViewCell {
    
    var currentRainPercentLabel = UILabel()
    var currentWeatherImgView = UIImageView()
    var temperatureLabel = UILabel()
    var timeLabel = UILabel()
    
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }

    func configureLayout(isRain: Bool) {
        self.addSubview(currentRainPercentLabel)
        self.addSubview(currentWeatherImgView)
        if isRain {
            currentRainPercentLabel.snp.remakeConstraints({ make in
                make.top.equalTo(self.snp.top)
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(48)
                make.height.equalTo(19)
            })
            currentWeatherImgView.snp.remakeConstraints({ make in
                make.top.equalTo(currentRainPercentLabel.snp.bottom)
                make.centerX.equalTo(self.snp.centerX)
                make.width.height.equalTo(28)
            })
        } else {
            currentWeatherImgView.snp.remakeConstraints({ make in
                make.top.equalTo(self.snp.top)
                make.centerX.equalTo(self.snp.centerX)
                make.width.height.equalTo(48)
            })
        }
        
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.remakeConstraints({ make in
            make.top.equalTo(currentWeatherImgView.snp.bottom).offset(BbajiConstraints.iconOffset)
            make.centerX.equalTo(currentWeatherImgView.snp.centerX)
            make.height.equalTo(22)
            make.width.equalTo(60)
        })
        
        self.addSubview(timeLabel)
        timeLabel.snp.remakeConstraints({ make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(2)
            make.centerX.equalTo(temperatureLabel.snp.centerX)
            make.height.equalTo(18)
            make.width.equalTo(60)
        })
    }
}
