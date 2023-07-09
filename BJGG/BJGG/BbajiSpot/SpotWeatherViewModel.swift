//
//  SpotDataViewModel.swift
//  BJGG
//
//  Created by 황정현 on 2023/06/24.
//

import Foundation

// MARK: WEATHER DATA VIEW MODEL
final class SpotWeatherViewModel {
    @Published private(set) var weatherData: [WeatherData]?
    @Published private(set) var rainData: String?
    
    let weatherManager: WeatherManager
    
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
}
