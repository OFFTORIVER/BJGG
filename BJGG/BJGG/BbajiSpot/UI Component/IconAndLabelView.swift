//
//  IconAndLabelView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/19.
//

import UIKit

final class IconAndLabelView: UIView {
    let addressLabel = UILabel()
    
    required init(imageName: String, text: String) {
        super.init(frame: CGRect.zero)
        
        let addressImage = UIImageView(image: UIImage(named: imageName))
        
        [addressImage, addressLabel].forEach({
            self.addSubview($0)
        })
        
        addressImage.snp.makeConstraints({ make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        addressLabel.snp.makeConstraints({ make in
            make.leading.equalTo(addressImage.snp.trailing).offset(BbajiConstraints.iconOffset)
            make.centerY.equalTo(addressImage.snp.centerY)
            make.height.equalTo(18)
        })
        
        labelSetting(label: addressLabel, text: text, font: .bbajiFont(.button1), alignment: .left)
        addressLabel.textColor = .bbagaBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

