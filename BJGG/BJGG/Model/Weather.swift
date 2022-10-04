//
//  Weather.swift
//  BJGG
//
//  Created by 이재웅 on 2022/10/03.
//

import Foundation

struct WeatherItem: Decodable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
    
    var categoryName: String {
        return convertCategoryName(self.category)
    }
    
    var categoryValue: String {
        return convertCategoryValue(self.category, self.fcstValue)
    }
    
    var timeValue: String {
        let time = (Int(self.fcstTime) ?? -1) / 100
        
        switch time {
        case 0:
            return "오전 0시"
        case 0..<12:
            return "오전 \(time)시"
        case 12:
            return "오후 12시"
        case 13..<24:
            return "오후 \(time - 12)시"
        default:
            return "시간변환 실패"
        }
    }
    
    private func convertCategoryName(_ category: String) -> String {
        switch category {
        case "POP":
            return "강수확률"
        case "PTY":
            return "강수형태"
        case "PCP":
            return "1시간 강수량"
        case "REH":
            return "습도"
        case "SNO":
            return "1시간 신적설"
        case "SKY":
            return "하늘상태"
        case "TMP":
            return "1시간 기온"
        case "UUU":
            return "풍속(동서성분)"
        case "VVV":
            return "풍속(남북성분)"
        case "WAV":
            return "파고"
        case "VEC":
            return "풍향"
        case "WSD":
            return "풍속"
            
        default:
            return "예보항복 유형 판단오류"
        }
    }
    
    private func convertWindDirection(_ value: String) -> String {
        let windDirectionValue = Double(value)!
        let convertedValue = Int((windDirectionValue + (22.5 * 0.5))/22.5)
        
        switch convertedValue {
        case 0, 16:
            return "N"
        case 1:
            return "NNE"
        case 2:
            return "NE"
        case 3:
            return "ENE"
        case 4:
            return "E"
        case 5:
            return "ESE"
        case 6:
            return "SE"
        case 7:
            return "SSE"
        case 8:
            return "S"
        case 9:
            return "SSW"
        case 10:
            return "SW"
        case 11:
            return "WSW"
        case 12:
            return "W"
        case 13:
            return "WNW"
        case 14:
            return "NW"
        case 15:
            return "NNW"
            
        default:
            return "풍향 변환실패"
        }
    }
    
    private func convertSkyCondition(_ value: String) -> String {
        switch value {
        case "1":
            return "맑음"
        case "3":
            return "구름많음"
        case "4":
            return "흐림"
        default:
            return "무언가 내림"
        }
    }
    
    private func convertSnowValue(_ value: String) -> String {
        switch Double(value) ?? -1 {
        case -1:
            return "적설없음"
        case 0..<1:
            return "1cm 미만"
        case 1..<5:
            return "1cm 이상 5cm 미만"
        default:
            return "5cm 이상"
        }
    }
    
    private func convertRainfallValue(_ value: String) -> String {
        switch Int(value) ?? -1 {
        case -1:
            return "강수없음"
        case 0..<1:
            return "1mm 미만"
        case 1..<30:
            return "1mm 이상 30mm 미만"
        case 30..<50:
            return "30~50mm"
        default:
            return "50mm 이상"
        }
    }
    
    private func convertPrecipitaionFornValue(_ value: String) -> String {
        switch Int(value) ?? -1 {
        case 0:
            return "강수없음"
        case 1:
            return "비"
        case 2:
            return "비/눈"
        case 3:
            return "눈"
        case 4:
            return "소나기"
        default:
            return "강수형태 변환오류"
        }
    }
    
    private func convertCategoryValue(_ category: String, _ value: String) -> String {
        switch category {
        case "POP", "REH":
            return "\(value)%"
        case "PTY":
            return convertPrecipitaionFornValue(value)
        case "PCP":
            return convertRainfallValue(value)
        case "SNO":
            return convertSnowValue(value)
        case "SKY":
            return convertSkyCondition(value)
        case "TMP":
            return "\(value)도"
        case "UUU", "VVV", "WSD":
            return "\(value)m/s"
        case "WAV":
            return "\(value)m"
        case "VEC":
            return convertWindDirection(value)
            
        default:
            return "예보항복 유형 판단오류"
        }
    }
}

struct WeatherItems: Decodable {
    let item: [WeatherItem]
    
    func requestWeatherDataSet(_ weatherItems: [WeatherItem]) -> [(time: String, iconName: String, temp: String, probability: String)] {
        var weatherData = [(time: String, iconName: String, temp: String, probability: String)]()
        
        var status: (time: String?, timeText: String?, sky: String?, pty: String?, tmp: String?, prob: String?)
        
        func classifyIconName(pty: String, sky: String, time: String) -> String {
            if pty == "강수없음" {
                let time = Int(status.time ?? "") ?? 0
                
                if 600 <= time && time <= 1800 {
                    if sky == "맑음" {
                        return "sunny"
                    } else if sky == "구름많음" {
                        return "cloudy"
                    } else if sky == "흐림" {
                        return "fade"
                    } else {
                        return "sunny"
                    }
                } else {
                    if sky == "맑음" {
                        return "night"
                    } else if sky == "구름많음" {
                        return "cloudyNight"
                    } else if sky == "흐림" {
                        return "fade"
                    } else {
                        return "night"
                    }
                }
            } else if pty == "비" || pty == "소나기" {
                return "rainy"
            } else if pty == "비/눈" {
                return "sleet"
            } else if pty == "눈" {
                return "snowy"
            } else {
                return "sunny"
            }
        }
        
        weatherItems.forEach {
            if status.time != nil && status.sky != nil && status.pty != nil && status.tmp != nil && status.prob != nil {
                var data = (time: status.timeText ?? "오후 00시", iconName: "", temp: status.tmp ?? "00", probability: status.prob ?? "0%")
                
                data.iconName = classifyIconName(pty: status.pty ?? "", sky: status.sky ?? "", time: status.time ?? "")
                
                weatherData.append(data)
                
                status.time = nil
                status.timeText = nil
                status.sky = nil
                status.pty = nil
                status.tmp = nil
                status.prob = nil
            }
            
            if status.time == nil {
                status.time = $0.fcstTime
                status.timeText = $0.timeValue
            }
            
            if $0.category == "SKY" {
                status.sky = $0.categoryValue
            } else if $0.category == "TMP" {
                status.tmp = $0.fcstValue
            } else if $0.category == "PTY" {
                status.pty = $0.categoryValue
            } else if $0.category == "POP" {
                status.prob = $0.categoryValue
            }
        }
        
        if status.time != nil && status.sky != nil && status.pty != nil && status.tmp != nil && status.prob != nil {
            var data = (time: status.timeText ?? "오후 00시", iconName: "", temp: status.tmp ?? "00", probability: status.prob ?? "0%")
            
            data.iconName = classifyIconName(pty: status.pty ?? "", sky: status.sky ?? "", time: status.time ?? "")
            
            weatherData.append(data)
        }
        
        return weatherData
    }
    
    func requestCurrentWeatherItem() -> [WeatherItem] {
        var filteredItem = [WeatherItem]()
        
        var currentHour: String {
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd HHmm"
            formatter.locale = Locale(identifier: "ko_kr")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            
            let str = formatter.string(from: now)
            let time = str.split(separator: " ").map{ Int($0)! }[1]
            
            let calculatedTime = (time / 100) * 100
            
            if calculatedTime < 1000 {
                return "0\(calculatedTime)"
            } else {
                return "\(calculatedTime)"
            }
        }
        
        item.forEach {
            if $0.fcstTime == currentHour {
                if $0.category == "TMP" || $0.category == "SKY" || $0.category == "POP" || $0.category == "PTY" {
                    filteredItem.append($0)
                }
            }
        }
        
        return filteredItem
    }
    
    func request24HourWeatherItem() -> [WeatherItem] {
        var filteredItem = [WeatherItem]()
        
        var current: (day: String, time: Int) {
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd HHmm"
            formatter.locale = Locale(identifier: "ko_kr")
            formatter.timeZone = TimeZone(abbreviation: "KST")

            let currentDayAndTime = formatter.string(from: now).split(separator: " ")
            let currentDay = String(currentDayAndTime[0])
            let time = Int(currentDayAndTime[1])!

            let calculatedTime = (time / 100) * 100

            if calculatedTime < 1000 {
                return (currentDay, calculatedTime)
            } else {
                return (currentDay, calculatedTime)
            }
        }
        
        item.forEach {
            if $0.category == "TMP" || $0.category == "SKY" || $0.category == "POP" || $0.category == "PTY" {
                if $0.fcstDate == current.day {
                    if current.time <= Int($0.fcstTime)! {
                        filteredItem.append($0)
                    }
                } else {
                    if Int($0.fcstTime)! <= current.time {
                        filteredItem.append($0)
                    }
                }
            }
        }
        
        return filteredItem
    }
}

struct WeatherBody: Decodable {
    let dataType: String
    let items: WeatherItems
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct Header: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct Response: Decodable {
    let header: Header
    let body: WeatherBody
}

struct Weather: Decodable {
    let response: Response
}
