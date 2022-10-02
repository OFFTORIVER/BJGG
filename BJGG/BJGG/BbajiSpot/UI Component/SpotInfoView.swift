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
        labelSetting(label: spotNameLabel, text: info.getName(), font: .bbajiFont(.heading2), alignment: .center)
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
        
        divideLine.backgroundColor = .bbagaBack
        
        self.layer.cornerRadius = 16
        
        let addressInfoView = IconAndLabelView(text: info.getAddress())
        let contactInfoView = IconAndLabelView(text: info.getContact())
        
        [addressInfoView, contactInfoView].forEach({
            self.addSubview($0)
        })
        
        addressInfoView.addressLabel.enableCopyLabelText()
        addressInfoView.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(divideLine.snp.bottom).offset(defaultMargin)
            make.height.equalTo(18)
            make.width.equalTo(180)
        })
        
        contactInfoView.snp.makeConstraints({ make in
            make.leading.equalTo(addressInfoView.snp.leading)
            make.top.equalTo(addressInfoView.snp.bottom).offset(12)
            make.height.equalTo(18)
            make.width.equalTo(180)
        })
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showContactLinkOption(_:)))
        
        contactInfoView.addressLabel.isUserInteractionEnabled = true
        contactInfoView.addressLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func showContactLinkOption(_ sender: UITapGestureRecognizer) {
        let phoneNumber:Int = 01000000000
        if let url = NSURL(string: "tel://0" + "\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

func labelSetting(label: UILabel, text: String, font: UIFont, alignment: NSTextAlignment) {
    label.text = text
    label.font = font
    label.textAlignment = alignment
}
