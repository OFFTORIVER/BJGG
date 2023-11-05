//
//  WaterTemperatureManager.swift
//  BJGG
//
//  Created by 황정현 on 2023/08/30.
//

import Foundation

enum WaterTemperatureManagerError: Error {
    case networkError(String)
    case apiError(String)
}

struct WaterManager {
    func requestWaterTemperature() async throws -> Water {
        guard let waterTempAPIKey = Bundle.main.object(forInfoDictionaryKey: "WATER_TEMPERATURE_API_KEY") as? String else {
            throw ConfigError.stringCastingError
        }
        
        let requestUrlString = "http://openapi.seoul.go.kr:8088/\(waterTempAPIKey)/json/WPOSInformationTime/1/5/"
        
        guard let requestURL = URL(string: requestUrlString) else {
            throw WaterTemperatureManagerError.apiError("WaterTemperatureManagerError API Error : URL 변환 실패")
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let (data, httpResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpURLResponse = httpResponse as? HTTPURLResponse else {
            throw WaterTemperatureManagerError.networkError("WaterTemperatureManagerError Network Error : HTTP URL 응답 실패")
        }
        
        switch httpURLResponse.statusCode {
        case 200..<300:
            let waterData = try JSONDecoder().decode(Water.self, from: data)
             return waterData
        default:
            throw WaterTemperatureManagerError.apiError("WaterTemperatureManagerError API Error : Statue Code \(httpURLResponse.statusCode)")
        }
    }
}
