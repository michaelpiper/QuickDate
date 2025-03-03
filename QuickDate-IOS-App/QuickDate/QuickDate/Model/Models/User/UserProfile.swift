//
//  UserProfile.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 28.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// TODO: Decrease properties to save memory 
/*struct UserProfile {
    
    let isFriend, isFriendRequest: Bool
    let isVerified: Bool
    
    // TODO: consider to delete if there aren't necessary
    let userId: Int
    let username, email, firstName, lastName: String
    let avatar: String
    let address, gender: String
    let phoneNumber: String
    let about: String
    let isPro: Bool
    let birthday, country: String
    let lastseen: Int
    let interest: String
    let height: String
    let age: Int
    
    let isFavorite: Bool
    
    let coordinate: Coordinate
    
    let facebook, google, twitter, linkedin, website, instagram: String
    
    let profile: ProfileFeatures
    
    let favourites: Favourites
    
    let mediaFiles: [MediaFile]
    
    var fullName: String {
        return firstName.isEmpty && lastName.isEmpty ? username
        : lastName.isEmpty ? firstName
        : firstName.isEmpty ? username
        : "\(firstName) \(lastName)"
    }
    
    // MARK: - Initializer
    init(dict: JSON) {
        self.isFriend = dict.getValue(key: .isFriend, defaultValue: false)
        self.isFriendRequest = dict.getValue(key: .isFriendRequest, defaultValue: false)
        self.isVerified = dict.getBoolType(with: JSONKeys.verified.rawValue)
        

        self.userId = dict.getIntegerFromString(key: .id, defaultValue: 0)
        self.age = dict.getValue(key: .age, defaultValue: 18)
        self.avatar = dict.getValue(key: .avater, defaultValue: "")
        self.username = dict.getValue(key: .username, defaultValue: "")
        self.email = dict.getValue(key: .email, defaultValue: "")
        self.firstName = dict.getValue(key: .firstName, defaultValue: "")
        self.lastName = dict.getValue(key: .lastName, defaultValue: "")
        self.address = dict.getValue(key: .address, defaultValue: "")
        
        self.isFavorite = dict.getValue(key: .isFavorite, defaultValue: false)
        
        self.phoneNumber = dict.getValue(key: .phoneNumber, defaultValue: "")
        self.about = dict.getValue(key: .about, defaultValue: "")
        self.birthday = dict.getValue(key: .birthday, defaultValue: "")
        self.country = dict.getValue(key: .country, defaultValue: "")
        self.lastseen = dict.getIntegerFromString(key: .lastseen, defaultValue: 0)
        self.isPro = dict.getBoolType(with: JSONKeys.isPro.rawValue)
        self.interest = dict.getValue(key: .interest, defaultValue: "")
        
        self.height = dict.getValue(key: .height, defaultValue: "")
        
        // Coordinate
        let lat = dict.getValue(key: .lat, defaultValue: "")
        let long = dict.getValue(key: .lng, defaultValue: "")
        self.coordinate = (lat, long)
        
        // Social Media
        self.facebook = dict.getValue(key: .facebook, defaultValue: "")
        self.google = dict.getValue(key: .google, defaultValue: "")
        self.instagram = dict.getValue(key: .instagram, defaultValue: "")
        self.linkedin = dict.getValue(key: .linkedin, defaultValue: "")
        self.website = dict.getValue(key: .website, defaultValue: "")
        self.twitter = dict.getValue(key: .twitter, defaultValue: "")

        self.favourites = Favourites(from: dict)
        self.mediaFiles = dict.getMediaFileList(with: "mediafiles")
        
        self.gender = dict.getValue(key: .genderTxt, defaultValue: "")
        self.profile = ProfileFeatures(from: dict)
    }

    fileprivate enum JSONKeys: String {
        case id
        case verifiedFinal = "verified_final"
        case countryTxt = "country_txt"
        case age
        case profileCompletion = "profile_completion"
        case avater
        case username, email
        case firstName = "first_name"
        case lastName = "last_name"
        case address, gender
        case genderTxt = "gender_txt"
        case facebook, google, twitter, linkedin, website, instagram
        case phoneNumber = "phone_number"
        case lat, lng, about, birthday, country, lastseen, height, interest
        case verified
        case isPro = "is_pro"
       
        case isFriendRequest = "is_friend_request"
        case isFriend = "is_friend"
        case isFavorite = "is_favorite"
    }
}*/

/*extension JSON {
    
    fileprivate func getIntegerFromString(key: UserProfile.JSONKeys, defaultValue: Int) -> Int {
        guard let numberString = self[key.rawValue] as? String,
              let number = Int(numberString) else {
                  return defaultValue
              }
        return number
    }
    
    fileprivate func getBool(key: UserProfile.JSONKeys, defaultValue: Bool) -> Bool {
        guard let boolString = self[key.rawValue] as? String else {
                  return defaultValue
              }
        return boolString.lowercased() == "true" ? true : false
    }
    
    fileprivate func getValue<T>(key: UserProfile.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    
}*/
