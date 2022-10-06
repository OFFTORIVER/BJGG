//
//  SpotWeatherAPIInfoView.swift
//  BJGG
//
//  Created by 황정현 on 2022/10/05.
//

import UIKit

// API Test Enum
enum APIStatus {
    case success, loading, failure
}

final class SpotWeatherAPIInfoView: UIView {
    private let currentAPIInfoLabel = UILabel()
    private let currentAPIInfoLabelDeco = UIImageView()
    
    required init() {
        
        super.init(frame: CGRect.zero)
        
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutConfigure() {
        
        self.addSubview(currentAPIInfoLabel)
        currentAPIInfoLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(30)
        })
        labelSetting(label: currentAPIInfoLabel, text: "", font: .bbajiFont(.heading2), alignment: .center)
        currentAPIInfoLabel.textColor = .bbagaBlue
        
        self.addSubview(currentAPIInfoLabelDeco)
        currentAPIInfoLabelDeco.snp.makeConstraints({ make in
            make.leading.equalTo(currentAPIInfoLabel.snp.leading)
            make.bottom.equalTo(currentAPIInfoLabel.snp.top)
            make.width.equalTo(71)
            make.height.equalTo(24)
        })

        currentAPIInfoLabelDeco.image = UIImage(named: "subLogo")
        currentAPIInfoLabelDeco.alpha = 0
        
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
    }
    
    func setDefaultUI() {
        self.backgroundColor = .black.withAlphaComponent(0.7)
        currentAPIInfoLabelDeco.isHidden = true
        currentAPIInfoLabel.text = "오늘의 날씨는..."
    }
    
    func setCurrentUI(weatherAPIIsSuccess: Bool) {
        if weatherAPIIsSuccess {
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                self.alpha = 0
            }, completion: {_ in self.isHidden = true})
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: { [self] in
                backgroundColor = .bbagaGray4
                currentAPIInfoLabelDeco.alpha = 1
                currentAPIInfoLabel.text = "오늘의 날씨를 알 수 없어요!"
            })
        }
    }
}
