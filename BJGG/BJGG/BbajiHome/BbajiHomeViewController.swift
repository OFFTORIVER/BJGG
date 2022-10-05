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
    
    private var weatherManager: WeatherManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bbagaBack
        
        layoutConfigure()
        delegateConfigure()
        
        weatherManager = WeatherManager()
        
        weatherManager?.requestCurrentData(nx: 61, ny: 126) { [weak self] success, reponse in
            guard let self = self else { return }
            guard let response = reponse as? Response else {
                print("Error : API 호출 실패")
                return
            }
            
            let body = response.body
            let items = body.items
            let weatherItem = items.requestCurrentWeatherItem()
            let data = items.requestWeatherDataSet(weatherItem)
            let weatherData = data.first
            
            DispatchQueue.main.async {
                self.bbajiListView.updateWeatherData(iconName: weatherData?.iconName, temp: weatherData?.temp)
                self.bbajiListView.reloadCollectionView()
            }
        }
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
    
    func delegateConfigure() {
        bbajiListView.delegate = self
    }
}

extension BbajiHomeViewController: BbajiListViewDelegate {
    func pushBbajiSpotViewController() {
        self.navigationController?.pushViewController(BbajiSpotViewController(), animated: true)
    }
}
