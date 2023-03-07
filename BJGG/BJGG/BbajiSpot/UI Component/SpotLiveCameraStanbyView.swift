//
//  SpotLiveCameraStanbyView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/05.
//

import AVFoundation
import SnapKit
import UIKit

final class SpotLiveCameraStanbyView: UIView {

    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureLayout()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        self.addSubview(mainLabel)
        mainLabel.snp.makeConstraints({ make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(100)
        })
        
        self.addSubview(subLabel)
        subLabel.snp.makeConstraints({ make in
            make.top.equalTo(mainLabel.snp.bottom).inset(BbajiConstraints.iconOffset)
            make.centerX.equalTo(mainLabel)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(36)
        })
    }
    
    func configureLayout() {
        self.alpha = 1.0
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        mainLabel.font = UIFont(name: "esamanruOTFBold", size: 100)
        mainLabel.textColor = .bbagaBlue
        mainLabel.textAlignment = .center
        mainLabel.text = "물"
        
        subLabel.font = UIFont(name: "esamanruOTFBold", size: 20)
        subLabel.textColor = .bbagaGray3
        subLabel.textAlignment = .center
        subLabel.text = "이 들어오는 중이예요"
    }
    
    func changeStandbyView(as status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            UIView.animate(withDuration: 0.7, animations: {
                self.alpha = 0.0
            })
        default:
            backgroundColor = UIColor(rgb: 0x4C4C4C)
            mainLabel.textColor = UIColor(rgb: 0x626262)
            subLabel.text = "을 불러오지 못했어요"
        }
    }
}
