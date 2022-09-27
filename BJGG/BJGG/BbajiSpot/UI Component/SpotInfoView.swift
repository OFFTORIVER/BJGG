//
//  WeatherInfoView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

final class SpotInfoView: UIView {
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutConfigure() {
        let info = BbajiInfo()
        
        let defaultMargin: CGFloat = .viewInset
        
        let spotNameLabel = UILabel()
        self.addSubview(spotNameLabel)
        labelSetting(label: spotNameLabel, text: info.getName(), size: 24, weight: .heavy, alignment: .center)
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
            make.top.equalTo(spotNameLabel.snp.bottom).offset(defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        divideLine.backgroundColor = .black
        
        self.layer.cornerRadius = 16
        
        let addressInfoView = IconAndLabelView(text: info.getAddress())
        let contactInfoView = IconAndLabelView(text: info.getContact())
        
        [addressInfoView, contactInfoView].forEach({
            self.addSubview($0)
        })
        
        addressInfoView.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(divideLine.snp.bottom).offset(defaultMargin)
            make.height.equalTo(18)
        })
        
        contactInfoView.snp.makeConstraints({ make in
            make.leading.equalTo(addressInfoView.snp.leading)
            make.top.equalTo(addressInfoView.snp.bottom).offset(12)
            make.height.equalTo(18)
        })
    }
}

func labelSetting(label: UILabel, text: String, size: CGFloat, weight: UIFont.Weight, alignment: NSTextAlignment) {
    label.text = text
    label.font = UIFont.systemFont(ofSize: size, weight: weight)
    label.textAlignment = alignment
}
