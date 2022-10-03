//
//  BbajiInfo.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import Foundation

struct BbajiInfo: Encodable {
    
    private var name: String
    private var thumbnailImgName: String
    private var address: String
    private var contact: String
    private var liveCameraURL: String
    
    // Quick Test Init
    init() {
        name = "선스키"
        thumbnailImgName = "thumbnailImg"
        address = "서울 광진구 강변북로64"
        contact = "02-498-9026"
        liveCameraURL = "https://offtoriver.shop/hls/waterskii.m3u8"
    }
    
    init(name: String, thumbnailImgName: String, address: String, contact: String, liveCamURL: String) {
        self.name = name
        self.thumbnailImgName = thumbnailImgName
        self.address = address
        self.contact = contact
        self.liveCameraURL = liveCamURL
    }
    
    func getName() -> String { return name }
    
    func getThumbnailImgName() -> String { return thumbnailImgName }
    
    func getAddress() -> String { return address }
    
    func getContact() -> String { return contact }
    
    func getLiveCameraUrl() -> String { return liveCameraURL }
    
}
