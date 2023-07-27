//
//  StubWeather.swift
//  BJGGTests
//
//  Created by Jaewoong Lee on 2023/07/27.
//

import Foundation

struct StubWeather: ComputableWeather {
    var date: Int
    var time: Int
    var temperature: Double
    var skyCondition: SkyCondition
    var precipitationPercentage: Double
    var precipitationType: PrecipitationType
}

extension StubWeather {
    static func makePrecipitationTypeStub(type: PrecipitationType) -> ComputableWeather {
        return StubWeather(
            date: 0,
            time: 0,
            temperature: 0,
            skyCondition: .cloudy,
            precipitationPercentage: 0,
            precipitationType: type
        )
    }
}
