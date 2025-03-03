//
//  OtherUser+Enum.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 21.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import GoogleMaps
//import GooglePlaces
import CoreLocation

enum OtherUser {
    case randomUser(UserProfileSettings)
    case notifier(UserProfileSettings)
    case userProfile(UserProfileSettings)

    var shallNotify: Bool {
        switch self {
        case .randomUser(_):  return false
        case .notifier(_):    return true
        case .userProfile(_): return false
        }
    }
    
    var mediaFiles: [MediaFile] {
        switch self {
        case .randomUser(let randomUser): return randomUser.mediafiles
        case .notifier(let notifierUser): return notifierUser.mediafiles
        case .userProfile(let profile):   return profile.mediafiles
        }
    }
    
    var userDetails: UserProfileSettings {
        switch self {
        case .randomUser(let user):
            let social = SocialMedia(
                google: user.google, facebook: user.facebook, instagram: user.instagram, webSite: user.website, linkedin: user.linkedin, twitter: user.twitter)
            
            let countryText = fetchCountry(with: user.country)
            
            return user/*UserDetailFeatures(
                userName: user.username,
                fullName: user.full_name,
                avatar: user.avatar,
                isFavorite: user.is_favorite,
                id: user.id,
                lastseen: user.lastseen,
                about: user.about,
                country: countryText,
                interest: user.interest,
                mediaFileList: user.mediafiles,
                profile: user.profile,
                socialMedia: social,
                favourites: user.favourites,
                coordinate: user.coordinate
            )*/
            
        case .notifier(let notifierUser):
            let social = SocialMedia(
                google: notifierUser.google, facebook: notifierUser.facebook,
                instagram: notifierUser.instagram, webSite: notifierUser.website, linkedin: notifierUser.linkedin, twitter: notifierUser.twitter)
            
            let countryText = fetchCountry(with: notifierUser.country)
            
            return notifierUser/*UserDetailFeatures(
                userName: user.username,
                fullName: user.full_name,
                avatar: user.avatar,
                isFavorite: user.is_favorite,
                id: user.id,
                lastseen: user.lastseen,
                about: user.about,
                country: countryText,
                interest: user.interest,
                mediaFileList: user.mediafiles,
                profile: user.profile,
                socialMedia: social,
                favourites: user.favourites,
                coordinate: user.coordinate
            )*/
            
        case .userProfile(let user):
            let social = SocialMedia(
                google: user.google, facebook: user.facebook, instagram: user.instagram, webSite: user.website, linkedin: user.linkedin, twitter: user.twitter)
            
            let countryText = fetchCountry(with: user.country)
            
            return user/*UserDetailFeatures(
                userName: user.username,
                fullName: user.full_name,
                avatar: user.avatar,
                isFavorite: user.is_favorite,
                id: user.id,
                lastseen: user.lastseen,
                about: user.about,
                country: countryText,
                interest: user.interest,
                mediaFileList: user.mediafiles,
                profile: user.profile,
                socialMedia: social,
                favourites: user.favourites,
                coordinate: user.coordinate
            )*/
        }
    }
}

extension OtherUser {
    
    private func fetchCountry(with countryCode: String) -> String? {
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
            Logger.error("getting path"); return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(Countries.self, from: data)
            let country = result.countries.filter { $0.code == countryCode }.first
            return country?.name
        } catch {
            Logger.error(error)
            return nil
        }
    }
}

// MARK: - Countries
struct Countries: Codable {
    let countries: [Country]
}

// MARK: - Country
struct Country: Codable {
    let code, name, letter: String
}
