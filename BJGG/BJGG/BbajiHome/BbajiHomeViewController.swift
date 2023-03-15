//
//  BbajiHomeViewController.swift
//  BJGG
//
//  Created by 이재웅 on 2022/08/28.
//

import UIKit
import SnapKit

final class BbajiHomeViewController: UIViewController {
    private lazy var bbajiTitleView = BbajiTitleView()
    private lazy var bbajiListView = BbajiListView()
    private lazy var backgroundImageView = HomeBackgroundImageView()

    private var weatherManager: WeatherManager?
    private let bbajiInfo = [BbajiInfo()]
    private var weatherData: [(time: String, iconName: String, temp: String, probability: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

extension BbajiHomeViewController: BbajiListViewDelegate {
    func pushBbajiSpotViewController() {
        self.navigationController?.pushViewController(BbajiSpotViewController(), animated: true)
    }
}

extension BbajiHomeViewController {
    func requestWeatherItems() {
        weatherManager = WeatherManager()
        
        let bbajiCoorX = bbajiInfo[0].getCoordinate().x
        let bbajiCoorY = bbajiInfo[0].getCoordinate().y
        
        Task {
            do {
                if let weatherItems = try await weatherManager?.requestCurrentTimeWeather(nx: bbajiCoorX, ny: bbajiCoorY).response.body.items {
                    let weatherSet = weatherItems.requestCurrentWeatherItem()
                    let weatherData = weatherItems.requestWeatherDataSet(weatherSet)
                    
                    self.weatherData = weatherData
                    bbajiListView.configureWeatherArray(convertToListWeatherArray(from: self.weatherData))
                    bbajiListView.reloadCollectionView()
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
    }
    
    private func convertToListInfoArray(from bbajiInfoArray: [BbajiInfo]) -> [ListInfo] {
        var listInfoArray: [ListInfo] = []
        for info in bbajiInfoArray {
            let listInfo = (info.getAddress(), info.getName(), info.getThumbnailImgName())
            listInfoArray.append(listInfo)
        }
        
        return listInfoArray
    }
    
    private func convertToListWeatherArray(from weatherData: [(time: String, iconName: String, temp: String, probability: String)]) -> [ListWeather] {
        var listWeatherArray: [ListWeather] = []
        for weather in weatherData {
            let listWeather = ListWeather(weather.iconName, weather.temp)
            listWeatherArray.append(listWeather)
        }
        
        return listWeatherArray
    }
}


private extension BbajiHomeViewController {
    func configure() {
        configureLayout()
        configureDelegate()
        
        bbajiListView.configure(convertToListWeatherArray(from: weatherData), listInfoArray: convertToListInfoArray(from: bbajiInfo))
    }
    
    func configureDelegate() {
        bbajiListView.delegate = self
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
}
