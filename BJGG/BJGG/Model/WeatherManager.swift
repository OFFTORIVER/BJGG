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
}
