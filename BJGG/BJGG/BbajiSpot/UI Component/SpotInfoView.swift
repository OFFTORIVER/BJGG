//
//  WeatherInfoView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

final class SpotInfoView: UIView {
    
    private let bbajiInfo = BbajiInfo()
    
    private let spotNameLabel = UILabel()
    private let divideLine = UIView()
    private let addressInfoView = IconAndLabelView()
    private let contactInfoView = IconAndLabelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
        configureComponent()
    }
    
    private func configureLayout() {
        
        let defaultMargin: CGFloat = BbajiConstraints.viewInset
        
        self.addSubview(spotNameLabel)
        spotNameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(self.snp.top).inset(defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(32)
        })
        
        self.addSubview(divideLine)
        
        divideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(spotNameLabel.snp.bottom).offset(defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        [addressInfoView, contactInfoView].forEach({
            self.addSubview($0)
        })
        
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
    }
    
    private func configureStyle() {
        self.layer.cornerRadius = 16
        
        divideLine.backgroundColor = .bbagaBack
        
        spotNameLabel.configureLabelStyle(font: .bbajiFont(.heading2), alignment: .center)
        spotNameLabel.textColor = .bbagaGray1
    }
    
    private func configureComponent() {
        spotNameLabel.text = bbajiInfo.getName()
        
        addressInfoView.descriptionLabel.enableCopyLabelText()
        
        addressInfoView.configureComponent(imageName: "addressPin.png", description: bbajiInfo.getAddress())
        contactInfoView.configureComponent(imageName: "telephone.png", description: bbajiInfo.getContact())
        
        // MARK: Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showContactLinkOption(_:)))
        contactInfoView.descriptionLabel.addGestureRecognizer(tapGestureRecognizer)
        contactInfoView.descriptionLabel.isUserInteractionEnabled = true
    }
    
    @objc func showContactLinkOption(_ sender: UITapGestureRecognizer) {
        let phoneNumber:Int = Int(bbajiInfo.getContact().components(separatedBy: ["-"]).joined()) ?? 01000000000
        if let url = NSURL(string: "tel://0" + "\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
