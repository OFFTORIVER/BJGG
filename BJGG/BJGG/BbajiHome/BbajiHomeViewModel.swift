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
    
    private var cancellable = Set<AnyCancellable>()
    
    init(weatherManager: WeatherManager = WeatherManager()) {
        Task {
            let weatherItems = try await fetchWeatherItems(weatherManager: weatherManager)
            let weatherItemArray = weatherItems.requestCurrentWeatherItem()
            let homeWeatherArray = weatherItems.requestWeatherDataSet(weatherItemArray)
            listWeather = convertToListWeatherArray(from: homeWeatherArray)
        }
        
        info = convertToListInfoArray(from: [BbajiInfo()])
    }
    
    private func fetchWeatherItems(weatherManager: WeatherManager) async throws -> WeatherItems {
        let bbajiInfo = BbajiInfo()
        let bbajiCoord = bbajiInfo.getCoordinate()
        let weatherItems = try await weatherManager.requestCurrentTimeWeather(nx: bbajiCoord.x, ny: bbajiCoord.y).response.body.items
        return weatherItems
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
