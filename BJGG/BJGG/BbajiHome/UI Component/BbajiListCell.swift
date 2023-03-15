//
//  BbajiListCell.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit
import SnapKit

final class BbajiListCell: UICollectionViewCell {
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    func configure(_ indexPathRow: Int, locationName: String? = nil, bbajiName: String? = nil, backgroundImageName: String? = nil, iconName: String? = nil, temp: String? = nil) {
        configureLayout()
        configureStyle()
        
        if let imageName = backgroundImageName {
            backgroundImageView.image = UIImage(named: imageName)
        }
        
        if let locationName = locationName {
            locationLabel.text = locationName
        }
        
        if let bbajiName = bbajiName {
            nameLabel.text = bbajiName
        }
        
        if let iconName = iconName {
            weatherImageView.image = UIImage(named: iconName)
        }
        
        if let temp = temp {
            tempLabel.text = "\(temp)º"
        }
        
        if indexPathRow != 1 {
            previewView.isHidden = true
        } else {
            tempLabel.isHidden = true
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bbajiDefaultBackgroundImage")
        
        return imageView
    }()
    
    private let shadowView = ShadowGradientView()
    private let previewView = PreviewView()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .bbajiFont(.body1)
        label.textColor = .bbagaGray2
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bbajiFont(.heading2)
        label.textColor = .bbagaGray4
        
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .bbajiFont(.heading3)
        label.textColor = .bbagaGray4
        
        return label
    }()
}

extension BbajiListCell {
    private func configureLayout() {
        let iconWidth: CGFloat = 28.0
        
        [
            backgroundImageView,
            shadowView,
            locationLabel,
            nameLabel,
            tempLabel,
            weatherImageView,
            previewView
        ].forEach { addSubview($0) }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(130.0)
            $0.leading.equalToSuperview().inset(BbajiConstraints.viewInset)
            $0.trailing.equalToSuperview().inset(BbajiConstraints.viewInset)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(BbajiConstraints.labelOffset)
            $0.leading.equalTo(locationLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(BbajiConstraints.viewInset)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top)
            $0.trailing.equalToSuperview().inset(BbajiConstraints.viewInset)
            $0.bottom.equalTo(nameLabel.snp.bottom)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top)
            $0.trailing.equalTo(tempLabel.snp.leading).offset(-BbajiConstraints.labelOffset)
            $0.width.equalTo(iconWidth)
            $0.height.equalTo(iconWidth)
        }
        
        previewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureStyle() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
}

