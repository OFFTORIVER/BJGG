//
//  StubWeather.swift
//  BJGGTests
//
//  Created by Jaewoong Lee on 2023/07/31.
//

import Foundation
@testable import BJGG

struct StubWeather: ComputableWeather {
    var date: Int
    var time: Int
    var temperature: Double
    var skyCondition: SkyCondition
    var precipitationPercentage: Double
    var precipitationType: PrecipitationType
}

extension StubWeather {
    static func makePrecipitationTypeStub(precipitationType: PrecipitationType) -> StubWeather {
        StubWeather(
            date: 0,
            time: 0,
            temperature: 0.0,
            skyCondition: .sunny,
            precipitationPercentage: 0.0,
            precipitationType: precipitationType
        )
    }
}


