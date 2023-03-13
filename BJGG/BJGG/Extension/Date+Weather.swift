//
//  Date+Weather.swift
//  BJGG
//
//  Created by 이재웅 on 2023/03/13.
//

import Foundation

extension Date {
    /// 현재시간을 String 타입의 yyyyMMdd HHmm 형식으로 반환하는 변수
    static var currentStringForWeather: String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmm"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter.string(from: now)
    }
    
}
