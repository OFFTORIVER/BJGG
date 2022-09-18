//
//  BbajiInfo.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import Foundation

struct BbajiInfo: Codable {
    
    private var name: String
    private var thumbnailImgName: String
    private var address: String
    private var contact: String
    private var liveCameraURL: String
    
    // Quick Test Init
    init() {
        name = "뚝섬유원지 선스키"
        thumbnailImgName = "thumbnailImg"
        address = "서울 광진구 강변북로64"
        contact = "02-498-9046"
        liveCameraURL = "https://developer.apple.com/streaming/examples/basic-stream-osx-ios4-3.html"
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
    
    func getAddress() -> String { return thumbnailImgName }
    
    func getContact() -> String { return thumbnailImgName }
    
    func getLiveCameraUrl() -> String { return liveCameraURL }
    
}
