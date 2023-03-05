//
//  SpotViewController.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit
import SnapKit

final class BbajiSpotViewController: UIViewController {
    private let liveCameraView = SpotLiveCameraView()
    private let infoScrollView = UIScrollView()
    private let infoScrollContentView = UIView()
    private var spotInfoView = SpotInfoView()
    private var spotWeatherInfoView: SpotWeatherInfoView!
    
    private var liveMarkLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var liveMarkTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var videoPlayerWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var videoPlayerHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var liveMarkView: LiveMarkView = LiveMarkView()
    
    private var screenWidth: CGFloat = CGFloat()
    private var firstAttempt: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayoutWithAPI()
        delegateConfigure()
        notificationConfigure()
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
            print("HERE")
            return true
        case .normal:
            return false
        }
    }
    
    private func layoutConfigure() {
        
        let safeArea = view.safeAreaLayoutGuide
        let viewWidth = UIScreen.main.bounds.width
        screenWidth = viewWidth
        let defaultMargin = CGFloat.superViewInset
        let viewToViewMargin = CGFloat.componentOffset
        
        view.addSubview(liveCameraView)
        
        let liveCameraViewHeight = screenWidth * 9 / 16
        
        videoPlayerWidthConstraint = liveCameraView.widthAnchor.constraint(equalToConstant: screenWidth)
        videoPlayerHeightConstraint = liveCameraView.heightAnchor.constraint(equalToConstant: liveCameraViewHeight)
        
        view.addSubview(liveCameraView)
        liveCameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liveCameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            liveCameraView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            videoPlayerWidthConstraint,
            videoPlayerHeightConstraint
        ])

        liveMarkLeadingConstraint = liveMarkView.leadingAnchor.constraint(equalTo: liveCameraView.leadingAnchor, constant: 8)
        liveMarkTopConstraint = liveMarkView.topAnchor.constraint(equalTo: liveCameraView.topAnchor, constant: 8)
        
        view.addSubview(liveMarkView)
        liveMarkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liveMarkLeadingConstraint,
            liveMarkTopConstraint,
            liveMarkView.widthAnchor.constraint(equalToConstant: screenWidth / 8),
            liveMarkView.heightAnchor.constraint(equalToConstant: screenWidth / 18)
        ])
        
        liveMarkView.setUpLiveLabelRadius(to: screenWidth / 36)
        liveMarkView.liveMarkColorActive(to: false)
        
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
//            make.height.equalTo(UIDevice.current.hasNotch ? 508 : 508 - 32)
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

        view.backgroundColor = .bbagaBack
        spotInfoView.backgroundColor = .bbagaGray4
        spotWeatherInfoView.backgroundColor = .bbagaGray4
        
    }
    
    private func configureLayoutWithAPI() {

        spotWeatherInfoView = SpotWeatherInfoView()
        layoutConfigure()
        
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
                    case .urlError:
                        print("WeaherManager Error : URL 변환 실패")
                    case .clientError:
                        print("WeaherManager Error : 기상청 API 요청 실패")
                    case .apiError:
                        print("WeaherManager Error : 네트워크 응답 실패")
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
        
        //[Deprecated] completionHandler를 사용한 WeatherManger 사용
//        weatherManager.request24hData(nx: 61, ny: 126) { success, response in
//            guard let response = response as? WeatherResponse else {
//                print("Error: API 호출 실패")
//                return
//            }
//
//            let data = response.body.items.request24HourWeatherItem()
//            let rainData = response.body.items.requestRainInfoText()
//            let weatherDataTuple = response.body.items.requestWeatherDataSet(data)
//
//            DispatchQueue.main.async { [self] in
//                spotWeatherInfoView.reloadWeatherData(weatherAPIIsSuccess: success, weatherInfoTuple: weatherDataTuple)
//                spotWeatherInfoView.setCurrentTemperatureLabelValue(temperatureStr: weatherDataTuple[0].temp)
//                spotWeatherInfoView.setRainInfoLabelTextAndColor(text: rainData)
//            }
//        }
    }
    
    func delegateConfigure() {
        liveCameraView.delegate = self
        liveCameraView.videoPlayerControlView.screenSizeControlButton.delegate = self
    }
    
    func notificationConfigure() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(toBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(toForeground),name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func toBackground() {
        firstAttempt = false
        liveMarkView.liveMarkColorActive(to: false)
    }
    
    @objc private func toForeground() {
        if !firstAttempt {
            liveCameraView.playVideo()
        }
    }
    
}

extension BbajiSpotViewController: SpotLiveCameraViewDelegate {
    func videoIsReadyToPlay() {
        liveMarkView.liveMarkColorActive(to: true)
    }
}

extension BbajiSpotViewController: ScreenSizeControlButtonDelegate
{
    func changeScreenSize(screenSizeStatus: ScreenSizeStatus) {
        var infoViewAlphaValue: CGFloat = 0.0
        var backgroundColor: UIColor = .bbagaBack
        switch screenSizeStatus {
        case .normal:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = .portrait
            }
            
            if #available(iOS 16.0, *) {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                UIDevice.current.setValue("landscapeRight", forKey: "orientation")
            }
            
            let liveCameraViewHeight = screenWidth * 9 / 16
            
            videoPlayerWidthConstraint.constant = screenWidth
            videoPlayerHeightConstraint.constant = liveCameraViewHeight
            
            liveCameraView.videoPlayerControlView.screenSizeControlButtonTrailingConstraint.constant = -4
            liveCameraView.videoPlayerControlView.screenSizeControlButtonBottomConstraint.constant = -4
            liveMarkLeadingConstraint.constant = 8
            liveMarkTopConstraint.constant = 8
            infoViewAlphaValue = 1.0
            
            navigationController?.setNavigationBarHidden(false, animated: true)
            
        case .full:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = .landscapeRight
            }
            if #available(iOS 16.0, *) {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                UIDevice.current.setValue("landscapeRight", forKey: "orientation")
            }
            
            let liveCameraViewHeight = UIScreen.main.bounds.width
            let liveCameraViewWidth = liveCameraViewHeight * 16 / 9
            
            videoPlayerWidthConstraint.constant = liveCameraViewWidth
            videoPlayerHeightConstraint.constant = liveCameraViewHeight
            liveMarkLeadingConstraint.constant = 16
            liveMarkTopConstraint.constant = 16
            liveCameraView.videoPlayerControlView.screenSizeControlButtonTrailingConstraint.constant = -16
            liveCameraView.videoPlayerControlView.screenSizeControlButtonBottomConstraint
                .constant = -16
            NSLayoutConstraint.activate([
                liveCameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
            infoViewAlphaValue = 0.0
            backgroundColor = .black
            
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        UIView.animate(withDuration: 0.3, delay: TimeInterval(0.0), animations: { [self] in
            infoScrollView.alpha = infoViewAlphaValue
            view.backgroundColor = backgroundColor
            view.layoutIfNeeded()
        })
    }
}
