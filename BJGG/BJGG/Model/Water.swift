//
//  Water.swift
//  BJGG
//
//  Created by 황정현 on 2023/08/30.
//

import Foundation

struct Water: Decodable {
    let WPOSInformationTime: WaterDataResponse
    
    func extractWaterTemperature() -> [WaterData] {
        let data = self.WPOSInformationTime.row.map {
            WaterData(location: $0.SITE_ID, temperature: $0.W_TEMP)
        }
        return data
    }
}

struct WaterDataResponse: Decodable {
    let list_total_count: Int
    let RESULT: WaterResponseResult
    let row: [WaterItem]
}

struct WaterResponseResult: Decodable {
    let CODE: String
    let MESSAGE: String
}

struct WaterItem: Decodable {
    let MSR_DATE: String
    let MSR_TIME: String
    let SITE_ID: String
    let W_TEMP: String
    let W_PH: String
    let W_DO: String
    let W_TN: String
    let W_TP: String
    let W_TOC: String
    let W_PHEN: String
    let W_CN: String
}
