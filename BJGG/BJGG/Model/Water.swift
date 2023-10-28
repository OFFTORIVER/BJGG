//
//  Water.swift
//  BJGG
//
//  Created by 황정현 on 2023/08/30.
//

import Foundation

struct Water: Decodable {
    let dataResponse: WaterDataResponse
    
    enum CodingKeys: String, CodingKey {
        case dataResponse = "WPOSInformationTime"
    }
    
    func extractWaterTemperature() -> [WaterData] {
        let data = self.dataResponse.waterItemList.map {
            WaterData(location: $0.siteID, temperature: $0.temperature)
        }
        return data
    }
}

struct WaterDataResponse: Decodable {
    let listCount: Int
    let responseResult: WaterResponseResult
    let waterItemList: [WaterItem]
    
    enum CodingKeys: String, CodingKey {
        case listCount = "list_total_count"
        case responseResult = "RESULT"
        case waterItemList = "row"
    }
}

struct WaterResponseResult: Decodable {
    let resultCode: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "CODE"
        case message = "MESSAGE"
    }
}

struct WaterItem: Decodable {
    let measureDate: String
    let measureTime: String
    let siteID: String
    let temperature: String
    let pHScale: String
    let dissolvedOxygen: String
    let totalNitrogen: String
    let totalPhosphorus: String
    let totalOrganicCarbon: String
    let phenol: String
    let cyanogen: String
    
    enum CodingKeys: String, CodingKey {
        case measureDate = "MSR_DATE"
        case measureTime = "MSR_TIME"
        case siteID = "SITE_ID"
        case temperature = "W_TEMP"
        case pHScale = "W_PH"
        case dissolvedOxygen = "W_DO"
        case totalNitrogen = "W_TN"
        case totalPhosphorus = "W_TP"
        case totalOrganicCarbon = "W_TOC"
        case phenol = "W_PHEN"
        case cyanogen = "W_CN"
        
    }
}
