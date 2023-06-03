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
    private var weatherManager: WeatherManager
    
    init(weatherManager: WeatherManager = WeatherManager()) {
        self.weatherManager = weatherManager
    }
    
    func viewDidLoad() {
        fetchWeatherNows()
    }
    
    func fetchWeatherNows() {
        bbajiInfo.sink { [weak self] info in
            guard let self = self else { return }
            let bbajiCoord = info.getCoordinate()
            
            Task { [weak self] in
                guard let self = self else { return }
                
                do {
                    let weatherItems = try await self.weatherManager.requestCurrentTimeWeather(nx: bbajiCoord.x, ny: bbajiCoord.y).response.body.items
                    let weatherItemArray = weatherItems.requestCurrentWeatherItem()
                    guard let weatherData = weatherItems.requestWeatherDataSet(weatherItemArray).first else {
                        print("[BbajiHomeViewModel] 날씨 데이터 오류")
                        return
                    }
                    
                    let weatherNow = BbajiWeatherNow(
                        locationName: info.getCompactAddress(),
                        name: info.getName(),
                        backgroundImageName: info.getThumbnailImgName(),
                        iconName: weatherData.iconName,
                        temp: weatherData.temp)
                    
                    self.weatherNows = [weatherNow]
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
        .store(in: &cancellable)
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
