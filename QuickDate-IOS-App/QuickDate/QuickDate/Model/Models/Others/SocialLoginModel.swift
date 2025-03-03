
//
//  SocialLoginModel.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
class SocialLoginModel:BaseModel{
    
    struct SocialLoginSuccessModel: Codable {
        let status, waitValidation: Int?
        let accessToken: String?
        let data: DataClass?
        
        enum CodingKeys: String, CodingKey {
            case status
            case waitValidation = "wait_validation"
            case accessToken = "access_token"
            case data
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id: Int?
        let username, email, ipAddress, name: String?
        let gender, emailCode, language: String?
        let avatar, cover: String?
        let src: String?
        let countryID, age: Int?
        let about, google, facebook, twitter: String?
        let instagram: String?
        let active, admin, verified, lastActive: Int?
        let registered: String?
        let uploads: Int?
        let wallet, balance, website: String?
        let artist, isPro, proTime, lastFollowID: Int?
        let iosDeviceID, androidDeviceID, webDeviceID, orAvatar: String?
        let orCover: String?
        let url: String?
        let aboutDecoded, nameV, countryName, genderText: String?
        
        enum CodingKeys: String, CodingKey {
            case id, username, email
            case ipAddress = "ip_address"
            case name, gender
            case emailCode = "email_code"
            case language, avatar, cover, src
            case countryID = "country_id"
            case age, about, google, facebook, twitter, instagram, active, admin, verified
            case lastActive = "last_active"
            case registered, uploads, wallet, balance, website, artist
            case isPro = "is_pro"
            case proTime = "pro_time"
            case lastFollowID = "last_follow_id"
            case iosDeviceID = "ios_device_id"
            case androidDeviceID = "android_device_id"
            case webDeviceID = "web_device_id"
            case orAvatar = "or_avatar"
            case orCover = "or_cover"
            case url
            case aboutDecoded = "about_decoded"
            case nameV = "name_v"
            case countryName = "country_name"
            case genderText = "gender_text"
        }
    }
}
