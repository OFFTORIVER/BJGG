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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayoutWithAPI()
    }
    
    private func layoutConfigure() {
        
        let safeArea = view.safeAreaLayoutGuide
        let viewWidth = UIScreen.main.bounds.width
        let defaultMargin = BbajiConstraints.superViewInset
        let viewToViewMargin = BbajiConstraints.componentOffset
        
        view.addSubview(liveCameraView)
        
        liveCameraView.snp.makeConstraints({ make in
            make.top.equalTo(safeArea.snp.top)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.height.equalTo(viewWidth * 9 / 16)
        })
        
        liveCameraView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth * 9 / 16)

        self.addChild(liveCameraView.avpController)
        
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

        view.backgroundColor = .bbagaBack
        spotInfoView.backgroundColor = .bbagaGray4
        spotWeatherInfoView.backgroundColor = .bbagaGray4
        
    }
    
    private func configureLayoutWithAPI() {

        spotWeatherInfoView = SpotWeatherInfoView()
        layoutConfigure()
        liveCameraView.liveCameraSetting(size: liveCameraView.frame.size)
        
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
}
