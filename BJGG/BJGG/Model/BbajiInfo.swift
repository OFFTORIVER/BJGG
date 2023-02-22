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
    private var compactAddress: String
    private var coordinateX: Int
    private var coordinateY: Int
    private var liveCameraURL: String
    
    init() {
        
        name = "선스키"
        thumbnailImgName = "bbajiThumbnailImage"
        address = "서울 광진구 강변북로64"
        contact = "02-498-9026"
        compactAddress = "광진구 자양동"
        coordinateX = 61
        coordinateY = 126
        liveCameraURL = ""
        
        do {
            let link = try liveCameraURLInitialize()
            liveCameraURL = link
        } catch {
            if let error = error as? PlistError {
                print(error.rawValue)
            }
        }
        
        
    }
    
    init(name: String, thumbnailImgName: String, address: String, contact: String, compactAddress: String, coordinateX: Int, coordinateY: Int, liveCamURL: String) {
        self.name = name
        self.thumbnailImgName = thumbnailImgName
        self.address = address
        self.contact = contact
        self.compactAddress = compactAddress
        self.coordinateX = coordinateX
        self.coordinateY = coordinateY
        self.liveCameraURL = liveCamURL
    }
        
    private func liveCameraURLInitialize() throws -> String {
        guard let privatePlist = Bundle.main.url(forResource: "Private", withExtension: "plist") else {
            throw PlistError.bundleError
        }
        
        guard let dictionary = NSDictionary(contentsOf: privatePlist) else {
            throw PlistError.dictionaryCastingError
        }
        
        guard let link: String = dictionary["hlsLink"] as? String else {
            throw PlistError.stringCastingError
        }
        
        return link
    }
    
    func getName() -> String { return name }
    
    func getThumbnailImgName() -> String { return thumbnailImgName }
    
    func getAddress() -> String { return address }
    
    func getContact() -> String { return contact }
    
    func getCompactAddress() -> String { return compactAddress }
    
    func getCoordinate() -> (Int, Int) { return (coordinateX, coordinateY) }
    
    func getLiveCameraUrl() -> String { return liveCameraURL }
    
}
