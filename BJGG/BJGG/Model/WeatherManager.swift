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
}
