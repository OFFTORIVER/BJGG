//
//  UIViewController+.swift
//  BJGG
//
//  Created by 황정현 on 10/12/23.
//

import UIKit.UIViewController

extension UIViewController {
    func showNetworkStatusAlert() {
        let alert = UIAlertController(title: nil, message: "인터넷에 연결되어 있지 않습니다.\n네트워크 연결을 확인하세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            alert.removeFromParent()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissPresentedAlert() {
        if let presentedAlert = presentedViewController as? UIAlertController {
            presentedAlert.dismiss(animated: true)
        }
    }
}
