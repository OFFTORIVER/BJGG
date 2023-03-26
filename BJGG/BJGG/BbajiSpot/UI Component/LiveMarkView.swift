//
//  LiveMarkView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit
import SnapKit

final class LiveMarkView: UIView {

    private lazy var liveLabel: UILabel = {
        let label = UILabel()
        label.configureLabelStyle(font: .systemFont(ofSize: 12, weight: .medium), alignment: .center)
        label.textColor = .clear
        label.text = "LIVE"
        return label
    }()
    
    override init(frame: CGRect  =  CGRect()) {
        super.init(frame: frame)

        backgroundColor = UIColor.lightGray
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
    }

    private func configureLayout() {
        addSubview(liveLabel)
        liveLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
        }
    }
    
    func setUpLiveLabelRadius(to: CGFloat) {
        self.layer.cornerRadius = to
    }
    
    func liveMarkActive(to active: Bool) {
        let currentColor = backgroundColor
        var targetBackgroundColor: UIColor? = currentColor
        var targetLabelColor: UIColor?
        
        if active {
            targetBackgroundColor = UIColor(rgb: 0xE17481)
            targetLabelColor = .white
        } else {
            targetBackgroundColor = .clear
            targetLabelColor = .clear
            liveLabel.textColor = targetLabelColor
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.3, animations: {
            self.backgroundColor = targetBackgroundColor
            self.liveLabel.textColor = targetLabelColor
            self.isHidden = !active
        })
    }
}
