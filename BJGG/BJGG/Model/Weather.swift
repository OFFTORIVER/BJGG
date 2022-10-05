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
    
    private var current: (day: String, time: Int) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmm"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")

        let currentDayAndTime = formatter.string(from: now).split(separator: " ")
        let currentDay = String(currentDayAndTime[0])
        let time = Int(currentDayAndTime[1])!
        let calculatedTime = (time / 100) * 100
        
        return (currentDay, calculatedTime)
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
    
    func requestRainInfoText() -> String {
        let weatherItems = request24HourWeatherItem()
        let (isRainingNow, currentStatus, skyStatus) = isRainingNow(weatherItems)
        var day = ""
        
        if isRainingNow {
            // '강수없음' 일 경우
             let (willBecomePrecipitation, time, status) = willBecomePrecipitationIn24Hours(weatherItems)
            
            if willBecomePrecipitation {
                // 강수형태가 강수 없음에서 다른 형태로 바뀔 예정이 있을 경우
                guard let status = status else { return "기상상태 변환 오류" }
                var postPosition: String {
                    if status == "눈" || status == "비/눈" {
                        return "이"
                    } else {
                        return "가"
                    }
                }
                
                if isTheDayTomorrow(time) {
                    // 다른 강수상태로 바뀔 예정일 시간이 내일인 경우
                    day = "내일"
                    
                } else {
                    // 다른 강수상태로 바뀔 예정일 시간이 오늘인 경우
                    day = "오늘"
                }
                
                let timeValue = Int(time)! / 100
                
                return "\(day) \(timeValue)시 경에 \(status)\(postPosition) 올 예정이에요!"
            } else {
                // 강수형태가 강수 없음에서 다른 형태로 바뀔 예정이 없을 경우
                if isTimeLeftIn3hours(time) {
                    // 하루의 남은 시간이 3시간 이하일 경우
                    day = "내일"
                } else {
                    // 하루의 남은 시간이 3시간 이상일 경우
                    day = "오늘"
                }
                
                if skyStatus == "맑음" {
                    return "\(day)은 계속 맑아요!"
                } else {
                    return "\(day)은 비소식이 없어요!"
                }
            }
            
        } else {
            // '강수없음'이 아닐 경우
            guard let status = currentStatus else { return "기상상태 변환 오류" }
            let (willBecomeClean, time) = willBecomeCleanIn24Hours(weatherItems)
            var postPosition: String {
                if status == "눈" || status == "비/눈" {
                    return "이"
                } else {
                    return "가"
                }
            }
            
            if willBecomeClean {
                // 강수형태가 강수 없음으로 바뀔 예정이 있을 경우
                if isTheDayTomorrow(time) {
                    // 강수없음으로 바뀔 예정일 시간이 내일인 경우
                    day = "내일"
                } else {
                    // 강수없음으로 바뀔 예정일 시간이 오늘인 경우
                    day = "오늘"
                }
                
                let timeValue = Int(time)! / 100
                
                return "\(day) \(timeValue)시 경에 \(status)\(postPosition) 그칠 예정이에요!"
            } else {
                // 강수형태가 강수 없음으로 바뀔 예정이 없는 경우
                if isTimeLeftIn3hours(time) {
                    // 하루의 남은 시간이 3시간 이하일 경우
                    day = "내일"
                } else {
                    // 하루의 남은 시간이 3시간 이상일 경우
                    day = "오늘"
                }
                
                return "\(day)은 계속 \(status)\(postPosition) 와요!"
            }
        }
    }
    
    private func isRainingNow(_ weatherItems: [WeatherItem]) -> (Bool, String?, String?) {
        var weatherStatus: String?
        var skyStatus: String?
        
        for item in weatherItems {
            if item.category == "SKY" && Int(item.fcstTime)! == current.time && item.fcstDate == current.day {
                skyStatus = item.categoryValue
            }
            if item.category == "PTY" && Int(item.fcstTime)! == current.time && item.fcstDate == current.day {
                weatherStatus = item.categoryValue
                break
            }
        }
        
        if weatherStatus == "강수없음" {
            return (true, nil, skyStatus)
        } else {
            return (false, weatherStatus, nil)
        }
    }
    
    private func willBecomePrecipitationIn24Hours(_ weatherItems: [WeatherItem]) -> (Bool, String, String?) {
        var status: String?
        
        var willBecomePrecipitation = false
        var time = ""
        
        for i in 4..<weatherItems.count {
            if Int(weatherItems[i].fcstTime)! != current.time || weatherItems[i].fcstDate != current.day {
                if weatherItems[i].categoryName == "강수형태" && weatherItems[i].categoryValue != "강수없음" {
                    willBecomePrecipitation = true
                    status = weatherItems[i].categoryValue
                    time = weatherItems[i].fcstTime
                    break
                }
            }
        }
        
        if time == "" {
            if current.time < 1000 {
                time = "0\(current.time)"
            } else {
                time = "\(current.time)"
            }
        }
        
        return (willBecomePrecipitation, time, status)
    }
    
    private func willBecomeCleanIn24Hours(_ weatherItems: [WeatherItem]) -> (Bool, String) {
        var willBecomeClean = false
        var time = ""
        
        for i in 4..<weatherItems.count {
            if Int(weatherItems[i].fcstTime)! != current.time || weatherItems[i].fcstDate != current.day {
                if weatherItems[i].categoryName == "강수형태" && weatherItems[i].categoryValue == "강수없음" {
                    willBecomeClean = true
                    time = weatherItems[i].fcstTime
                    break
                }
            }
        }
        
        if time == "" {
            if current.time < 1000 {
                time = "0\(current.time)"
            } else {
                time = "\(current.time)"
            }
        }
        
        return (willBecomeClean, time)
    }
    
    private func isTheDayTomorrow(_ time: String) -> Bool {
        if Int(time)! <= current.time {
            return true
        } else {
            return false
        }
    }
    
    private func isTimeLeftIn3hours(_ time: String) -> Bool {
        let hour = Int(time)! / 100
        
        if (24 - hour) <= 3 {
            return true
        } else {
            return false
        }
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
