//
//  WeatherService.swift
//  BJGG
//
//  Created by Jaewoong Lee on 2023/10/29.
//

import Foundation

enum WeatherServiceError: Error {
    case networkError(String)
    case apiError(String)
    case wrongURL(String)
    case failedToConvertDate(String)
    case failedToGetResponse(String)
}

protocol WeatherServiceProtocol {
    associatedtype WeatherServiceParameter
    
    func request(parameter: WeatherServiceParameter) async throws -> WeatherAPIDTO
}

class WeatherService {
    private let baseURL = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
}

extension WeatherService: WeatherServiceProtocol {
    
    struct WeatherServiceParameter {
        let numOfRows: Int
        let pageNo: Int
        let dataType: WeatherServiceDataType
        let baseDate: Date
        let nx: Int
        let ny: Int
    }
    
    func request(parameter: WeatherServiceParameter) async throws -> WeatherAPIDTO {
        guard let apiKey = getWeatherAPIKey() else {
            throw ConfigError.stringCastingError
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw WeatherServiceError.wrongURL("[WeatherService] URL 변환 실패")
        }
        
        guard let dateParamter = parameter.baseDate.toDays(),
              let timeParamter = parameter.baseDate.toTime() else {
            throw WeatherServiceError.failedToConvertDate("[WeatherService] Date 파라미터 변환 실패")
        }
        
        let queryParamter: [String: String] = [
           "serviceKey": apiKey,
           "numOfRows": parameter.numOfRows.toString(),
           "pageNo": parameter.pageNo.toString(),
           "dataType": parameter.dataType.rawValue,
           "base_date": dateParamter,
           "base_time": timeParamter,
           "nx": parameter.nx.toString(),
           "ny": parameter.ny.toString()
        ]
        
        urlComponents.percentEncodedQueryItems = queryParamter.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let requestURL = urlComponents.url else {
            throw WeatherServiceError.wrongURL("[WeatherService] URL 파라미터 변환 실패")
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"

        let (data, httpResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpURLResponse = httpResponse as? HTTPURLResponse else {
            throw WeatherServiceError.failedToGetResponse("[WeatherService] HTTP Response 응답 없음")
        }
        
        switch httpURLResponse.statusCode {
        case 200..<300:
            return try JSONDecoder().decode(WeatherAPIDTO.self, from: data)
        default:
            throw WeatherServiceError.apiError("[WeatherService] API 서버 에러")
        }
    }
    
    private func getWeatherAPIKey() -> String? {
        Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String
    }
}

extension WeatherService.WeatherServiceParameter {
    enum WeatherServiceDataType: String {
        case JSON = "JSON"
    }
}

fileprivate extension Date {
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmm"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter
    }()
    
    func toDays() -> String? {
        let dateString = Date.formatter.string(from: self).split(separator: " ")[0]
        guard let dateInt = Int(dateString) else { return nil }
        
        switch dateInt {
        case 0..<300:
            return String(dateInt-1)
        default:
            return String(dateInt)
        }
    }
    
    func toTime() -> String? {
        let dateString = Date.formatter.string(from: self).split(separator: " ")[0]
        guard let timeInt = Int(dateString) else { return nil }
        
        switch timeInt {
        case 300..<600:
            return "0200"
        case 600..<900:
            return "0500"
        case 900..<1200:
            return "0800"
        case 1200..<1500:
            return "1100"
        case 1500..<1800:
            return "1400"
        case 1800..<2100:
            return "1700"
        case 2100...2400:
            return "2000"
        default:
            return "2300"
        }
    }
}
