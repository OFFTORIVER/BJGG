//
//  ForecastManager.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/07/24.
//

import Foundation

protocol Forecastable {
    func makeWeatherForecast()
}

class ForecastManager: Forecastable {
    func makeWeatherForecast() { }
}
