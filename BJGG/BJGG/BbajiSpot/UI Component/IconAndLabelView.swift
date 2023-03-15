//
//  IconAndLabelView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/19.
//

import UIKit

final class IconAndLabelView: UIView {
    
    let descriptionLabel = UILabel()
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
        configureStyle()
    }
    
    private func configureLayout() {
        [descriptionImageView, descriptionLabel].forEach({
            self.addSubview($0)
        })
        
        descriptionImageView.snp.makeConstraints({ make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        descriptionLabel.snp.makeConstraints({ make in
            make.leading.equalTo(descriptionImageView.snp.trailing).offset(BbajiConstraints.iconOffset)
            make.centerY.equalTo(descriptionImageView.snp.centerY)
            make.height.equalTo(18)
        })
    }
    
    private func configureStyle() {
        descriptionLabel.textColor = .bbagaBlue
        descriptionLabel.configureLabelStyle(font: .bbajiFont(.button1), alignment: .left)
    }
    
    func configureComponent(imageName: String, description: String) {
        descriptionImageView.image = UIImage(named: imageName)
        descriptionLabel.text = description
    }
}

