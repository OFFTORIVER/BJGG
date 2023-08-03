//
//  ForecastManagerTests.swift
//  BJGGTests
//
//  Created by Jaewoong Lee on 2023/07/27.
//

import XCTest
@testable import BJGG

final class ForecastManagerTests: XCTestCase {
    private var sut: Forecastable!

    override func setUpWithError() throws {
        sut = ForecastManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_isRaining_when_precipitationTypeIsNone() throws {
        //given
        let noneTypeWeather = StubWeather.makePrecipitationTypeStub(precipitationType: .none)
        
        //when
        let expectation = sut.isRaining(weather: noneTypeWeather)
        
        //then
        XCTAssertFalse(expectation)
    }
    
    func test_isRaining_when_precipitationTypeIsNotNone() throws {
        //given
        let rainyTypeWeather = StubWeather.makePrecipitationTypeStub(precipitationType: .rainy)
        let snowyTypeWeather = StubWeather.makePrecipitationTypeStub(precipitationType: .snowy)
        let sleetTypeWeather = StubWeather.makePrecipitationTypeStub(precipitationType: .sleet)
        
        //when
        let rainyExpectation = sut.isRaining(weather: rainyTypeWeather)
        let snowyExpectation = sut.isRaining(weather: snowyTypeWeather)
        let sleetExpectation = sut.isRaining(weather: sleetTypeWeather)
        
        //then
        XCTAssertTrue(rainyExpectation)
        XCTAssertTrue(snowyExpectation)
        XCTAssertTrue(sleetExpectation)
    }
}
