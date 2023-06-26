//
//  WeatherManager.swift
//  BJGG
//
//  Created by 이재웅 on 2022/10/03.
//

import Foundation

enum WeatherManagerError: Error {
    case networkError(String)
    case apiError(String)
}

struct WeatherManager {
    private func requestWeather(nx: Int, ny: Int, numberOfRow: Int) async throws -> Weather {
        guard let weatherAPIKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            throw ConfigError.stringCastingError
        }
        let urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(weatherAPIKey)&numOfRows=\(numberOfRow)&pageNo=1&dataType=JSON&base_date=\(Date.requestDay)&base_time=\(Date.requestTime)&nx=\(nx)&ny=\(ny)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherManagerError.apiError("WeatherManager API Error : URL 변환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, httpResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpURLResponse = httpResponse as? HTTPURLResponse else {
            throw WeatherManagerError.networkError("WeatherManager Network Error : HTTP URL 응답 실패")
        }
        
        switch httpURLResponse.statusCode {
        case 200..<300:
            let weatherData = try JSONDecoder().decode(Weather.self, from: data)
            return weatherData
        default:
            throw WeatherManagerError.apiError("WeatherManager API Error : Statue Code \(httpURLResponse.statusCode)")
        }
    }
    
    func requestCurrentTimeWeather(nx: Int, ny: Int) async throws -> Weather {
        let weather = try await requestWeather(nx: nx, ny: ny, numberOfRow: 36)
        
        return weather
    }
    
    func request24HWeather(nx: Int, ny: Int) async throws -> Weather {
        let weather = try await requestWeather(nx: nx, ny: ny, numberOfRow: 324)
        
        return weather
    }
    
    //[Deprecated] completionHandler를 사용한 Weather 전달
//    func requestCurrentData(nx: Int, ny: Int, completionHandler: @escaping (Bool, Any) -> Void) {
//        requestData(nx: nx, ny: ny, numberOfRow: 36) { (success, data) in
//            completionHandler(success, data)
//        }
//    }
//
//    func request24hData(nx: Int, ny: Int, completionHandler: @escaping (Bool, Any) -> Void) {
//        requestData(nx: nx, ny: ny, numberOfRow: 324) { (success, data) in
//            completionHandler(success, data)
//        }
//    }
//
//    private func requestData(nx: Int, ny: Int, numberOfRow: Int, completionHandler: @escaping (Bool, Any) -> Void) {
//        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(APIKey.key)&numOfRows=\(numberOfRow)&pageNo=1&dataType=JSON&base_date=\(today)&base_time=\(nowTime)&nx=\(nx)&ny=\(ny)"
//
//        guard let url = URL(string: url) else {
//            print("Error: cannet create URL")
//            completionHandler(false, [])
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error: error calling GET")
//                completionHandler(false, [])
//                print(error!)
//                return
//            }
//
//            guard let data = data else {
//                print("Error: Did not receive data")
//                completionHandler(false, [])
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
//                print("Error: HTTP request failed")
//                completionHandler(false, [])
//                return
//            }
//
//            guard let output = try? JSONDecoder().decode(Weather.self, from: data) else {
//                print("Error: JSON data Parsing failed")
//                completionHandler(false, [])
//                return
//            }
//
//            completionHandler(true, output.response)
//        }.resume()
//    }
}

fileprivate extension Date {
    static var requestDay: String {
        let date = Date.currentWeatherTime
        let day = date.days
        let time = date.time
        
        switch time {
        case 0..<300:
            return String(day-1)
            
        default:
            return String(day)
        }
    }
    
    static var requestTime: String {
        let time = Date.currentWeatherTime.time
        
        switch time {
        case 300..<600:
            return "0200"
        case 600..<900:
            return "0500"
        case 900..<1200:
            return "0800"
        case 1200..<1500:
            return "1100"
        case 1500..<1800:
            return "1400"
        case 1800..<2100:
            return "1700"
        case 2100...2400:
            return "2000"
        default:
            return "2300"
        }
    }
}
