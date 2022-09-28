//
//  BbajiHomeViewController.swift
//  BJGG
//
//  Created by 이재웅 on 2022/08/28.
//

import UIKit
import SnapKit

class BbajiHomeViewController: UIViewController {
    private let bbajiTitleView = BbajiTitleView()
    private let bbajiListView = BbajiListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bbagaBack
        
        layoutConfigure()
    }
}

private extension BbajiHomeViewController {
    func layoutConfigure() {
        [
            bbajiTitleView,
            bbajiListView
        ].forEach { view.addSubview($0) }
        
        bbajiTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51.0)
            $0.leading.equalToSuperview().inset(CGFloat.superViewInset)
            $0.trailing.equalToSuperview().inset(CGFloat.superViewInset)
            $0.height.equalTo(90.0)
        }
        
        bbajiListView.snp.makeConstraints {
            $0.top.equalTo(bbajiTitleView.snp.bottom).offset(198.0)
            $0.leading.equalToSuperview().inset(CGFloat.superViewInset)
            $0.trailing.equalToSuperview().inset(CGFloat.superViewInset)
            $0.bottom.equalToSuperview()
        }
    }
}
