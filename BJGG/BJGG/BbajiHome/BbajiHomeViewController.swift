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
    let bbajiListView = BbajiListView()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        let backgroundImageName = UIDevice.current.hasNotch ? "homeBackgroundImage" : "homeBackgroundImageNotNotch"
        
        imageView.image = UIImage(named: backgroundImageName)
        
        return imageView
    }()

    private var weatherManager: WeatherManager?
    private let bbajiInfo = [BbajiInfo()]
    private var weatherData: [(time: String, iconName: String, temp: String, probability: String)]? {
        didSet {
            if weatherData != nil {
                self.bbajiListView.updateWeatherData(self.weatherData!)
                self.bbajiListView.updateBbajiInfo(self.bbajiInfo)
                self.bbajiListView.reloadCollectionView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weatherData = weatherData {
            self.bbajiListView.updateWeatherData(weatherData)
        }
        
        self.bbajiListView.updateBbajiInfo(self.bbajiInfo)
        self.bbajiListView.reloadCollectionView()
        
        configure()
    }
}

private extension BbajiHomeViewController {
    func configure() {
        configureLayout()
        configureDelegate()
    }
    
    func configureLayout() {
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
            $0.leading.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.trailing.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.height.equalTo(90.0)
        }
        
        bbajiListView.snp.makeConstraints {
            $0.top.equalTo(bbajiTitleView.snp.bottom).offset(198.0)
            $0.leading.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.trailing.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.bottom.equalToSuperview()
        }
        
        if !UIDevice.current.hasNotch {
            configureLayoutForNotNotch()
        }
    }
    
    private func configureLayoutForNotNotch() {
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
    
    func configureDelegate() {
        bbajiListView.delegate = self
    }
}

extension BbajiHomeViewController: BbajiListViewDelegate {
    func pushBbajiSpotViewController() {
        self.navigationController?.pushViewController(BbajiSpotViewController(), animated: true)
    }
}

extension BbajiHomeViewController {
    func requestAPI() {
        weatherManager = WeatherManager()
        
        let bbajiCoorX = bbajiInfo[0].getCoordinate().x
        let bbajiCoorY = bbajiInfo[0].getCoordinate().y
        
        Task {
            do {
                if let weatherItems = try await weatherManager?.requestCurrentTimeWeather(nx: bbajiCoorX, ny: bbajiCoorY).response.body.items {
                    let weatherSet = weatherItems.requestCurrentWeatherItem()
                    let weatherData = weatherItems.requestWeatherDataSet(weatherSet)
                    
                    self.weatherData = weatherData
                }
            } catch WeatherManagerError.apiError(let message) {
                print(message)
            } catch WeatherManagerError.networkError(let message) {
                print(message)
            } catch DecodingError.dataCorrupted(let description) {
                print(description.codingPath, description.debugDescription, description.underlyingError ?? "", separator: "\n")
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //[Deprecated] completionHandler를 사용한 WeatherManger 사용
        /*
        weatherManager?.requestCurrentData(nx: bbajiCoorX, ny: bbajiCoorY) { [weak self] success, reponse in
            guard let self = self else {
                return
            }
            guard let response = reponse as? WeatherResponse else {
                print("Error : API 호출 실패")
                return
            }

            let body = response.body
            let items = body.items
            let weatherItem = items.requestCurrentWeatherItem()
            let data = items.requestWeatherDataSet(weatherItem)

            self.weatherData = data
        }
         */
    }
}
