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
        
        layoutConfigure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutConfigure() {
        
        let info = InfoSample()
        
        let defaultMargin: CGFloat = 20
        
        let spotNameLabel = UILabel()
        self.addSubview(spotNameLabel)
        labelSetting(label: spotNameLabel, text: info.name, size: 24, weight: .heavy, alignment: .center)
        spotNameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(self.snp.top).inset(defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(32)
        })
        
        let divideLine = UIView()
        self.addSubview(divideLine)
        
        divideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(spotNameLabel.snp.bottom).inset(-defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        divideLine.backgroundColor = .black
        
        self.layer.cornerRadius = 16
        
        let addressInfoView = IconAndLabel(text: info.address)
        let contactInfoView = IconAndLabel(text: info.contact)
        
        [addressInfoView, contactInfoView].forEach({
            self.addSubview($0)
        })
        
        addressInfoView.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(divideLine.snp.bottom).offset(defaultMargin)
            make.height.equalTo(20)
        })
        
        contactInfoView.snp.makeConstraints({ make in
            make.leading.equalTo(addressInfoView.snp.leading)
            make.top.equalTo(addressInfoView.snp.bottom).offset(12)
            make.height.equalTo(20)
        })
        
    }
    
}

class IconAndLabel: UIView {
    
    required init(text: String) {
        
        super.init(frame: CGRect.zero)
        
        let addressImage = UIImageView()
        let addressLabel = UILabel()
        
        [addressImage, addressLabel].forEach({
            self.addSubview($0)
        })
        
        addressImage.snp.makeConstraints({ make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        })
        
        addressImage.backgroundColor = .black
        
        addressLabel.snp.makeConstraints({ make in
            make.leading.equalTo(addressImage.snp.trailing).inset(-8)
            make.centerY.equalTo(addressImage.snp.centerY)
            make.height.equalTo(18)
        })
        
        labelSetting(label: addressLabel, text: text, size: 15, weight: .medium, alignment: .left)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func labelSetting(label: UILabel, text: String, size: CGFloat, weight: UIFont.Weight, alignment: NSTextAlignment) {
    label.text = text
    label.font = UIFont.systemFont(ofSize: size, weight: weight)
    label.textAlignment = alignment
}
