//
//  ScreenSizeControlButton.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

protocol ScreenSizeControlButtonDelegate: AnyObject {
    func changeScreenSize(screenSizeStatus: ScreenSizeStatus)
}

enum ScreenSizeStatus {
    case normal
    case full
    
    mutating func changeButtonImage() -> UIImage {
        switch self {
        case .normal:
            self = .full
            let image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return image!
        case .full:
            self = .normal
            let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return image!
        }
    }
}

final class ScreenSizeControlButton: UIButton {
    
    var screenSizeStatus: ScreenSizeStatus = .normal
    
    weak var delegate: ScreenSizeControlButtonDelegate?
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        
        let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.setImage(image, for: .normal)
        self.addTarget(self, action: #selector(didPressScreenSizeControlButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didPressScreenSizeControlButton() {
        self.setImage(screenSizeStatus.changeButtonImage(), for: .normal)
        self.delegate?.changeScreenSize(screenSizeStatus: screenSizeStatus)
    }
}
