//
//  BbajiTitleView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit
import SnapKit

final class BbajiTitleView: UIView {
    private let bbajiTitleLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        
        return imageView
    }()
    
    private let bbajiTitleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "빠지가까"
        label.font = .bbajiFont(.heading2)
        label.textColor = .bbagaGray4
        
        return label
    }()
    
    private let bbajiTitleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 빠지의 물 상태를 확인해보세요!"
        label.font = .bbajiFont(.body1)
        label.textColor = .bbagaGray4
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BbajiTitleView {
    private func configureLayout() {
        [
            bbajiTitleLogoImage,
            bbajiTitleNameLabel,
            bbajiTitleDescriptionLabel
        ].forEach { addSubview($0) }
        
        bbajiTitleLogoImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(103.0)
            $0.height.equalTo(35.0)
        }
        
        bbajiTitleNameLabel.snp.makeConstraints {
            $0.top.equalTo(bbajiTitleLogoImage.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        bbajiTitleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bbajiTitleNameLabel.snp.bottom).offset(BbajiConstraints.space8)
            $0.centerX.equalToSuperview()
        }
    }
}
