//
//  ComputableWeather.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/07/24.
//

import Foundation

/// date는 yyyyMMdd, time은 HH 형태를 준수하는 날씨 예보 계산이 가능한 날씨 프로토콜
protocol ComputableWeather {
    var date: Int { get }
    var time: Int { get }
    var temperature: Double { get }
    var skyCondition: SkyCondition { get }
    var precipitationPercentage: Double { get }
    var precipitationType: PrecipitationType { get }
}

/// 하늘상태. 강수형태와 연관있지 않음.
enum SkyCondition {
    case sunny
    case cloudy
    case fade
}

/// 강수형태. none의 경우 어떠한 강수가 없는 것을 의미함.
enum PrecipitationType {
    case none
    case rainy
    case sleet
    case snowy
}
