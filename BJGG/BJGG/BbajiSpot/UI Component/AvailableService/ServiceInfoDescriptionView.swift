//
//  ServiceInfoDescriptionView.swift
//  BJGG
//
//  Created by 황정현 on 2023/05/10.
//

import UIKit

final class ServiceInfoDescriptionView: UIView {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: UIFont.Pretendard.regular.rawValue, size: 10.0) ?? UIFont()
        label.textColor = .bbagaGray2
        label.configureLabelStyle(font: font, alignment: .center)
        return label
    }()
    
    private let descriptionImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
    }
    
    private func configureLayout() {
        [descriptionImageView, descriptionLabel].forEach { self.addSubview($0) }
        
        descriptionImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionImageView.snp.bottom).offset(BbajiConstraints.iconNameOffset)
            make.centerX.equalTo(descriptionImageView.snp.centerX)
            make.width.equalTo(38)
            make.height.equalTo(12)
        }
    }
    
    func configureComponent(serviceInfo: BbajiServiceInfo) {
        descriptionImageView.image = UIImage(named: serviceInfo.rawValue)
        descriptionLabel.text = serviceInfo.serviceInfoName()
    }

}
