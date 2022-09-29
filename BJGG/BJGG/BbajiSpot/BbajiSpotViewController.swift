//
//  SpotViewController.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit
import SnapKit

final class BbajiSpotViewController: UIViewController {
    private var liveCameraView = SpotLiveCameraView()
    private var spotInfoView = SpotInfoView()
    private var spotWeatherInfoView = SpotWeatherInfoView()
    
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
        
        [
            liveCameraView,
            spotInfoView,
            spotWeatherInfoView
        ].forEach({ view.addSubview($0) })
        
        liveCameraView.snp.makeConstraints({ make in
            make.top.equalTo(safeArea.snp.top)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.height.equalTo(viewWidth * 9 / 16)
        })
        
        liveCameraView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth * 9 / 16)

        self.addChild(liveCameraView.avpController)
        
        spotInfoView.snp.makeConstraints({ make in
            make.top.equalTo(liveCameraView.snp.bottom).offset(viewToViewMargin)
            make.leading.equalTo(safeArea.snp.leading).inset(defaultMargin)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.height.equalTo(166)
        })
        
        spotWeatherInfoView.snp.makeConstraints({ make in
            make.top.equalTo(spotInfoView.snp.bottom).offset(viewToViewMargin)
            make.leading.equalTo(safeArea.snp.leading).inset(defaultMargin)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.height.equalTo(306)
        })
        
        view.backgroundColor = .bbagaBack
        spotInfoView.backgroundColor = .bbagaGray4
        spotWeatherInfoView.backgroundColor = .bbagaGray4
    }
}
