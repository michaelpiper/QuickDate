//
//  NotifierUser.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 21.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Async

/// Pass coordinate values to handle clean code
typealias Coordinate = (latitude: String, longitude: String)

enum AppNotificationType {
    case gotNewMatch
    case visit
    case like
    case dislike
    case friendAccept
    case friendRequest
    case message
    
    init(with rawString: String) {
        switch rawString {
//        case "got_new_match":           self = .gotNewMatch
        case "visit":                   self = .visit
        case "like":                    self = .like
        case "dislike":                 self = .dislike
        case "friend_request_accepted": self = .friendAccept
        case "friend_request":          self = .friendRequest
        case "message":                 self = .message
        default:                        self = .gotNewMatch
        }
    }
    
}

// MARK: - AppNotification

struct AppNotification: Equatable {
    
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    
    let id, notifierID, recipientID: Int
    let type: AppNotificationType
    let seen: Int
    let text: String
    let url: String
    let createdAt: Int
    let notifierUser: UserProfileSettings
    
    // MARK: - Initializer
    init(dict: JSON) {
        self.id = dict.getNotificationValue(key: .id, defaultValue: 0)
        self.notifierID = dict.getNotificationValue(key: .notifierID, defaultValue: 0)
        self.recipientID = dict.getNotificationValue(key: .recipientID, defaultValue: 0)
        
        let typeString = dict.getNotificationValue(key: .type, defaultValue: "")
        self.type = AppNotificationType.init(with: typeString)
        
        self.seen = dict.getNotificationValue(key: .seen, defaultValue: 0)
        self.text = dict.getNotificationValue(key: .text, defaultValue: "")
        self.url = dict.getNotificationValue(key: .url, defaultValue: "")
        self.createdAt = dict.getNotificationValue(key: .createdAt, defaultValue: 0)
        
        let notifierDict = dict.returnNonOptional(with: JSONKeys.notifier.rawValue)
        self.notifierUser = UserProfileSettings(dict: notifierDict)
    }
    
    fileprivate enum JSONKeys: String {
        case id
        case notifierID = "notifier_id"
        case recipientID = "recipient_id"
        case type, seen, text, url
        case createdAt = "created_at"
        case notifier
    }
    
    static func ==(lhs: AppNotification, rhs: AppNotification) -> Bool {
        return lhs.notifierID == rhs.notifierID
    }
}

// MARK: - Notifier
struct NotifierUser {

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
    
    var avatarUrl: URL? {
        return URL(string: avatar)
    }

    // MARK: - Initializer
    init(dict: JSON) {
        self.userId = dict.getIntegerFromString(key: .id, defaultValue: 0)
        self.age = dict.getValue(key: .age, defaultValue: 18)
        self.avatar = dict.getValue(key: .avater, defaultValue: "")
        self.username = dict.getValue(key: .username, defaultValue: "")
        self.email = dict.getValue(key: .email, defaultValue: "")
        self.firstName = dict.getValue(key: .firstName, defaultValue: "")
        self.lastName = dict.getValue(key: .lastName, defaultValue: "")
        self.address = dict.getValue(key: .address, defaultValue: "")

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

        let adminSettings = AppInstance.shared.adminSettings

        let genderKey = dict.getValue(key: .gender, defaultValue: "")
        self.gender = adminSettings?.gender[genderKey] ?? ""

        self.profile = ProfileFeatures(notifierDict: dict)

    }

    fileprivate enum JSONKeys: String {
        case id, username, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avater, address, gender
        case language
        case phoneNumber = "phone_number"
        case about, birthday, country, lastseen, interest
        case isPro = "is_pro"
        case age
        case height
        case hairColor = "hair_color"
        case workStatus = "work_status"
        case education, ethnicity, body, character, children, friends, pets
        case liveWith = "live_with"
        case car, religion, smoke, drink, travel, relationship
        case facebook, google, twitter, linkedin, website, instagram
        case lat, lng

//        case webDeviceID = "web_device_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//        case mobileDeviceID = "mobile_device_id"
//        case webToken = "web_token"
//        case mobileToken = "mobile_token"
//        case height
//        case hairColor = "hair_color"
//        case webTokenCreatedAt = "web_token_created_at"
//        case mobileTokenCreatedAt = "mobile_token_created_at"
//        case webDevice = "web_device"
//        case mobileDevice = "mobile_device"
//        case interest, location
//        case ccPhoneNumber = "cc_phone_number"
//        case zip, state
//        case privacyShowProfileOnGoogle = "privacy_show_profile_on_google"
//        case privacyShowProfileRandomUsers = "privacy_show_profile_random_users"
//        case privacyShowProfileMatchProfiles = "privacy_show_profile_match_profiles"
//        case emailOnProfileView = "email_on_profile_view"
//        case emailOnNewMessage = "email_on_new_message"
//        case emailOnProfileLike = "email_on_profile_like"
//        case emailOnPurchaseNotifications = "email_on_purchase_notifications"
//        case emailOnSpecialOffers = "email_on_special_offers"
//        case emailOnAnnouncements = "email_on_announcements"
//        case phoneVerified = "phone_verified"
//        case online
//        case isBoosted = "is_boosted"
//        case boostedTime = "boosted_time"
//        case isBuyStickers = "is_buy_stickers"
//        case userBuyXvisits = "user_buy_xvisits"
//        case xvisitsCreatedAt = "xvisits_created_at"
//        case userBuyXmatches = "user_buy_xmatches"
//        case xmatchesCreatedAt = "xmatches_created_at"
//        case userBuyXlikes = "user_buy_xlikes"
//        case xlikesCreatedAt = "xlikes_created_at"
//        case showMeTo = "show_me_to"
//        case emailOnGetGift = "email_on_get_gift"
//        case emailOnGotNewMatch = "email_on_got_new_match"
//        case emailOnChatRequest = "email_on_chat_request"
//        case lastEmailSent = "last_email_sent"
//        case approvedAt = "approved_at"
//        case snapshot
//        case hotCount = "hot_count"
//        case spamWarning = "spam_warning"
//        case activationRequestCount = "activation_request_count"
//        case lastActivationRequest = "last_activation_request"
//        case twoFactor = "two_factor"
//        case twoFactorVerified = "two_factor_verified"
//        case twoFactorEmailCode = "two_factor_email_code"
//        case newEmail = "new_email"
//        case newPhone = "new_phone"
//        case permission, referrer
//        case affBalance = "aff_balance"
//        case paypalEmail = "paypal_email"
//        case confirmFollowers = "confirm_followers"
//        case rewardDailyCredit = "reward_daily_credit"
//        case lockProVideo = "lock_pro_video"
//        case lockPrivatePhoto = "lock_private_photo"
//        case conversationID = "conversation_id"
//        case infoFile = "info_file"
//        case paystackRef = "paystack_ref"
//        case securionpayKey = "securionpay_key"
//        case lastseenTxt = "lastseen_txt"
//        case lastseenDate = "lastseen_date"
//        case fullName = "full_name"
    }
}

extension JSON {
    
    fileprivate func getNotificationValue<T>(key: AppNotification.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    
    fileprivate func getIntegerFromString(key: NotifierUser.JSONKeys, defaultValue: Int) -> Int {
        guard let numberString = self[key.rawValue] as? String,
              let number = Int(numberString) else {
                  return defaultValue
              }
        return number
    }
    
    fileprivate func getBool(key: NotifierUser.JSONKeys, defaultValue: Bool) -> Bool {
        guard let boolString = self[key.rawValue] as? String else {
                  return defaultValue
              }
        return boolString.lowercased() == "true" ? true : false
    }
    
    fileprivate func getValue<T>(key: NotifierUser.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    
}
