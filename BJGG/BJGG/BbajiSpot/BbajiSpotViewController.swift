//
//  SpotViewController.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit
import SnapKit

final class BbajiSpotViewController: UIViewController {
    private let liveCameraView = SpotLiveCameraView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let spotInfoView = SpotInfoView()
    private let spotWeatherInfoView = SpotWeatherInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        liveCameraView.liveCameraSetting(size: liveCameraView.frame.size)
    }
    
    private func layoutConfigure() {
        
        let safeArea = view.safeAreaLayoutGuide
        let viewWidth = UIScreen.main.bounds.width
        let defaultMargin = CGFloat.superViewInset
        let viewToViewMargin = CGFloat.componentOffset
        
        view.addSubview(liveCameraView)
        
        liveCameraView.snp.makeConstraints({ make in
            make.top.equalTo(safeArea.snp.top)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.height.equalTo(viewWidth * 9 / 16)
        })
        
        liveCameraView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth * 9 / 16)

        self.addChild(liveCameraView.avpController)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({make in
            make.top.equalTo(liveCameraView.snp.bottom)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.bottom.equalTo(safeArea.snp.bottom)
        })
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints({ make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(508)
        })
        scrollView.showsVerticalScrollIndicator = false
        
        [
            spotInfoView,
            spotWeatherInfoView
        ].forEach({ scrollContentView.addSubview($0) })

        spotInfoView.snp.makeConstraints({ make in
            make.top.equalTo(scrollContentView.snp.top).inset(viewToViewMargin)
            make.leading.equalTo(scrollContentView.snp.leading).inset(defaultMargin)
            make.trailing.equalTo(scrollContentView.snp.trailing).inset(defaultMargin)
            make.height.equalTo(166)
        })

        spotWeatherInfoView.snp.makeConstraints({ make in
            make.top.equalTo(spotInfoView.snp.bottom).offset(viewToViewMargin)
            make.leading.equalTo(scrollContentView.snp.leading).inset(defaultMargin)
            make.trailing.equalTo(scrollContentView.snp.trailing).inset(defaultMargin)
            make.height.equalTo(306)
        })

        view.backgroundColor = .bbagaBack
        spotInfoView.backgroundColor = .bbagaGray4
        spotWeatherInfoView.backgroundColor = .bbagaGray4
        
    }
}
