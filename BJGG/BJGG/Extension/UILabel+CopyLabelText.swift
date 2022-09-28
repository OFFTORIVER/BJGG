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
    }
}
