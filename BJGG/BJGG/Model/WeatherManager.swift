//
//  WeatherManager.swift
//  BJGG
//
//  Created by 이재웅 on 2022/10/03.
//

import Foundation

enum WeatherManagerError: Error {
    case urlError
    case clientError
    case apiError
}

struct WeatherManager {
    private let today: String = {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmm"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        let str = formatter.string(from: now)
        
        let time = str.split(separator: " ").map{ Int($0)! }[1]
        
        switch time {
        case 0..<300:
            let day = str.split(separator: " ").map{ Int($0)! }[0]
            return String(day-1)
            
        default:
            return str.split(separator: " ").map{ String($0) }[0]
        }
    }()
    
    private let nowTime: String = {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmm"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        let str = formatter.string(from: now)
        let time = str.split(separator: " ").map{ Int($0)! }[1]
        
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
    }()
    
    private func requestWeather(nx: Int, ny: Int, numberOfRow: Int) async throws -> Weather {
        guard let privatePlist = Bundle.main.url(forResource: "Private", withExtension: "plist") else {
            throw PlistError.bundleError
        }
        
        guard let dictionary = NSDictionary(contentsOf: privatePlist) else {
            throw PlistError.dictionaryCastingError
        }
        
        let weatherAPIKey = dictionary["weatherAPIKey"] as! String
        let urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(weatherAPIKey)&numOfRows=\(numberOfRow)&pageNo=1&dataType=JSON&base_date=\(today)&base_time=\(nowTime)&nx=\(nx)&ny=\(ny)"
        
        guard let url = URL(string: urlString) else {
            throw PlistError.stringCastingError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, httpResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpURLResponse = httpResponse as? HTTPURLResponse else {
            throw WeatherManagerError.apiError
        }
        
        switch httpURLResponse.statusCode {
        case (200..<300):
            let weatherData = try JSONDecoder().decode(Weather.self, from: data)
            return weatherData
        case (300..<500):
            throw WeatherManagerError.clientError
        default:
            throw WeatherManagerError.apiError
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
