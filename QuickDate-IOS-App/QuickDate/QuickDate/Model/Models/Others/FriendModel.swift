//
//  FriendModel.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import Foundation
class GetListFiendModel:BaseModel{
    struct GetListFiendSuccessModel: Codable {
        var status: Int?
        var data: [Datum]?
        var message: String?
    }

    // MARK: - Datum
    struct Datum: Codable {
        var id, online, lastseen: Int?
        var username: String?
        var avater: String?
        var country, firstName, lastName, location: String?
        var birthday, language: String?
        var relationship: Int?
        var height: String?
        var body, smoke, ethnicity, pets: Int?
        var countryTxt: String?

        enum CodingKeys: String, CodingKey {
            case id, online, lastseen, username, avater, country
            case firstName = "first_name"
            case lastName = "last_name"
            case location, birthday, language, relationship, height, body, smoke, ethnicity, pets
            case countryTxt = "country_txt"
        }
    }

    // MARK: - Errors
    struct Errors: Codable {
        var errorID, errorText: String?

        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
class AddOrDeleteFriendRequestModel:BaseModel{
    
    struct AddOrDeleteFriendRequestSuccessModel: Codable {
        let status: Int?
        let message: String?
        let errors: Errors?
    }

    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String

        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
