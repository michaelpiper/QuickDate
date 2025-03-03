

import Foundation
class TrendingModel:BaseModel{
    struct TrendingSuccessModel: Codable {
        let data: [Datum]?
        let message: String?
        let code: Int?
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id: String?
        let verifiedFinal: Bool?
        let fullname, countryTxt, fullPhoneNumber, webToken: String?
        let password: String?
        let age, profileCompletion: Int?
        let profileCompletionMissing: [String]?
        let avater: String?
        let fullName, username, email, firstName: String?
        let lastName, address, gender: String?
        let genderTxt: String?
        let facebook, google: String?
        let twitter, linkedin: String?
        let website: String?
        let instagram: String?
        let webDeviceID: String?
        let language: String?
        let languageTxt: String?
        let emailCode: String?
        let src: String?
        let ipAddress: String?
        let type: String?
        let phoneNumber: String?
        let timezone: String?
        let lat, lng: String?
        let about: String?
        let birthday, country, registered, lastseen: String?
        let smscode, proTime, lastLocationUpdate, balance: String?
        let verified, status, active, admin: String?
        let startUp, isPro, proType, socialLogin: String?
        let createdAt, updatedAt, deletedAt, mobileDeviceID: String?
        let mobileToken, height, heightTxt, hairColor: String?
        let hairColorTxt, webTokenCreatedAt, mobileTokenCreatedAt, mobileDevice: String?
        let interest: String?
        let location: String?
        let relationship: String?
        let relationshipTxt: String?
        let workStatus: String?
        let workStatusTxt: String?
        let education: String?
        let educationTxt: String?
        let ethnicity: String?
        let ethnicityTxt: String?
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
        
        enum CodingKeys: String, CodingKey {
            case id
            case verifiedFinal = "verified_final"
            case fullname
            case countryTxt = "country_txt"
            case fullPhoneNumber = "full_phone_number"
            case webToken = "web_token"
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
            case lastseenTxt = "lastseen_txt"
            case mediafiles
        }
    }
    
   
    
    // MARK: - Mediafile
    struct Mediafile: Codable {
        let id: Int?
        let full, avater: String?
        let isPrivate: Int?
        let privateFileFull, privateFileAvater: String?
        
        enum CodingKeys: String, CodingKey {
            case id, full, avater
            case isPrivate = "is_private"
            case privateFileFull = "private_file_full"
            case privateFileAvater = "private_file_avater"
        }
    }
    
   
  
    enum ID: Codable {
        case integer(Int)
        case string(String)
        
        var stringValue : String? {
            guard case let .string(value) = self else { return nil }
            return value
        }
        
        var intValue : Int? {
            guard case let .integer(value) = self else { return nil }
            return value
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Int.self) {
                self = .integer(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            throw DecodingError.typeMismatch(ID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CountViews"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .integer(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
