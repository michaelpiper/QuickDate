

import Foundation

class NotificationModel:BaseModel{
    struct NotificationSuccessModel: Codable {
        let code: Int?
        let data: [Datum]?
        let newNotificationCount, newMessagesCount: Int?
        let message: String?
        
        enum CodingKeys: String, CodingKey {
            case code, data
            case newNotificationCount = "new_notification_count"
            case newMessagesCount = "new_messages_count"
            case  message
        }
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id, notifierID, recipientID: Int?
        let type: String?
        let seen: Int?
        let text, url: String?
        let createdAt: Int?
        let notifier: Notifier?
        
        enum CodingKeys: String, CodingKey {
            case id
            case notifierID = "notifier_id"
            case recipientID = "recipient_id"
            case type, seen, text, url
            case createdAt = "created_at"
            case notifier
        }
    }
    
    // MARK: - Notifier
    struct Notifier: Codable {
        let id: Int?
        let username, email, firstName, lastName: String?
        let avater: String?
        let address, gender, facebook, google: String?
        let twitter, linkedin, website, instagram: String?
        let webDeviceID, language, src, ipAddress: String?
        let type, phoneNumber, timezone, lat: String?
        let lng, about, birthday, country: String?
        let registered, lastseen, proTime, lastLocationUpdate: Int?
        let balance, verified, status, active: String?
        let admin, startUp, isPro, proType: String?
        let socialLogin, createdAt, updatedAt, deletedAt: String?
        let mobileDeviceID, webToken, mobileToken, height: String?
        let hairColor: String?
        let webTokenCreatedAt, mobileTokenCreatedAt: Int?
        let webDevice, mobileDevice, interest, location: String?
        let relationship, workStatus, education, ethnicity: Int?
        let body, character, children, friends: Int?
        let pets, liveWith, car, religion: Int?
        let smoke, drink, travel: Int?
        let music, dish, song, hobby: String?
        let city, sport, book, movie: String?
        let colour, tv: String?
        let privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: Int?
        let emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: Int?
        let emailOnAnnouncements, phoneVerified, online, isBoosted: Int?
        let boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: Int?
        let userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: Int?
        let showMeTo: String?
        let emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest, lastEmailSent: Int?
        let approvedAt: Int?
        let snapshot: String?
        let hotCount, spamWarning, activationRequestCount, lastActivationRequest: Int?
        let age: Int?
        let lastseenTxt: String?

        enum CodingKeys: String, CodingKey {
            case id, username, email
            case firstName = "first_name"
            case lastName = "last_name"
            case avater, address, gender, facebook, google, twitter, linkedin, website, instagram
            case webDeviceID = "web_device_id"
            case language, src
            case ipAddress = "ip_address"
            case type
            case phoneNumber = "phone_number"
            case timezone, lat, lng, about, birthday, country, registered, lastseen
            case proTime = "pro_time"
            case lastLocationUpdate = "last_location_update"
            case balance, verified, status, active, admin
            case startUp = "start_up"
            case isPro = "is_pro"
            case proType = "pro_type"
            case socialLogin = "social_login"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case mobileDeviceID = "mobile_device_id"
            case webToken = "web_token"
            case mobileToken = "mobile_token"
            case height
            case hairColor = "hair_color"
            case webTokenCreatedAt = "web_token_created_at"
            case mobileTokenCreatedAt = "mobile_token_created_at"
            case webDevice = "web_device"
            case mobileDevice = "mobile_device"
            case interest, location, relationship
            case workStatus = "work_status"
            case education, ethnicity, body, character, children, friends, pets
            case liveWith = "live_with"
            case car, religion, smoke, drink, travel, music, dish, song, hobby, city, sport, book, movie, colour, tv
            case privacyShowProfileOnGoogle = "privacy_show_profile_on_google"
            case privacyShowProfileRandomUsers = "privacy_show_profile_random_users"
            case privacyShowProfileMatchProfiles = "privacy_show_profile_match_profiles"
            case emailOnProfileView = "email_on_profile_view"
            case emailOnNewMessage = "email_on_new_message"
            case emailOnProfileLike = "email_on_profile_like"
            case emailOnPurchaseNotifications = "email_on_purchase_notifications"
            case emailOnSpecialOffers = "email_on_special_offers"
            case emailOnAnnouncements = "email_on_announcements"
            case phoneVerified = "phone_verified"
            case online
            case isBoosted = "is_boosted"
            case boostedTime = "boosted_time"
            case isBuyStickers = "is_buy_stickers"
            case userBuyXvisits = "user_buy_xvisits"
            case xvisitsCreatedAt = "xvisits_created_at"
            case userBuyXmatches = "user_buy_xmatches"
            case xmatchesCreatedAt = "xmatches_created_at"
            case userBuyXlikes = "user_buy_xlikes"
            case xlikesCreatedAt = "xlikes_created_at"
            case showMeTo = "show_me_to"
            case emailOnGetGift = "email_on_get_gift"
            case emailOnGotNewMatch = "email_on_got_new_match"
            case emailOnChatRequest = "email_on_chat_request"
            case lastEmailSent = "last_email_sent"
            case approvedAt = "approved_at"
            case snapshot
            case hotCount = "hot_count"
            case spamWarning = "spam_warning"
            case activationRequestCount = "activation_request_count"
            case lastActivationRequest = "last_activation_request"
            case age
            case lastseenTxt = "lastseen_txt"
        }
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
