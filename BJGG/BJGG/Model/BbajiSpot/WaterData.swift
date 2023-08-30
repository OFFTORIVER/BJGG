//
//  WaterData.swift
//  BJGG
//
//  Created by 황정현 on 2023/08/30.
//

import Foundation

struct WaterData {
    let location: String
    let temperature: String
    
    init() {
        location = ""
        temperature = "--"
    }
    
    init(location: String, temperature: String) {
        self.location = location
        self.temperature = temperature
    }
}
