//
//  SpotViewController.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit
import SnapKit

class BbajiSpotViewController: UIViewController {

    private var liveCameraView = LiveCameraView()
    private var spotInfoView = SpotInfoView()
    private var spotWeatherInfoView = SpotWeatherInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        // Do any additional setup after loading the view.
    }
    
    private func layoutConfigure() {
        
        let safeArea = view.safeAreaLayoutGuide
        let viewWidth = UIScreen.main.bounds.width
        
        view.addSubview(liveCameraView)
        view.addSubview(spotInfoView)
        view.addSubview(spotWeatherInfoView)
        
        liveCameraView.snp.makeConstraints({ make in
            make.top.equalTo(safeArea.snp.top)
            make.leading.equalTo(safeArea.snp.leading)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.height.equalTo(viewWidth * 9 / 16)
        })
        
        spotInfoView.snp.makeConstraints({ make in
            make.top.equalTo(liveCameraView.snp.bottom).inset(-16)
            make.leading.equalTo(safeArea.snp.leading).inset(16)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.height.equalTo(166)
        })

        spotWeatherInfoView.snp.makeConstraints({ make in
            make.top.equalTo(spotInfoView.snp.bottom).inset(-12)
            make.leading.equalTo(safeArea.snp.leading).inset(16)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.height.equalTo(306)
        })
        
        view.backgroundColor = .white
        liveCameraView.backgroundColor = .yellow
        spotInfoView.backgroundColor = .blue
        spotWeatherInfoView.backgroundColor = .red
        
    }
    
}
