

import Foundation

struct FavoriteModel:Codable{
    var id: String?
    var verifiedFinal: Bool?
    var fullname, countryTxt, fullPhoneNumber, webToken: String?
    var password: String?
    var age, profileCompletion: Int?
    var profileCompletionMissing: [String]?
    var avater: String?
    var fullName, username, email, firstName: String?
    var lastName, address, gender: String?
    var genderTxt: String?
    var facebook, google: String?
    var twitter, linkedin: String?
    var website: String?
    var instagram: String?
    var webDeviceID: String?
    var language: String?
    var languageTxt: String?
    var emailCode: String?
    var src: String?
    var ipAddress: String?
    var type: String?
    var phoneNumber: String?
    var timezone: String?
    var lat, lng: String?
    var about: String?
    var birthday, country, registered, lastseen: String?
    var smscode, proTime, lastLocationUpdate, balance: String?
    var verified, status, active, admin: String?
    var startUp, isPro, proType, socialLogin: String?
    var createdAt, updatedAt, deletedAt, mobileDeviceID: String?
    var mobileToken, height, heightTxt, hairColor: String?
    var hairColorTxt, webTokenCreatedAt, mobileTokenCreatedAt, mobileDevice: String?
    var interest: String?
    var location: String?
    var relationship: String?
    var relationshipTxt: String?
    var workStatus: String?
    var workStatusTxt: String?
    var education: String?
    var educationTxt: String?
    var ethnicity: String?
    var ethnicityTxt: String?
    let body: String?
    let bodyTxt: String?
    let character: String?
    let characterTxt: String?
    let children: String?
    let childrenTxt: String?
    let friends: String?
    let friendsTxt: String?
    let pets: String?
    let petsTxt: String?
    let liveWith: String?
    let liveWithTxt: String?
    let car: String?
    let carTxt: String?
    let religion: String?
    let religionTxt: String?
    let smoke: String?
    let smokeTxt: String?
    let drink: String?
    let drinkTxt: String?
    let travel: String?
    let travelTxt: String?
    let music, dish, song, hobby: String?
    let city, sport, book, movie: String?
    let colour, tv, privacyShowProfileOnGoogle, privacyShowProfileRandomUsers: String?
    let privacyShowProfileMatchProfiles, emailOnProfileView, emailOnNewMessage, emailOnProfileLike: String?
    let emailOnPurchaseNotifications, emailOnSpecialOffers, emailOnAnnouncements, phoneVerified: String?
    let online, isBoosted, boostedTime, isBuyStickers: String?
    let userBuyXvisits, xvisitsCreatedAt, userBuyXmatches, xmatchesCreatedAt: String?
    let userBuyXlikes, xlikesCreatedAt, showMeTo, emailOnGetGift: String?
    let emailOnGotNewMatch, emailOnChatRequest, lastEmailSent, approvedAt: String?
    let snapshot: String?
    let hotCount, spamWarning, activationRequestCount, lastActivationRequest: String?
    let lastseenTxt: String?
    let mediafiles: [Mediafile]?
}
struct Mediafile:Codable {
    var id: Int?
    var full, avater: String?
    var isPrivate: Int?
    var privateFileFull, privateFileAvater: String?  
}

class AddFavoriteModel:BaseModel{
    struct AddFavoriteSuccessModel: Codable {
        let AddFavoriteModel: Int?
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
class FetchFavoriteModel:BaseModel{
    
    struct FetchFavoriteSuccessModel: Codable {
        let status: Int?
        let data: [Datum]?
        let errors: Errors?
        let message: String?
    }

    // MARK: - Datum
    struct Datum: Codable {
        let id, userID, favUserID, createdAt: Int?
        let userData: UserData?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case favUserID = "fav_user_id"
            case createdAt = "created_at"
            case userData
        }
    }

    // MARK: - UserData
    struct UserData: Codable {
        let id: String?
        let verifiedFinal: Bool?
        let fullname, countryTxt, password: String?
        let age, profileCompletion: Int?
        let profileCompletionMissing: [String]?
        let avater: String?
        let fullName, username, email, firstName: String?
        let lastName, address, gender, genderTxt: String?
        let facebook, google, twitter, linkedin: String?
        let website, instagram, webDeviceID, language: String?
        let languageTxt, emailCode, src, ipAddress: String?
        let type, phoneNumber, timezone, lat: String?
        let lng, about, birthday, country: String?
        let registered, lastseen, smscode, proTime: String?
        let lastLocationUpdate, balance, verified, status: String?
        let active, admin, startUp, isPro: String?
        let proType, socialLogin, createdAt, updatedAt: String?
        let deletedAt, mobileDeviceID, webToken, mobileToken: String?
        let height, heightTxt, hairColor, hairColorTxt: String?
        let webTokenCreatedAt, mobileTokenCreatedAt, mobileDevice, interest: String?
        let location, relationship, relationshipTxt, workStatus: String?
        let workStatusTxt, education, educationTxt, ethnicity: String?
        let ethnicityTxt, body, bodyTxt, character: String?
        let characterTxt, children, childrenTxt, friends: String?
        let friendsTxt, pets, petsTxt, liveWith: String?
        let liveWithTxt, car, carTxt, religion: String?
        let religionTxt, smoke, smokeTxt, drink: String?
        let drinkTxt, travel, travelTxt, music: String?
        let dish, song, hobby, city: String?
        let sport, book, movie, colour: String?
        let tv, privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles: String?
        let emailOnProfileView, emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications: String?
        let emailOnSpecialOffers, emailOnAnnouncements, phoneVerified, online: String?
        let isBoosted, boostedTime, isBuyStickers, userBuyXvisits: String?
        let xvisitsCreatedAt, userBuyXmatches, xmatchesCreatedAt, userBuyXlikes: String?
        let xlikesCreatedAt, showMeTo, emailOnGetGift, emailOnGotNewMatch: String?
        let emailOnChatRequest, lastEmailSent, approvedAt, snapshot: String?
        let hotCount, spamWarning, activationRequestCount, lastActivationRequest: String?
        let twoFactor, twoFactorVerified, twoFactorEmailCode, newEmail: String?
        let newPhone, permission, referrer, affBalance: String?
        let paypalEmail, confirmFollowers, rewardDailyCredit, lockProVideo: String?
        let lockPrivatePhoto, lastseenTxt: String?
        let lastseenDate: String?
        let mediafiles: [Mediafile]?

        enum CodingKeys: String, CodingKey {
            case id
            case verifiedFinal = "verified_final"
            case fullname
            case countryTxt = "country_txt"
            case password, age
            case profileCompletion = "profile_completion"
            case profileCompletionMissing = "profile_completion_missing"
            case avater
            case fullName = "full_name"
            case username, email
            case firstName = "first_name"
            case lastName = "last_name"
            case address, gender
            case genderTxt = "gender_txt"
            case facebook, google, twitter, linkedin, website, instagram
            case webDeviceID = "web_device_id"
            case language
            case languageTxt = "language_txt"
            case emailCode = "email_code"
            case src
            case ipAddress = "ip_address"
            case type
            case phoneNumber = "phone_number"
            case timezone, lat, lng, about, birthday, country, registered, lastseen, smscode
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
            case heightTxt = "height_txt"
            case hairColor = "hair_color"
            case hairColorTxt = "hair_color_txt"
            case webTokenCreatedAt = "web_token_created_at"
            case mobileTokenCreatedAt = "mobile_token_created_at"
            case mobileDevice = "mobile_device"
            case interest, location, relationship
            case relationshipTxt = "relationship_txt"
            case workStatus = "work_status"
            case workStatusTxt = "work_status_txt"
            case education
            case educationTxt = "education_txt"
            case ethnicity
            case ethnicityTxt = "ethnicity_txt"
            case body
            case bodyTxt = "body_txt"
            case character
            case characterTxt = "character_txt"
            case children
            case childrenTxt = "children_txt"
            case friends
            case friendsTxt = "friends_txt"
            case pets
            case petsTxt = "pets_txt"
            case liveWith = "live_with"
            case liveWithTxt = "live_with_txt"
            case car
            case carTxt = "car_txt"
            case religion
            case religionTxt = "religion_txt"
            case smoke
            case smokeTxt = "smoke_txt"
            case drink
            case drinkTxt = "drink_txt"
            case travel
            case travelTxt = "travel_txt"
            case music, dish, song, hobby, city, sport, book, movie, colour, tv
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
            case twoFactor = "two_factor"
            case twoFactorVerified = "two_factor_verified"
            case twoFactorEmailCode = "two_factor_email_code"
            case newEmail = "new_email"
            case newPhone = "new_phone"
            case permission, referrer
            case affBalance = "aff_balance"
            case paypalEmail = "paypal_email"
            case confirmFollowers = "confirm_followers"
            case rewardDailyCredit = "reward_daily_credit"
            case lockProVideo = "lock_pro_video"
            case lockPrivatePhoto = "lock_private_photo"
            case lastseenTxt = "lastseen_txt"
            case lastseenDate = "lastseen_date"
            case mediafiles
        }
    }

    // MARK: - Mediafile
    struct Mediafile: Codable {
        let id: Int?
        let full, avater: String?
        let isPrivate: Int?
        let privateFileFull, privateFileAvater: String?
        let isVideo: Int?
        let videoFile: String?
        let isConfirmed, isApproved: Int?

        enum CodingKeys: String, CodingKey {
            case id, full, avater
            case isPrivate = "is_private"
            case privateFileFull = "private_file_full"
            case privateFileAvater = "private_file_avater"
            case isVideo = "is_video"
            case videoFile = "video_file"
            case isConfirmed = "is_confirmed"
            case isApproved = "is_approved"
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
