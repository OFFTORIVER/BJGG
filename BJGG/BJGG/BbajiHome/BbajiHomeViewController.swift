//
//  BbajiHomeViewController.swift
//  BJGG
//
//  Created by 이재웅 on 2022/08/28.
//

import UIKit
import SnapKit

final class BbajiHomeViewController: UIViewController {
    private let bbajiTitleView = BbajiTitleView()
    private let bbajiListView = BbajiListView()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeBackgroundImage")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        delegateConfigure()
    }
}

private extension BbajiHomeViewController {
    func layoutConfigure() {
        [
            backgroundImageView,
            bbajiTitleView,
            bbajiListView
        ].forEach { view.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
    
    func delegateConfigure() {
        bbajiListView.delegate = self
    }
}

extension BbajiHomeViewController: BbajiListViewDelegate {
    func pushBbajiSpotViewController() {
        self.navigationController?.pushViewController(BbajiSpotViewController(), animated: true)
    }
}
