//
//  BbajiServiceInfo.swift
//  BJGG
//
//  Created by 황정현 on 2023/05/10.
//

import Foundation

enum BbajiServiceInfo: String {
    case lockerRoom
    case barbecue
    case store
    case equipmentRental
    case waterRides
    case dogCompanion
    case buoy
    
    func serviceInfoName() -> String {
        switch self {
        case .lockerRoom:
            return "라커룸"
        case .barbecue:
            return "바베큐"
        case .store:
            return "매점"
        case .equipmentRental:
            return "장비 대여"
        case .waterRides:
            return "물놀이 기구"
        case .dogCompanion:
            return "애견 동반"
        case .buoy:
            return "부이"
        }
    }
}
