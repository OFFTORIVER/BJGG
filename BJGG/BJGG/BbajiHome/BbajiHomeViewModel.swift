//
//  BbajiHomeViewModel.swift
//  BJGG
//
//  Created by 이재웅 on 2023/04/11.
//

import Combine

final class BbajiHomeViewModel: ObservableObject {
    @Published private(set)var listWeather: [BbajiListWeather] = []
    @Published private(set)var info: [BbajiListInfo] = []
    @Published private(set)var weatherNows: [BbajiWeatherNow] = []
    
    var fetchWeatherCompleted = PassthroughSubject<Bool, Never>()
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
            let homeWeatherArray = weatherItems.requestWeatherDataSet(weatherItemArray)
            listWeather = convertToListWeatherArray(from: homeWeatherArray)
            info = convertToListInfoArray(from: [BbajiInfo()])
            
            let weatherNow = BbajiWeatherNow(locationName: info[0].locationName, name: info[0].name, backgroundImageName: info[0].backgroundImageName, iconName: listWeather[0].iconName, temp: listWeather[0].temp)
            weatherNows.append(weatherNow)
            fetchWeatherCompleted.send(true)
        }
    }
    
    private func convertToListWeatherArray(from homeWeatherArray: [BbajiHomeWeather]) -> [BbajiListWeather] {
        var listWeatherArray: [BbajiListWeather] = []
        for homeWeather in homeWeatherArray {
            let listWeather = BbajiListWeather(homeWeather.iconName, homeWeather.temp)
            listWeatherArray.append(listWeather)
        }
        
        return listWeatherArray
    }
    
    private func convertToListInfoArray(from bbajiInfoArray: [BbajiInfo]) -> [BbajiListInfo] {
        var listInfoArray: [BbajiListInfo] = []
        for info in bbajiInfoArray {
            let listInfo = (info.getAddress(), info.getName(), info.getThumbnailImgName())
            listInfoArray.append(listInfo)
        }
        
        return listInfoArray
    }
}

extension BbajiHomeViewModel {
    struct BbajiWeatherNow: Hashable {
        let locationName: String
        let name: String
        let backgroundImageName: String
        let iconName: String
        let temp: String
    }
}
