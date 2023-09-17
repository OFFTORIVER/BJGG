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

    func test_isRaining_when_precipitationTypeIsNone() {
        //given
        let noneTypeWeather = StubWeather.makePrecipitationTypeStub(precipitationType: .none)
        
        //when
        let expectation = sut.isRaining(weather: noneTypeWeather)
        
        //then
        XCTAssertFalse(expectation)
    }
    
    func test_isRaining_when_precipitationTypeIsNotNone() {
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
    
    func test_willPrecipitationChangeIn24hours_when_emptyWeathers() throws {
        //given
        let emptyWeathers: [ComputableWeather] = []
        var emptyError: Error?
        
        //when
        XCTAssertThrowsError(try sut.willPrecipitationChangeIn24hours(weathers: emptyWeathers)) {
            emptyError = $0
        }
        
        //then
        XCTAssertTrue(emptyError is ForecastableError)
        XCTAssertEqual(emptyError as? ForecastableError, .emptyData)
    }
    
    func test_willPrecipitationChangeIn24hours_when_singleWeather() throws {
        //given
        let singleWeather: [ComputableWeather] = [StubWeather.makePrecipitationTypeStub(precipitationType: .none)]
        var singleError: Error?
        
        //when
        XCTAssertThrowsError(try sut.willPrecipitationChangeIn24hours(weathers: singleWeather)) {
            singleError = $0
        }
        
        //then
        XCTAssertTrue(singleError is ForecastableError)
        XCTAssertEqual(singleError as? ForecastableError, .singleWeather)
    }
    
    func test_willPrecipitationChangeIn24hours_when_weatherNoChange() throws {
        //given
        var noneWeathers: [ComputableWeather] = []
        var somePrecipitationWeathers: [ComputableWeather] = []
        
        let somePrecipitations: [PrecipitationType] = [.rainy, .sleet, .snowy]
        
        for i in 0...24 {
            noneWeathers.append(StubWeather.makePrecipitationTypeStub(precipitationType: .none))
            somePrecipitationWeathers.append(StubWeather.makePrecipitationTypeStub(precipitationType: somePrecipitations[i % 3]))
        }
        
        //when
        let noneExpectation = try sut.willPrecipitationChangeIn24hours(weathers: noneWeathers)
        let somePrecipitationsExpectation = try sut.willPrecipitationChangeIn24hours(weathers: somePrecipitationWeathers)
        
        //then
        XCTAssertNil(noneExpectation)
        XCTAssertNil(somePrecipitationsExpectation)
    }
    
    func test_willPrecipitationChangeIn24hours_when_fromSunnyToAnother() throws {
        //given
        let date = 20230820
        let times = [Int](0...24)
        let rainingTime = 12
        let sleetTime = 18
        let snowyTime = 9
        var rainWeathers: [ComputableWeather] = []
        var sleetWeathers: [ComputableWeather] = []
        var snowyWeathers: [ComputableWeather] = []
        
        for time in times {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: time,
                precipitationType: time >= rainingTime ? .rainy : .none
            )
            
            rainWeathers.append(weather)
        }
        
        for time in times {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: time,
                precipitationType: time >= sleetTime ? .sleet : .none
            )
            
            sleetWeathers.append(weather)
        }
        
        for time in times {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: time,
                precipitationType: time >= snowyTime ? .snowy : .none
            )
            
            snowyWeathers.append(weather)
        }
        
        //when
        let rainyExpectation = try sut.willPrecipitationChangeIn24hours(weathers: rainWeathers)
        let sleetExpectation = try sut.willPrecipitationChangeIn24hours(weathers: sleetWeathers)
        let snowyExpectation = try sut.willPrecipitationChangeIn24hours(weathers: snowyWeathers)
        
        //then
        XCTAssertNotNil(rainyExpectation)
        XCTAssertNotNil(sleetExpectation)
        XCTAssertNotNil(snowyExpectation)
        
        XCTAssertEqual(rainyExpectation?.time, rainingTime)
        XCTAssertEqual(rainyExpectation?.precipitationType, .rainy)
        
        XCTAssertEqual(sleetExpectation?.time, sleetTime)
        XCTAssertEqual(sleetExpectation?.precipitationType, .sleet)
        
        XCTAssertEqual(snowyExpectation?.time, snowyTime)
        XCTAssertEqual(snowyExpectation?.precipitationType, .snowy)
    }
    
    
    func test_checkDaysAreEqual_when_sameDays() {
        //given
        let leftDay = 20230820
        let rightDay = leftDay
        
        //when
        let expectation = sut.checkDaysAreEqual(leftDay: leftDay, rightDay: rightDay)
        
        //then
        XCTAssertEqual(expectation, .equalDays)
    }
    
    func test_checkDaysAreEqual_when_leftDayIsLate() {
        //given
        let leftDay = 20230820
        let rightDay = leftDay - 1
        
        //when
        let expectation = sut.checkDaysAreEqual(leftDay: leftDay, rightDay: rightDay)
        
        //then
        XCTAssertEqual(expectation, .leftIsLate)
    }
    
    func test_checkDaysAreEqual_when_rightDayIsLate() {
        //given
        let leftDay = 20230820
        let rightDay = leftDay + 1
        
        //when
        let expectation = sut.checkDaysAreEqual(leftDay: leftDay, rightDay: rightDay)
        
        //then
        XCTAssertEqual(expectation, .rightIsLate)
    }
    
    func test_makeWeatherForecast_when_emptyWeather() throws {
        //given
        let emptyWeather: [ComputableWeather] = []
        var emptyError: Error?
        
        //when
        XCTAssertThrowsError(try sut.makeWeatherForecast(weathers: emptyWeather)) {
            emptyError = $0
        }
        
        //then
        XCTAssertTrue(emptyError is ForecastableError)
        XCTAssertEqual(emptyError as? ForecastableError, .emptyData)
    }
    
    func test_makeWeatherForecast_when_singleWeather() throws {
        //given
        let weather = StubWeather.makePrecipitationTypeStub(precipitationType: .none)
        let singleWeather: [ComputableWeather] = [weather]
        var singleError: Error?
        
        //when
        XCTAssertThrowsError(try sut.makeWeatherForecast(weathers: singleWeather)) {
            singleError = $0
        }
        
        //then
        XCTAssertTrue(singleError is ForecastableError)
        XCTAssertEqual(singleError as? ForecastableError, .singleWeather)
    }
    
    func test_makeWeatherForecast_when_todayIsSunny() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 0...24 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .sunny,
                precipitationType: .none)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .cleanToday)
    }
    
    func test_makeWeatherForecast_when_tomorrowIsSunny() throws {
        //given
        var weathers: [ComputableWeather] = []
        let today = 20230820
        let tomorrow = today + 1
        
        
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: today,
                time: i,
                skyCondition: .sunny,
                precipitationType: .none)
            
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: tomorrow,
                time: i,
                skyCondition: .sunny,
                precipitationType: .none)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .cleanTomorrow)
    }
    
    func test_makeWeatherForecast_when_todayIsNotRainy() throws {
        //given
        var cloudyWeathers: [ComputableWeather] = []
        var fadeWeathers: [ComputableWeather] = []
        let today = 20230820
        
        for i in 0...23 {
            let cloudyWeather = StubWeather.makePrecipitationTypeStub(
                date: today,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .none
            )
            let fadeWeather = StubWeather.makePrecipitationTypeStub(
                date: today,
                time: i,
                skyCondition: .fade,
                precipitationType: .none
            )
            
            cloudyWeathers.append(cloudyWeather)
            fadeWeathers.append(fadeWeather)
        }
        
        //when
        let cloudyExpectation = try sut.makeWeatherForecast(weathers: cloudyWeathers)
        let fadeExpectation = try sut.makeWeatherForecast(weathers: fadeWeathers)
        
        //then
        XCTAssertNil(cloudyExpectation.expectedTime)
        XCTAssertNil(fadeExpectation.expectedTime)
        
        XCTAssertEqual(cloudyExpectation.type, .notRainyToday)
        XCTAssertEqual(fadeExpectation.type, .notRainyToday)
    }
    
    func test_makeWeatherForecast_when_tomorrowIsNotRainy() throws {
        //given
        var cloudyWeathers: [ComputableWeather] = []
        var fadeWeathers: [ComputableWeather] = []
        let today = 20230820
        let tomorrow = today + 1
        
        for i in 21...23 {
            let cloudyWeather = StubWeather.makePrecipitationTypeStub(
                date: today,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .none)
            let fadeWeather = StubWeather.makePrecipitationTypeStub(
                date: today,
                time: i,
                skyCondition: .fade,
                precipitationType: .none)
            
            cloudyWeathers.append(cloudyWeather)
            fadeWeathers.append(fadeWeather)
        }
        
        for i in 0...20 {
            let cloudyWeather = StubWeather.makePrecipitationTypeStub(
                date: tomorrow,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .none)
            let fadeWeather = StubWeather.makePrecipitationTypeStub(
                date: tomorrow,
                time: i,
                skyCondition: .fade,
                precipitationType: .none)
            
            cloudyWeathers.append(cloudyWeather)
            fadeWeathers.append(fadeWeather)
        }
        
        //when
        let cloudyExpectation = try sut.makeWeatherForecast(weathers: cloudyWeathers)
        let fadeExpectation = try sut.makeWeatherForecast(weathers: fadeWeathers)
        
        //then
        XCTAssertNil(cloudyExpectation.expectedTime)
        XCTAssertNil(fadeExpectation.expectedTime)
        
        XCTAssertEqual(cloudyExpectation.type, .notRainyTomorrow)
        XCTAssertEqual(fadeExpectation.type, .notRainyTomorrow)
    }
    
    func test_makeWeatherForecast_when_todayIsRainy() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 0...24 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .rainy)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .rainyToday)
    }
    
    func test_makeWeatherForecast_when_tomorrowIsRainy() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .rainy)
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .rainy)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .rainyTomorrow)
    }
    
    func test_makeWeatherForecast_when_todayIsSleet() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 0...24 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .sleet)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .sleetToday)
    }
    
    func test_makeWeatherForecast_when_tomorrowIsSleet() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .sleet)
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .sleet)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .sleetTomorrow)
    }
    
    func test_makeWeatherForecast_when_todayIsSnowy() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 0...24 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .snowy)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .snowyToday)
    }
    
    func test_makeWeatherForecast_when_tomorrowIsSnowy() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .snowy)
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                skyCondition: .cloudy,
                precipitationType: .snowy)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertNil(expectation.expectedTime)
        XCTAssertEqual(expectation.type, .snowyTomorrow)
    }
    
    func test_makeWeatherForecast_when_willBeCleanToday() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        let sunnyTime = 12
        
        for i in 0...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                precipitationType: i < sunnyTime ? .rainy : .none
            )
            weathers.append(weather)
        }
        
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, sunnyTime)
        XCTAssertEqual(expectation.type, .willBeCleanToday)
    }
    
    func test_makeWeatherForecast_when_willBeCleanTomorrow() throws {
        //given
        var weathers: [ComputableWeather] = []
        let nowDate = 20230913
        let tomorrowDate = nowDate + 1
        let sunnyTime = 6
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: nowDate,
                time: i,
                precipitationType: .rainy
            )
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: tomorrowDate,
                time: i,
                precipitationType: i < sunnyTime ? .rainy : .none
            )
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, sunnyTime)
        XCTAssertEqual(expectation.type, .willBeCleanTomorrow)
    }
    
    func test_makeWeatherForecast_when_willBeRainyToday() throws {
        //given
        var weathers: [ComputableWeather] = []
        let date = 20230820
        let rainyTime = 12
        
        for i in 0...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: date,
                time: i,
                precipitationType: i < rainyTime ? .none : .rainy
            )
            weathers.append(weather)
        }
        
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, rainyTime)
        XCTAssertEqual(expectation.type, .willBeRainyToday)
    }
    
    func test_makeWeatherForecast_when_willBeRainyTomorrow() throws {
        //given
        var weathers: [ComputableWeather] = []
        let nowDate = 20230913
        let tomorrowDate = nowDate + 1
        let rainyTime = 6
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: nowDate,
                time: i,
                precipitationType: .none
            )
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: tomorrowDate,
                time: i,
                precipitationType: i < rainyTime ? .none : .rainy
            )
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, rainyTime)
        XCTAssertEqual(expectation.type, .willBeRainyTomorrow)
    }
    
    func test_makeWeatherForecast_when_willBeSleetToday() throws {
        //given
        var weathers: [ComputableWeather] = []
        let nowDate = 20230917
        let sleetTime = 12
        for i in 0...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: nowDate,
                time: i,
                precipitationType: i >= sleetTime ? .sleet : .none)
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, sleetTime)
        XCTAssertEqual(expectation.type, .willBeSleetToday)
    }
    
    func test_makeWeatherForecast_when_willBeSleetTomorrow() throws {
        //given
        var weathers: [ComputableWeather] = []
        let nowDate = 20230917
        let tomorrowDate = nowDate + 1
        let sleetTime = 6
        for i in 21...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: nowDate,
                time: i,
                precipitationType: .none
            )
            weathers.append(weather)
        }
        
        for i in 0...20 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: tomorrowDate,
                time: i,
                precipitationType: i >= sleetTime ? .sleet : .none
            )
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, sleetTime)
        XCTAssertEqual(expectation.type, .willBeSleetTomorrow)
    }
    
    func test_makeWeatherForecast_when_willBeSnowyToday() throws {
        //given
        var weathers: [ComputableWeather] = []
        let nowDate = 20230917
        let snowyTime = 18
        
        for i in 0...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: nowDate,
                time: snowyTime,
                precipitationType: i >= snowyTime ? .snowy : .none
            )
            weathers.append(weather)
        }
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, snowyTime)
        XCTAssertEqual(expectation.type, .willBeSnowyToday)
    }
    
    func test_makeWeatherForecast_when_willBeSnowyTomorrow() throws {
        //given
        var weathers: [ComputableWeather] = []
        let nowDate = 20230917
        let tomorrowDate = nowDate + 1
        let snowyTime = 2
        for i in 18...23 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: nowDate,
                time: i,
                precipitationType: .none
            )
            weathers.append(weather)
        }
        
        for i in 0...17 {
            let weather = StubWeather.makePrecipitationTypeStub(
                date: tomorrowDate,
                time: i,
                precipitationType: i >= snowyTime ? .snowy : .none
            )
            weathers.append(weather)
        }
        
        
        //when
        let expectation = try sut.makeWeatherForecast(weathers: weathers)
        
        //then
        XCTAssertEqual(expectation.expectedTime, snowyTime)
        XCTAssertEqual(expectation.type, .willBeSnowyTomorrow)
    }
}
