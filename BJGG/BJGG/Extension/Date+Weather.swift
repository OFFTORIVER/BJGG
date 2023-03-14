//
//  Date+Weather.swift
//  BJGG
//
//  Created by 이재웅 on 2023/03/13.
//

import Foundation

extension Date {
    /// 현재시간을 WeatherTime으로 반환하는 변수
    static var currentWeatherTime: WeatherTime {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmm"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let date = formatter.string(from: now).split(separator: " ")
        
        guard let days = Int(date[0]), let time = Int(date[1]) else {
            print("Date currenyWeatherTime Error : 현재시간의 형식반환에서 오류가 발생했습니다.")
            print("에러발생 Date() : \(date)")
            print("현재 반환된 currentWeatherTime: (20230101, 0000)")
            return WeatherTime(20230101, 0000)
        }
        
        return WeatherTime(days, time)
    }
}
