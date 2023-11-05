//
//  SpotLiveCameraControlView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import Combine
import CombineCocoa
import UIKit
import SnapKit

final class SpotLiveCameraControlView: UIView {

    private var gradientView: SpotLiveCameraGradientView = SpotLiveCameraGradientView()
    private lazy var screenSizeControlButton: ScreenSizeControlButton = ScreenSizeControlButton(spotLiveCameraViewModel: spotLiveCameraViewModel)
    
    private var spotViewModel: SpotViewModel?
    private var spotLiveCameraViewModel: SpotLiveCameraViewModel?
    
    init(spotViewModel: SpotViewModel?, spotLiveCameraViewModel: SpotLiveCameraViewModel?) {
        super.init(frame: CGRect.zero)
        self.spotViewModel = spotViewModel
        self.spotLiveCameraViewModel = spotLiveCameraViewModel
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        let shadowHeight = UIScreen.main.bounds.width * 9 / 16 / 2
        addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: shadowHeight),
        ])
        
        let screenSizeControlButtonSize = UIScreen.main.bounds.width / 12
        addSubview(screenSizeControlButton)
        screenSizeControlButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-4)
            make.trailing.equalTo(self.snp.trailing).offset(-4)
            make.width.equalTo(screenSizeControlButtonSize)
            make.height.equalTo(screenSizeControlButtonSize)
        }
    }
}

