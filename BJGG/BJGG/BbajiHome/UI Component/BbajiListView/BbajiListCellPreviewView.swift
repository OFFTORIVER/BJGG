//
//  BbajiListCellPreviewView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit
import SnapKit

final class BbajiListCellPreviewView: UIView {
    private lazy var fadeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x272727)
        view.layer.opacity = 0.9
        
        return view
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 빠지는 어디로 가까?"
        label.font = .bbajiFont(.heading4)
        label.textColor = .bbagaBlue
        
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "subLogo")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BbajiListCellPreviewView {
    private func configureLayout() {
        [
            fadeView,
            noticeLabel,
            logoImageView
        ].forEach { addSubview($0) }
        
        fadeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64.0)
            $0.leading.equalToSuperview().inset(54.0)
            $0.width.equalTo(71.0)
            $0.height.equalTo(24.0)
            $0.bottom.equalTo(noticeLabel.snp.top)
        }
    }
}
