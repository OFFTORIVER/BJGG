//
//  BbajiHomeViewModel.swift
//  BJGG
//
//  Created by 이재웅 on 2023/04/11.
//

import Combine

final class BbajiHomeViewModel: ObservableObject {
    @Published private(set)var weatherNows: [BbajiWeatherNow] = []
    
    private var bbajiInfo = CurrentValueSubject<BbajiInfo, Never>(BbajiInfo())
    private var cancellable = Set<AnyCancellable>()
    private var weatherManager: WeatherManager!
    
    init(weatherManager: WeatherManager = WeatherManager()) {
        self.weatherManager = weatherManager
    }
    
    func viewDidLoad() {
        bbajiInfo.sink { [weak self] info in
            guard let self = self else { return }
            
            self.fetchWeatherItems(weatherManager: self.weatherManager, bbajiInfo: info)
        }
        .store(in: &cancellable)
    }
    
    private func fetchWeatherItems(weatherManager: WeatherManager, bbajiInfo: BbajiInfo) {
        let bbajiCoord = bbajiInfo.getCoordinate()
        
        Task {
            let weatherItems = try await weatherManager.requestCurrentTimeWeather(nx: bbajiCoord.x, ny: bbajiCoord.y).response.body.items
            let weatherItemArray = weatherItems.requestCurrentWeatherItem()
            guard let weatherData = weatherItems.requestWeatherDataSet(weatherItemArray).first else {
                print("[BbajiHomeViewModel] 날씨 데이터 오류")
                return
            }
            
            let weatherNow = BbajiWeatherNow(
                locationName: bbajiInfo.getCompactAddress(),
                name: bbajiInfo.getName(),
                backgroundImageName: bbajiInfo.getThumbnailImgName(),
                iconName: weatherData.iconName,
                temp: weatherData.temp)
            
            weatherNows.append(weatherNow)
        }
    }
}

extension BbajiHomeViewModel {
    struct BbajiWeatherNow {
        let locationName: String
        let name: String
        let backgroundImageName: String
        let iconName: String
        let temp: String
    }
}
