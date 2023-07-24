//
//  ComputableWeather.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/07/24.
//

import Foundation

protocol ComputableWeather {
    var date: Int { get }
    var time: Int { get }
    var temperature: Double { get }
    var skyCondition: SkyCondition { get }
    var precipitationPercentage: Double { get }
    var precipitationType: PrecipitationType { get }
}

enum SkyCondition {
    case sunny
    case cloudy
    case fade
}

enum PrecipitationType {
    case rainy
    case sleet
    case snowy
}
