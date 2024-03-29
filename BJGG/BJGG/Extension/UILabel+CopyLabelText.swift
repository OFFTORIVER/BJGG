//
//  UILabel+CopyLabelText.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/28.
//

import UIKit

extension UILabel {
    func enableCopyLabelText() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyLabelText(_:)))
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func copyLabelText(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        UIPasteboard.general.string = label.text
        showToastMessage()
    }
    
    func showToastMessage() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let toastLabel = UILabel()
        
        let margin = BbajiConstraints.space16 * 1.4
        
        toastLabel.frame = CGRect(x: margin, y: height * 0.88, width: width - margin * 2, height: 45)

        toastLabel.text = "클립보드에 복사되었습니다."
        toastLabel.textColor = UIColor.bbagaGray4
        toastLabel.backgroundColor = UIColor.bbagaGray1
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 4
        toastLabel.clipsToBounds = true
        toastLabel.isUserInteractionEnabled = false
        toastLabel.layer.opacity = 0
        self.window?.rootViewController?.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.layer.opacity = 0.9
        }, completion: {_ in
            UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut, animations: {
                toastLabel.layer.opacity = 0
            })
        })
    }
    
    func configureLabelStyle(font: UIFont, alignment: NSTextAlignment) {
        self.font = font
        self.textAlignment = alignment
    }
}
