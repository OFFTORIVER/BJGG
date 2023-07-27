//
//  ForecastManager.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/07/24.
//

import Foundation

protocol Forecastable {
    func makeWeatherForecast(weathers: [ComputableWeather]) throws
    func isRaining(weather: ComputableWeather) -> Bool
}

enum ForecastableError: Error {
    case emptyData
}

class ForecastManager: Forecastable {
    func makeWeatherForecast(weathers: [ComputableWeather]) throws { }
    
    func isRaining(weather: ComputableWeather) -> Bool {
        switch weather.precipitationType {
        case .none:
            return true
        default:
            return false
        }
    }
}
