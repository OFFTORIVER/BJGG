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
        
    }

}
