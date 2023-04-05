//
//  ControlStatus.swift
//  BJGG
//
//  Created by 황정현 on 2023/04/05.
//

import UIKit

enum ControlStatus {
    case exist
    case hidden
    
    func changeControlStatusView(view: UIView) {
        switch self {
        case .exist:
            UIView.animate(withDuration: 0.2, delay: TimeInterval(0.0), animations: {
                view.alpha = 0.0
            })
        case .hidden:
            UIView.animate(withDuration: 0.2, delay: TimeInterval(0.0), animations: {
                view.alpha = 1.0
            })
        }
    }
}

