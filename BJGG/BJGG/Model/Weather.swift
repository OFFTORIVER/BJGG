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

