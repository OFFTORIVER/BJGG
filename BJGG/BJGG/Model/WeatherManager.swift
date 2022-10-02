//
//  WeatherManager.swift
//  BJGG
//
//  Created by 이재웅 on 2022/10/03.
//

import Foundation

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
        case 0..<200:
            let day = str.split(separator: " ").map{ Int($0)! }[0]
            return String(day-1)
        case 2300...2400:
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
        case 200..<500:
            return "0200"
        case 500..<800:
            return "0500"
        case 800..<1100:
            return "0800"
        case 1100..<1400:
            return "1100"
        case 1400..<1700:
            return "1400"
        case 1700..<2000:
            return "1700"
        case 2000..<2300:
            return "2000"
        default:
            return "2300"
        }
    }()
    
    func requestCurrentData(nx: Int, ny: Int, completionHandler: @escaping (Bool, Any) -> Void) {
        requestData(nx: nx, ny: ny, numberOfRow: 1) { (success, data) in
            completionHandler(success, data)
        }
    }
    
    func request24hData(nx: Int, ny: Int, completionHandler: @escaping (Bool, Any) -> Void) {
        requestData(nx: nx, ny: ny, numberOfRow: 312) { (success, data) in
            completionHandler(success, data)
        }
    }
    
    private func requestData(nx: Int, ny: Int, numberOfRow: Int, completionHandler: @escaping (Bool, Any) -> Void) {
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(APIKey.key)&numOfRows=\(numberOfRow)&pageNo=1&dataType=JSON&base_date=\(today)&base_time=\(nowTime)&nx=\(nx)&ny=\(ny)"
        
        guard let url = URL(string: url) else {
            print("Error: cannet create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            guard let output = try? JSONDecoder().decode(Weather.self, from: data) else {
                print("Error: JSON data Parsing failed")
                return
            }
            
            completionHandler(true, output.response)
        }.resume()
    }
}
