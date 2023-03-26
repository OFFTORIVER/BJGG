//
//  SpotWeatherAPIInfoView.swift
//  BJGG
//
//  Created by 황정현 on 2022/10/05.
//

import UIKit

final class SpotWeatherAPIInfoView: UIView {
    
    private let currentAPIInfoLabel: UILabel = {
        let label = UILabel()
        label.configureLabelStyle(font: .bbajiFont(.heading2), alignment: .center)
        label.textColor = .bbagaBlue
        label.text = "오늘의 날씨는..."
        return label
    }()
    
    private let currentAPIInfoLabelDeco: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "subLogo")
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
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
        self.addSubview(currentAPIInfoLabel)
        currentAPIInfoLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(30)
        })
        
        self.addSubview(currentAPIInfoLabelDeco)
        currentAPIInfoLabelDeco.snp.makeConstraints({ make in
            make.leading.equalTo(currentAPIInfoLabel.snp.leading)
            make.bottom.equalTo(currentAPIInfoLabel.snp.top)
            make.width.equalTo(71)
            make.height.equalTo(24)
        })
    }
    
    private func configureStyle() {
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
    }
    
    func setDefaultUI() {
        backgroundColor = .black.withAlphaComponent(0.7)
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
