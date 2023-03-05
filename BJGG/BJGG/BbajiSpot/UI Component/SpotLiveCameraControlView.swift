//
//  SpotLiveCameraControlView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

final class SpotLiveCameraControlView: UIView {

    var shadowView: SpotLiveCameraGradientView = SpotLiveCameraGradientView()
    var screenSizeControlButton: ScreenSizeControlButton = ScreenSizeControlButton()
    var screenSizeControlButtonTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var screenSizeControlButtonBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect  =  CGRect()) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        
        let shadowHeight = UIScreen.main.bounds.width * 9 / 16 / 2
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: shadowHeight),
        ])
        
        let screenSizeControlButtonSize = UIScreen.main.bounds.width / 12
        addSubview(screenSizeControlButton)
        screenSizeControlButton.translatesAutoresizingMaskIntoConstraints = false
        screenSizeControlButtonTrailingConstraint = screenSizeControlButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        screenSizeControlButtonBottomConstraint = screenSizeControlButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        NSLayoutConstraint.activate([
            screenSizeControlButton.widthAnchor.constraint(equalToConstant: screenSizeControlButtonSize),
            screenSizeControlButton.heightAnchor.constraint(equalToConstant: screenSizeControlButtonSize),
            screenSizeControlButtonTrailingConstraint,
            screenSizeControlButtonBottomConstraint
        ])
    }
}

