//
//  BbajiHomeViewController.swift
//  BJGG
//
//  Created by 이재웅 on 2022/08/28.
//

import UIKit
import SnapKit
import Combine

typealias BbajiHomeWeather = (time: String, iconName: String, temp: String, probability: String)

final class BbajiHomeViewController: UIViewController {
    private lazy var bbajiTitleView = BbajiTitleView()
    private lazy var bbajiListView = BbajiListView()
    private lazy var backgroundImageView = BbajiHomeBackgroundImageView()

    private var weatherManager: WeatherManager?
    private let bbajiInfoArray = [BbajiInfo()]
    private var weatherData: [BbajiHomeWeather] = []
    
    private let viewModel = BbajiHomeViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        let listInfoArray = convertToListInfoArray(from: bbajiInfoArray)
        
        viewModel.$homeWeather
            .receive(on: DispatchQueue.main)
            .map { [weak self] homeWeathers in
                return self?.convertToListWeatherArray(from: homeWeathers) ?? []
            }
            .sink { [weak self] listWeathers in
                print("sink success")
                self?.bbajiListView.configure(listWeathers, listInfoArray: listInfoArray)
            }
            .store(in: &cancellable)
    }
    
    private func configure() {
        configureLayout()
        configureDelegate()
        configureComponent()
    }
}

extension BbajiHomeViewController: BbajiListViewDelegate {
    func pushBbajiSpotViewController() {
        self.navigationController?.pushViewController(BbajiSpotViewController(), animated: true)
    }
}

extension BbajiHomeViewController {
    func configureComponent() {

    }
}

private extension BbajiHomeViewController {
    func configureDelegate() {
        bbajiListView.bbajiListViewDelegate = self
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
    
    func configureLayoutForNotNotch() {
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
    
    func convertToListInfoArray(from bbajiInfoArray: [BbajiInfo]) -> [BbajiListInfo] {
        var listInfoArray: [BbajiListInfo] = []
        for info in bbajiInfoArray {
            let listInfo = (info.getAddress(), info.getName(), info.getThumbnailImgName())
            listInfoArray.append(listInfo)
        }
        
        return listInfoArray
    }
    
    func convertToListWeatherArray(from weatherData: [BbajiHomeWeather]) -> [BbajiListWeather] {
        var listWeatherArray: [BbajiListWeather] = []
        for weather in weatherData {
            let listWeather = BbajiListWeather(weather.iconName, weather.temp)
            listWeatherArray.append(listWeather)
        }
        
        return listWeatherArray
    }
}
