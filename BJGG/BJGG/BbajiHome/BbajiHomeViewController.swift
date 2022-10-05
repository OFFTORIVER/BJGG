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

    private var weatherManager: WeatherManager?
    private let bbajiInfo = BbajiInfo()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        delegateConfigure()
        
        weatherManager = WeatherManager()
        
        let bbajiCoorX = bbajiInfo.getCoordinate().0
        let bbajiCoorY = bbajiInfo.getCoordinate().1
        
        weatherManager?.requestCurrentData(nx: bbajiCoorX, ny: bbajiCoorY) { [weak self] success, reponse in
            guard let self = self else { return }
            guard let response = reponse as? Response else {
                print("Error : API 호출 실패")
                return
            }
            
            let body = response.body
            let items = body.items
            let weatherItem = items.requestCurrentWeatherItem()
            let data = items.requestWeatherDataSet(weatherItem)
            
            DispatchQueue.main.async {
                self.bbajiListView.updateWeatherData(data)
                self.bbajiListView.reloadCollectionView()
            }
        }
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
