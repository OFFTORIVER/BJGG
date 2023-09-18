//
//  ForecastManager.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/07/24.
//

import Foundation

protocol Forecastable {
    func makeWeatherForecast(weathers: [ComputableWeather]) throws -> ForecastResult
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

struct ForecastResult {
    let type: ForecastResultType
    let expectedTime: Int?
}

enum ForecastResultType {
    case cleanToday
    case notRainyToday
    case rainyToday
    case sleetToday
    case snowyToday
    case cleanTomorrow
    case notRainyTomorrow
    case rainyTomorrow
    case sleetTomorrow
    case snowyTomorrow
    case willBeCleanToday
    case willBeRainyToday
    case willBeSleetToday
    case willBeSnowyToday
    case willBeCleanTomorrow
    case willBeRainyTomorrow
    case willBeSleetTomorrow
    case willBeSnowyTomorrow
}

class ForecastManager: Forecastable {
    /// yyyyMMdd 형태의 date 변수, HH 형태의 time 변수에 의해 정렬되어 있는 weathers를 파라미터에 대입할 때, 예보 예상 결과를 나타내는 ForecastResult를 리턴하는 날씨 예보 알고리즘 메소드
    func makeWeatherForecast(weathers: [ComputableWeather]) throws -> ForecastResult {
        guard let currentWeather = weathers.first else { throw ForecastableError.emptyData }
        guard weathers.count > 1 else { throw ForecastableError.singleWeather }
        
        let expectedWeather = try? willPrecipitationChangeIn24hours(weathers: weathers)
        
        let resultType: ForecastResultType
        
        // 현재 날씨가 그대로 유지될 경우
        guard let expectedWeather else {
            switch currentWeather.precipitationType {
            case .none:
                if currentWeather.skyCondition == .sunny {
                    resultType = isLeft3HoursOverToday(time: currentWeather.time) ? .cleanToday : .cleanTomorrow
                } else {
                    resultType = isLeft3HoursOverToday(time: currentWeather.time) ? .notRainyToday : .notRainyTomorrow
                }
            case .rainy:
                resultType = isLeft3HoursOverToday(time: currentWeather.time) ?  .rainyToday : .rainyTomorrow
            case .sleet:
                resultType = isLeft3HoursOverToday(time: currentWeather.time) ?  .sleetToday : .sleetTomorrow
            case .snowy:
                resultType = isLeft3HoursOverToday(time: currentWeather.time) ?  .snowyToday : .snowyTomorrow
            }
            
            return ForecastResult(
                type: resultType,
                expectedTime: nil
            )
        }
        
        // 현재 날씨에서 변경될 경우
        switch expectedWeather.precipitationType {
        case .none:
            resultType = checkDaysAreEqual(leftDay: currentWeather.date, rightDay: expectedWeather.date) == .equalDays ? .willBeCleanToday : .willBeCleanTomorrow
        case .rainy:
            resultType = checkDaysAreEqual(leftDay: currentWeather.date, rightDay: expectedWeather.date) == .equalDays ? .willBeRainyToday : .willBeRainyTomorrow
        case .sleet:
            resultType = checkDaysAreEqual(leftDay: currentWeather.date, rightDay: expectedWeather.date) == .equalDays ? .willBeSleetToday : .willBeSleetTomorrow
        case .snowy:
            resultType = checkDaysAreEqual(leftDay: currentWeather.date, rightDay: expectedWeather.date) == .equalDays ? .willBeSnowyToday : .willBeSnowyTomorrow
        }
        
        return ForecastResult(
            type: resultType,
            expectedTime: expectedWeather.time
        )
    }
    
    /// weather 파라미터가 강수상태인지 아닌지 Bool 타입을 리턴해 알려주는 메소드
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
    
    /// leftDay와 rightDay가 같은 일자인지 또는 어느 날이 늦은 날인지 알려주는 메소드.
    func checkDaysAreEqual(leftDay: Int, rightDay: Int) -> EqualDaysResult {
        if leftDay < rightDay {
            return .rightIsLate
        }
        
        if leftDay > rightDay {
            return .leftIsLate
        }
        
        return .equalDays
    }
    
    private func isLeft3HoursOverToday(time: Int) -> Bool {
        return time < 21
    }
}
