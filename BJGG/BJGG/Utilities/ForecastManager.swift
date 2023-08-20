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
    func willPrecipitationChangeIn24hours(weathers: [ComputableWeather]) throws -> ComputableWeather?
    func checkDaysAreEqual(leftDay: Int, rightDay: Int) -> EqualDaysResult
}

enum EqualDaysResult {
    case equalDays
    case rightIsLate
    case leftIsLate
}

enum ForecastableError: Error {
    case emptyData
    case singleWeather
}

class ForecastManager: Forecastable {
    func makeWeatherForecast(weathers: [ComputableWeather]) throws { }
    
    func isRaining(weather: ComputableWeather) -> Bool {
        switch weather.precipitationType {
        case .none:
            return false
        default:
            return true
        }
    }
    
    
    /// 현재날씨(첫번째 인덱스의 날씨)를 기준으로,  기준 날씨와 다른 강수상태를 가지는 날씨가 있을 경우 리턴하는 메소드. 현재날씨의 강수상태와 다른 날씨가 없을 경우, nil을 리턴함.
    func willPrecipitationChangeIn24hours(weathers: [ComputableWeather]) throws -> ComputableWeather? {
        guard let currentWeather = weathers.first else { throw ForecastableError.emptyData }
        guard weathers.count > 1 else { throw ForecastableError.singleWeather }
            
        for i in 1..<weathers.count {
            let comingWeather = weathers[i]
            
            if isRaining(weather: currentWeather) {
                if comingWeather.precipitationType == .none {
                    return comingWeather
                }
            } else {
                if comingWeather.precipitationType != .none {
                    return comingWeather
                }
            }
        }
        
        return nil
    }
    
    func checkDaysAreEqual(leftDay: Int, rightDay: Int) -> EqualDaysResult {
        if leftDay < rightDay {
            return .rightIsLate
        }
        
        if leftDay > rightDay {
            return .leftIsLate
        }
        
        return .equalDays
    }
}
