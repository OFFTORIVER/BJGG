//
//  WeatherDTO.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/07/24.
//

import Foundation

struct WeatherAPIDTO: Decodable {
    let response: WeatherResonseDTO
}

struct WeatherResonseDTO: Decodable {
    let header: WeatherResponseDTOHeader
    let body: WeatherResponseDTOBody
}

struct WeatherResponseDTOHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct WeatherResponseDTOBody: Decodable {
    let dataType: String
    let items: WeatherItemDTO
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct WeatherItemDTO: Decodable {
    let item: [WeatherDTO]
}

struct WeatherDTO: Decodable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}
