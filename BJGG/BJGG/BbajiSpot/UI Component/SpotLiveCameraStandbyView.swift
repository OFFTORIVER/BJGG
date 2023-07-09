//
//  SpotLiveCameraStandbyView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/05.
//

import AVFoundation
import Combine
import SnapKit
import UIKit

final class SpotLiveCameraStandbyView: UIView {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        guard let mainLabelFont = UIFont(name: "esamanruOTFBold", size: 100), let subLabelFont = UIFont(name: "esamanruOTFBold", size: 20) else { return  UILabel() }
        label.configureLabelStyle(font: mainLabelFont, alignment: .center)
        label.textColor = .bbagaBlue
        label.text = "물"
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        guard let mainLabelFont = UIFont(name: "esamanruOTFBold", size: 100), let subLabelFont = UIFont(name: "esamanruOTFBold", size: 20) else { return UILabel() }
        label.configureLabelStyle(font: subLabelFont, alignment: .center)
        label.textColor = .bbagaGray3
        label.text = "이 들어오는 중이에요"
        return label
    }()
    
    private var timer: Timer.TimerPublisher?
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func configureLayout() {
        self.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        self.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(BbajiConstraints.iconOffset)
            make.centerX.equalTo(mainLabel)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(36)
        }
    }
    
    private func configureStyle() {
        self.alpha = 1.0
        self.backgroundColor = .black.withAlphaComponent(0.3)
    }
}

// MARK: ViewModel 호출 메소드
extension SpotLiveCameraStandbyView {
    func reloadStandbyView() {
        self.alpha = 1.0
        mainLabel.textColor = .bbagaBlue
        UIView.animate(withDuration: 0.7, animations: {
            self.backgroundColor = .black.withAlphaComponent(0.3)
        })
        makeLoadingAnimation()
    }
    
    func changeStandbyView(isStandbyNeed: Bool) {
        if isStandbyNeed {
            backgroundColor = UIColor(rgb: 0x4C4C4C)
            mainLabel.textColor = UIColor(rgb: 0x626262)
            subLabel.text = "을 불러오지 못했어요"
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.alpha = 0.0
            })
        }
    }
    
    private func makeLoadingAnimation() {
        let text = "이 들어오는 중이에요"
        subLabel.text = "\(text)."
        
        timer = Timer.publish(every: 0.5, tolerance: 0.9, on: .main, in: .default)
        timer?
            .autoconnect()
            .sink { [self] counter in
                var string: String {
                    switch subLabel.text {
                    case "\(text).":       return "\(text).."
                    case "\(text)..":      return "\(text)..."
                    case "\(text)...":     return "\(text)."
                    default:                return "\(text)"
                    }
                }
                subLabel.text = string
            }.store(in: &cancellables)
    }
    
    func stopLoadingAnimation() {
        timer?.connect().cancel()
        timer = nil
    }

}
