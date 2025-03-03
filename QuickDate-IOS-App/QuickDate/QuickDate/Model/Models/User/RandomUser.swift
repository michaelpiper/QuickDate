//
//  RandomUser.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 19.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Async

struct RandomUser: Equatable {
    // MARK: - Properties
    let userId: Int
    let verifiedFinal: Bool
    let age, profileCompletion: Int
    let avatar: String
    
    let username, email, firstName: String
    let lastName, address, gender, genderTxt: String
    let language, languageTxt: String
    let phoneNumber, about: String
    let country, countryTxt: String
    let birthday: String
    let lastseen: Int
    let isPro, isFavorite, isOwner, isLiked, isBlocked: Bool
    let coordinate: Coordinate
    let isVerified: Bool
    
    let facebook, google, twitter, linkedin, website, instagram: String
    
    let profile: ProfileFeatures
    let favourites: Favourites
    
    let interest: String
    
    let mediaFiles: [MediaFile]
    
    // MARK: - Computed Properties
    
    var fullName: String {
        return firstName.isEmpty && lastName.isEmpty ? username
        : lastName.isEmpty ? firstName
        : firstName.isEmpty ? username
        : "\(firstName) \(lastName)"
    }
    
    var avatarURL: URL? {
        return URL(string: avatar)
    }
    
    var countryShown: String {
        return countryTxt.isEmpty || countryTxt == "-"
        ? "Unknown" : countryTxt.capitalized
    }
    
    var isOnline: Bool {
        let dateAfterUnix = Date(timeIntervalSince1970: TimeInterval(self.lastseen))
        let minuteComp = DateComponents(minute: -1)
        guard let onlineDate = Calendar.current.date(byAdding: minuteComp, to: Date()) else {
            Logger.error("getting online date"); return false
        }
        return dateAfterUnix >= onlineDate
    }
    
    // MARK: - Initializer
    init(dict: JSON) {
                
        self.userId = dict.getIntegerFromString(key: .id, defaultValue: 0)
        self.verifiedFinal = dict.getValue(key: .verifiedFinal, defaultValue: false)
        self.age = dict.getValue(key: .age, defaultValue: 18)
        self.profileCompletion = dict.getIntegerFromString(key: .profileCompletion, defaultValue: 0)
        self.avatar = dict.getValue(key: .avater, defaultValue: "")
        
        self.username = dict.getValue(key: .username, defaultValue: "")
        self.email = dict.getValue(key: .email, defaultValue: "")
        self.firstName = dict.getValue(key: .firstName, defaultValue: "")
        self.lastName = dict.getValue(key: .lastName, defaultValue: "")
        self.address = dict.getValue(key: .address, defaultValue: "")
        self.gender = dict.getValue(key: .gender, defaultValue: "")
        self.genderTxt = dict.getValue(key: .genderTxt, defaultValue: "")
        
        self.language = dict.getValue(key: .language, defaultValue: "")
        self.languageTxt = dict.getValue(key: .languageTxt, defaultValue: "")
        self.phoneNumber = dict.getValue(key: .phoneNumber, defaultValue: "")
        self.about = dict.getValue(key: .about, defaultValue: "")
        
        self.birthday = dict.getValue(key: .birthday, defaultValue: "")
        
        self.country = dict.getValue(key: .country, defaultValue: "")
        
        self.countryTxt = dict.getValue(key: .countryTxt, defaultValue: "")
        
        self.lastseen = dict.getIntegerFromString(key: .lastseen, defaultValue: 0)
        self.isPro = dict.getBoolType(with: JSONKeys.isPro.rawValue)
        
        self.isVerified = dict.getBoolType(with: JSONKeys.verified.rawValue)
        
        self.isFavorite = dict.getValue(key: .isFavorite, defaultValue: false)
        self.isLiked = dict.getValue(key: .isLiked, defaultValue: false)
        self.isOwner = dict.getValue(key: .isOwner, defaultValue: false)
        self.isBlocked = dict.getValue(key: .isBlocked, defaultValue: false)

        self.interest = dict.getValue(key: .interest, defaultValue: "")
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

        
        self.profile = ProfileFeatures(from: dict)
        self.favourites = Favourites(from: dict)
        self.mediaFiles = dict.getMediaFileList(with: "mediafiles")
    }
    
    // MARK: - JSONKeys
    /// Provide correct key which is coming from server
    fileprivate enum JSONKeys: String {
        case id
        case verifiedFinal = "verified_final"
        case password, age
        case profileCompletion = "profile_completion"
        case avater
        case username, email
        case firstName = "first_name"
        case lastName = "last_name"
        case address, gender
        case genderTxt = "gender_txt"
        case language
        case languageTxt = "language_txt"
        case lastseen, country, about, birthday
        case isPro = "is_pro"
        case phoneNumber = "phone_number"
        case interest
        case countryTxt = "country_txt"
        case location, verified
        case facebook, google, twitter, linkedin, website, instagram
        case lat, lng
        
        case isOwner = "is_owner"
        case isLiked = "is_liked"
        case isBlocked = "is_blocked"
        case isFavorite = "is_favorite"
        
        }
    
    static func ==(lhs: RandomUser, rhs: RandomUser) -> Bool {
        return lhs.userId == rhs.userId
    }
}

extension JSON {
    
    fileprivate func getIntegerFromString(key: RandomUser.JSONKeys, defaultValue: Int) -> Int {
        guard let numberString = self[key.rawValue] as? String,
              let number = Int(numberString) else {
                  return defaultValue
              }
        return number
    }
    
    fileprivate func getBool(key: RandomUser.JSONKeys, defaultValue: Bool) -> Bool {
        guard let boolString = self[key.rawValue] as? String else {
                  return defaultValue
              }
        return boolString.lowercased() == "true" ? true : false
    }
    
    fileprivate func getValue<T>(key: RandomUser.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
}
