//
//  SpotViewController.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit
import SnapKit

final class BbajiSpotViewController: UIViewController {
    
    let liveCameraView = SpotLiveCameraView()
    private let infoScrollView = UIScrollView()
    private let infoScrollContentView = UIView()
    private var spotInfoView = SpotInfoView()
    private var spotWeatherInfoView = SpotWeatherInfoView()
    
    private var liveMarkView: LiveMarkView = LiveMarkView()
    
    private var screenWidth: CGFloat = CGFloat()
    private var firstAttempt: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override var prefersStatusBarHidden: Bool {
        switch liveCameraView.videoPlayerControlView.screenSizeControlButton.screenSizeStatus {
        case .full:
            return true
        case .normal:
            return false
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        switch liveCameraView.videoPlayerControlView.screenSizeControlButton.screenSizeStatus {
        case .full:
            return true
        case .normal:
            return false
        }
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
        configureComponent()
        configureDelegate()
        configureNotification()
    }
    
    private func configureLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        let viewWidth = UIScreen.main.bounds.width
        let defaultMargin = BbajiConstraints.superViewInset
        let viewToViewMargin = BbajiConstraints.componentOffset
        let liveCameraViewHeight = viewWidth * 9 / 16
        screenWidth = viewWidth

        view.addSubview(liveCameraView)
        liveCameraView.snp.makeConstraints({ make in
            make.centerX.equalTo(safeArea.snp.centerX)
            make.top.equalTo(safeArea.snp.top)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(liveCameraViewHeight)
        })
        
        view.addSubview(liveMarkView)
        liveMarkView.snp.makeConstraints({ make in
            make.leading.equalTo(liveCameraView.snp.leading).inset(8)
            make.top.equalTo(liveCameraView.snp.top).inset(8)
            make.width.equalTo(screenWidth / 8)
            make.height.equalTo(screenWidth / 18)
        })
        
        view.addSubview(infoScrollView)
        infoScrollView.snp.makeConstraints({make in
            make.top.equalTo(liveCameraView.snp.bottom)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.bottom.equalTo(safeArea.snp.bottom)
        })
        
        infoScrollView.addSubview(infoScrollContentView)
        infoScrollContentView.snp.makeConstraints({ make in
            make.top.equalTo(infoScrollView.snp.top)
            make.bottom.equalTo(infoScrollView.snp.bottom)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(UIDevice.current.hasNotch ? 508 : 508 - 32)
        })
        infoScrollView.showsVerticalScrollIndicator = false
        
        [
            spotInfoView,
            spotWeatherInfoView
        ].forEach({ infoScrollContentView.addSubview($0) })

        spotInfoView.snp.makeConstraints({ make in
            make.top.equalTo(infoScrollContentView.snp.top).inset(viewToViewMargin)
            make.leading.equalTo(infoScrollContentView.snp.leading).inset(defaultMargin)
            make.trailing.equalTo(infoScrollContentView.snp.trailing).inset(defaultMargin)
            make.height.equalTo(UIDevice.current.hasNotch ? 163 : 147)
        })

        spotWeatherInfoView.snp.makeConstraints({ make in
            make.top.equalTo(spotInfoView.snp.bottom).offset(viewToViewMargin)
            make.leading.equalTo(infoScrollContentView.snp.leading).inset(defaultMargin)
            make.trailing.equalTo(infoScrollContentView.snp.trailing).inset(defaultMargin)
            make.height.equalTo(UIDevice.current.hasNotch ? 306 : 290)
        })
    }
    
    private func configureStyle() {
        view.backgroundColor = .bbagaBack
        spotInfoView.backgroundColor = .bbagaGray4
        spotWeatherInfoView.backgroundColor = .bbagaGray4
        
        liveMarkView.setUpLiveLabelRadius(to: screenWidth / 36)
    }
    
    func configureComponent() {
        
        liveMarkView.liveMarkActive(to: false)
        
        let weatherManager = WeatherManager()
        
        Task {
            do {
                let weatherItems = try await weatherManager.request24HWeather(nx: 61, ny: 126).response.body.items
                let weatherSet = weatherItems.request24HourWeatherItem()
                let rainData = weatherItems.requestRainInfoText()
                let weatherData = weatherItems.requestWeatherDataSet(weatherSet)
                
                spotWeatherInfoView.reloadWeatherData(weatherAPIIsSuccess: true, weatherInfoTuple: weatherData)
                spotWeatherInfoView.setCurrentTemperatureLabelValue(temperatureStr: weatherData[0].temp)
                spotWeatherInfoView.setRainInfoLabelTextAndColor(text: rainData)
            } catch {
                spotWeatherInfoView.reloadWeatherData(weatherAPIIsSuccess: false, weatherInfoTuple: [])
                
                if let weatherManagerError = error as? WeatherManagerError {
                    switch weatherManagerError {
                    case .networkError(let message):
                        print(message)
                    case .apiError(let message):
                        print(message)
                    }
                } else if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print(context.codingPath, context.debugDescription, context.underlyingError ?? "", separator: "\n")
                    default:
                        print(decodingError.localizedDescription)
                    }
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func configureDelegate() {
        liveCameraView.delegate = self
        liveCameraView.videoPlayerControlView.screenSizeControlButton.delegate = self
    }
    
    private func configureNotification() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(toBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(toForeground),name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func toBackground() {
        firstAttempt = false
        liveMarkView.liveMarkActive(to: false)
        liveCameraView.stanbyView.stopLoadingAnimation()
    }
    
    @objc private func toForeground() {
        if !firstAttempt {
            liveCameraView.playVideo()
            liveCameraView.changeReloadButtonActiveStatus(as: false)
            liveCameraView.stanbyView.reloadStandbyView()
            
        }
    }
    
    private func setUpLiveCameraViewConstraints(screenStatus: ScreenSizeStatus) {
        
        let safeArea = view.safeAreaLayoutGuide
        liveCameraView.snp.removeConstraints()
        liveMarkView.snp.removeConstraints()
        
        switch screenStatus {
        case .normal:
            let liveCameraViewHeight = screenWidth * 9 / 16
            
            liveCameraView.snp.makeConstraints({ make in
                make.centerX.equalTo(safeArea.snp.centerX)
                make.top.equalTo(safeArea.snp.top)
                make.width.equalTo(safeArea.snp.width)
                make.height.equalTo(liveCameraViewHeight)
            })
            
            liveMarkView.snp.makeConstraints({ make in
                make.leading.equalTo(liveCameraView.snp.leading).offset(8)
                make.top.equalTo(liveCameraView.snp.top).offset(8)
                make.width.equalTo(screenWidth / 8)
                make.height.equalTo(screenWidth / 18)
            })
        case .full:
            
            let liveCameraviewHeight = UIScreen.main.bounds.width
            let liveCameraViewWidth = liveCameraviewHeight * 16 / 9

            liveCameraView.snp.makeConstraints({ make in
                make.top.equalTo(view.snp.top)
                make.bottom.equalTo(view.snp.bottom)
                make.centerX.equalTo(safeArea.snp.centerX)
                make.width.equalTo(liveCameraViewWidth)
            })
            
            liveMarkView.snp.makeConstraints({ make in
                make.leading.equalTo(liveCameraView.snp.leading).offset(16)
                make.top.equalTo(liveCameraView.snp.top).offset(16)
                make.width.equalTo(screenWidth / 8)
                make.height.equalTo(screenWidth / 18)
            })
        }
    }
}

extension BbajiSpotViewController: SpotLiveCameraViewDelegate {
    func videoIsReadyToPlay() {
        liveMarkView.liveMarkActive(to: true)
    }
}

extension BbajiSpotViewController: ScreenSizeControlButtonDelegate
{
    func changeScreenSize(screenSizeStatus: ScreenSizeStatus) {
        var infoViewAlphaValue: CGFloat = 1.0
        var backgroundColor: UIColor = .bbagaBack
        var orientationValue: String = "portrait"
        var navigationBarHiddenStatus: Bool = false
        switch screenSizeStatus {
        case .normal:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = .portrait
            }
        case .full:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = .landscapeRight
            }

            infoViewAlphaValue = 0.0
            orientationValue = "landscapeRight"
            backgroundColor = .black
            navigationBarHiddenStatus = true
        }
        
        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIDevice.current.setValue(orientationValue, forKey: "orientation")
        }
        
        navigationController?.setNavigationBarHidden(navigationBarHiddenStatus, animated: true)
        setUpLiveCameraViewConstraints(screenStatus: screenSizeStatus)
        UIView.animate(withDuration: 0.3, delay: TimeInterval(0.0), animations: { [self] in
            infoScrollView.alpha = infoViewAlphaValue
            view.backgroundColor = backgroundColor
            view.layoutIfNeeded()
        })
    }
}
