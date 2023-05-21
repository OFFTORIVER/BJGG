//
//  SpotViewModel.swift
//  BJGG
//
//  Created by 황정현 on 2023/04/04.
//

import Combine
import UIKit

protocol OutputOnlyViewModelType {
    associatedtype Output
    
    func transform() async -> Output?
}

final class SpotViewModel {
    @Published private(set) var weatherData: [WeatherData]?
    @Published private(set) var rainData: String?
    @Published private(set) var screenSizeStatus: ScreenSizeStatus = .origin
    
    private var controlStatus: CurrentValueSubject<ControlStatus, Never> = CurrentValueSubject(.hidden)
    var playStatus: CurrentValueSubject<PlayStatus, Never> = CurrentValueSubject(.origin)
    
    let weatherManager: WeatherManager
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let cameraViewTapGesture: AnyPublisher<UITapGestureRecognizer, Never>?
        let screenSizeButtonTapPublisher: AnyPublisher<Void, Never>?
    }
    
    struct Output {
        var controlStatus: CurrentValueSubject<ControlStatus, Never>
    }
    
    init() {
        weatherManager = WeatherManager()
        receiveBbajiWeatherData()
    }
    
    func receiveBbajiWeatherData() {
        Task {
            do {
                let weatherItems = try await self.weatherManager.request24HWeather(nx: 61, ny: 126).response.body.items
                let weatherSet = weatherItems.request24HourWeatherItem()
                let rawWeatherData = weatherItems.requestWeatherDataSet(weatherSet)
                let weatherData = rawWeatherData.map({
                    (rawData) -> WeatherData in
                    return WeatherData(time: rawData.time, iconName: rawData.iconName, temp: rawData.temp, probability: rawData.probability)
                })
                
                let rainData = weatherItems.requestRainInfoText()
                
                self.weatherData = weatherData
                self.rainData = rainData
            } catch {
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
    
    func changeScreenSizeStatus() {
        if screenSizeStatus == .normal || screenSizeStatus == .origin {
            screenSizeStatus = .full
        } else {
            screenSizeStatus = .normal
        }
    }
    
    func changeControlStatus() {
        if controlStatus.value == .hidden {
            controlStatus.send(.exist)
        } else {
            controlStatus.send(.hidden)
        }
    }
    
    func changePlayStatus(as status: PlayStatus) {
        changeControlStatus()
        playStatus.send(status)
    }
    
    func transform(input: Input) -> Output {
        input.cameraViewTapGesture?.sink {[weak self] _ in
            self?.changeControlStatus()
        }.store(in: &cancellables)
        input.screenSizeButtonTapPublisher?.sink { [weak self] _ in
            self?.changeScreenSizeStatus()
        }.store(in: &cancellables)
        
        return Output(controlStatus: controlStatus)
    }
    
    func callBbaji(to phoneNumberStr: String) {
        let phoneNumber:Int = Int(phoneNumberStr.components(separatedBy: ["-"]).joined()) ?? 01000000000
        if let url = NSURL(string: "tel://0" + "\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
