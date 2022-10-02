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
}

struct WeatherItems: Decodable {
    let item: [WeatherItem]
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
