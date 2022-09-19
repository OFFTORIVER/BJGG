//
//  SpotInfoUIView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

class SpotWeatherInfoView: UIView {
    
    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let defaultMargin: CGFloat = 20
        let defaultMargin2: CGFloat = 12
        
        let weatherAddressLabel = UILabel()
        
        self.addSubview(weatherAddressLabel)
        
        weatherAddressLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(self.snp.top).inset(defaultMargin)
            make.height.equalTo(18)
        })
        
        labelSetting(label: weatherAddressLabel, text: "땡땡구 댕댕동", size: 15, weight: .medium, alignment: .left)
        
        let currentWeatherIconAndLabel = UIView()
        self.addSubview(currentWeatherIconAndLabel)
        
        currentWeatherIconAndLabel.snp.makeConstraints({ make in
            make.top.equalTo(weatherAddressLabel.snp.bottom).inset(-defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(64)
        })
        
        currentWeatherIconAndLabel.backgroundColor = .black
        
        let currentWeatherIcon = UIImageView()
        let currentWeatherLabel = UILabel()
        
        [currentWeatherIcon, currentWeatherLabel].forEach({
            currentWeatherIconAndLabel.addSubview($0)
        })
        
        currentWeatherIcon.snp.makeConstraints({ make in
            make.leading.equalTo(currentWeatherIconAndLabel.snp.leading)
            make.top.equalTo(currentWeatherIconAndLabel.snp.top)
            make.centerY.equalTo(currentWeatherIconAndLabel.snp.centerY)
            make.width.height.equalTo(64)
        })
        
        currentWeatherLabel.snp.makeConstraints({ make in
            make.trailing.equalTo(currentWeatherIconAndLabel.snp.trailing)
            make.centerY.equalTo(currentWeatherIcon.snp.centerY)
            make.width.equalTo(160 - 64)
        })
        
        labelSetting(label: currentWeatherLabel, text: "23°", size: 48, weight: .heavy, alignment: .center)
        
        currentWeatherLabel.backgroundColor = .yellow
        
        currentWeatherIcon.backgroundColor = .cyan
        
        let rainInfoLabel = UILabel()
        self.addSubview(rainInfoLabel)
        
        rainInfoLabel.snp.makeConstraints({ make in
            make.top.equalTo(currentWeatherIconAndLabel.snp.bottom).inset(-defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18)
        })
        
        labelSetting(label: rainInfoLabel, text: "오후 12시 경에 비가 올 예정이에요!", size: 15, weight: .medium, alignment: .center)
        
        let spotWeatherInfoViewDivideLine = UIView()
        self.addSubview(spotWeatherInfoViewDivideLine)
        spotWeatherInfoViewDivideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(rainInfoLabel.snp.bottom).inset(-defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        spotWeatherInfoViewDivideLine.backgroundColor = .black
        
        self.layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
