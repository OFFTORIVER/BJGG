//
//  PlistError.swift
//  BJGG
//
//  Created by 황정현 on 2023/02/22.
//

import Foundation

enum PlistError: String, Error {
    case bundleError = "Bundle을 찾지 못했습니다."
    case dictionaryCastingError = "Dictionary 타입 변환에 실패했습니다."
    case stringCastingError = "String 타입 변환에 실패했습니다."
}
