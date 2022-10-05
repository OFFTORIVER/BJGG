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
        let backgroundImageName = UIDevice.current.hasNotch ? "homeBackgroundImage" : "homeBackgroundImageNotNotch"
        
        imageView.image = UIImage(named: backgroundImageName)
        
        return imageView
    }()

    private var weatherManager: WeatherManager?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func layoutConfigureForNotNotch() {
        let noticeLabel: UILabel = {
            let label = UILabel()
            label.text = "다음 빠지는 어디로 가까?"
            label.font = .bbajiFont(.heading4)
            label.textColor = .bbagaBlue
            
            return label
        }()
        
        let logoImageView: UIImageView = {
            let imageView = UIImageView()
            
            imageView.image = UIImage(named: "subLogo")
            
            return imageView
        }()
        
        [
            noticeLabel,
            logoImageView
        ].forEach { view.addSubview($0) }
        
        noticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(42.0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(63.0)
            $0.width.equalTo(71.0)
            $0.height.equalTo(24.0)
            $0.bottom.equalTo(noticeLabel.snp.top)
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
