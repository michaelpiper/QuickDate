//
//  UserDetailFeatures.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 25.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// Create for handling clean code and execute DRY Principle
struct UserDetailFeatures {
    let userName: String
    let fullName: String
    let avatar: String
    let isFavorite: Bool?
    let id: String
    let lastseen: String
    let about: String
    let country: String?
    let interest: String
    let mediaFileList: [MediaFile]
    
    let profile: ProfileFeatures
    let socialMedia: SocialMedia
    let favourites: Favourites
    let coordinate: Coordinate
}

struct SocialMedia {
    let google, facebook, instagram, webSite, linkedin, twitter: String
}
