//
//  LikeDislikeModel.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
class LikeDislikeModel:BaseModel{
    struct LikeDislikeSuccessModel: Codable {
        var status: Int?
        var data: [Datum]?
    }

    // MARK: - Datum
    struct Datum: Codable {
        var id, online, lastseen: Int?
        var username, avater, country, firstName: String?
        var lastName: String?
        var location: String?
        var birthday: String?
        var language: String?
        var relationship: Int?
        var height: String?
        var body, smoke, ethnicity, pets: Int?
        var createdAt: String?
        var userData: UserData?

        enum CodingKeys: String, CodingKey {
            case id, online, lastseen, username, avater, country
            case firstName = "first_name"
            case lastName = "last_name"
            case location, birthday, language, relationship, height, body, smoke, ethnicity, pets
            case createdAt = "created_at"
            case userData
        }
    }

    enum Language: String, Codable {
        case arabic = "arabic"
        case english = "english"
    }

    // MARK: - UserData
    struct UserData: Codable {
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
        var facebook: String?
        var google: String?
        var twitter: String?
        var linkedin: String?
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
        var location, relationship: String?
        var relationshipTxt: String?
        var workStatus: String?
        var workStatusTxt: String?
        var education: String?
        var educationTxt: String?
        var ethnicity: String?
        var ethnicityTxt: String?
        var body: String?
        var bodyTxt: String?
        var character: String?
        var characterTxt: String?
        var children: String?
        var childrenTxt: String?
        var friends: String?
        var friendsTxt: String?
        var pets: String?
        var liveWith: String?
        var liveWithTxt: String?
        var car: String?
        var carTxt: String?
        var religion: String?
        var religionTxt: String?
        var smoke: String?
        var smokeTxt: String?
        var drink: String?
        var drinkTxt: String?
        var travel: String?
        var travelTxt: String?
        var music: String?
        var dish: String?
        var song: String?
        var hobby: String?
        var city: String?
        var sport: String?
        var book: String?
        var movie: String?
        var colour: String?
        var tv: String?
        var privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: String?
        var emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: String?
        var emailOnAnnouncements, phoneVerified, online, isBoosted: String?
        var boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: String?
        var userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: String?
        var showMeTo: String?
        var emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest, lastEmailSent: String?
        var approvedAt, snapshot, hotCount, spamWarning: String?
        var activationRequestCount, lastActivationRequest, twoFactor, twoFactorVerified: String?
        var twoFactorEmailCode, newEmail, newPhone, permission: String?
        var referrer, affBalance, paypalEmail, confirmFollowers: String?
        var lastseenTxt: String?
        var lastseenDate: String?
        var mediafiles: [Mediafile]?

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
            case lastseenTxt = "lastseen_txt"
            case lastseenDate = "lastseen_date"
            case mediafiles
        }
    }

    enum About: String, Codable {
        case empty = ""
        case getToKnowMeI039MKindaCool = "Get to know me i&#039;m kinda cool (:"
        case sfddsaSddsdsfGrrg = "SFDDSA  SDDSDSF  GRRG"
    }

    enum BodyTxt: String, Codable {
        case curvy = "Curvy"
        case empty = ""
    }

    enum Book: String, Codable {
        case empty = ""
        case theSecrit = "the secrit"
    }

    enum Txt: String, Codable {
        case empty = ""
        case myOwnCar = "My own car"
        case none = "None"
    }

    enum CharacterTxt: String, Codable {
        case careless = "Careless"
        case empty = ""
        case generous = "Generous"
        case honest = "Honest"
    }

    enum ChildrenTxt: String, Codable {
        case empty = ""
        case expecting = "Expecting"
        case noNever = "No, never"
    }

    enum City: String, Codable {
        case empty = ""
        case turkey = "Turkey"
    }

    enum Colour: String, Codable {
        case empty = ""
        case redAndBlue = "Red and Blue"
    }

    enum Dish: String, Codable {
        case empty = ""
        case qwe = "qwe"
    }

    enum DrinkTxt: String, Codable {
        case empty = ""
        case never = "Never"
    }

    enum EducationTxt: String, Codable {
        case advancedDegree = "Advanced degree"
        case empty = ""
    }

    enum EthnicityTxt: String, Codable {
        case empty = ""
        case middleEastern = "Middle Eastern"
        case northAfrican = "North African"
        case white = "White"
    }

    enum Facebook: String, Codable {
        case empty = ""
        case the3Reebills = "3reebills"
        case waelAn123 = "wael.an123"
    }

    enum FriendsTxt: String, Codable {
        case empty = ""
        case manyFriends = "Many friends"
        case onlyGoodFriends = "Only good friends"
    }

    enum GenderTxt: String, Codable {
        case empty = ""
        case female = "Female"
        case male = "Male"
    }

    enum Google: String, Codable {
        case empty = ""
        case saraSoso = "SaraSoso"
    }

    enum Hobby: String, Codable {
        case empty = ""
        case love = "love"
    }

    enum Instagram: String, Codable {
        case empty = ""
        case mhwaelAdiga = "mhwael_adiga"
    }

    enum Interest: String, Codable {
        case empty = ""
        case matrixLoveMan = "matrix ,Love,Man,"
    }

    enum LanguageTxt: String, Codable {
        case arabic = "Arabic"
        case english = "English"
    }

    enum Linkedin: String, Codable {
        case empty = ""
        case mhWaelAn855893115 = "mh-wael-an-855893115"
    }

    enum LiveWithTxt: String, Codable {
        case alone = "Alone"
        case empty = ""
        case friends = "Friends"
    }

    // MARK: - Mediafile
    struct Mediafile: Codable {
        var id: Int?
        var full, avater: String?
        var isPrivate: Int?
        var privateFileFull, privateFileAvater: String?
        var isVideo: Int?
        var videoFile: String?
        var isConfirmed, isApproved: Int?

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

    enum Movie: String, Codable {
        case action = "action"
        case empty = ""
    }

    enum Music: String, Codable {
        case empty = ""
        case romance = "Romance"
    }

    enum Password: String, Codable {
        case empty = "**********************"
    }

    enum RelationshipTxt: String, Codable {
        case empty = ""
        case married = "Married"
        case single = "Single"
    }

    enum ReligionTxt: String, Codable {
        case catholic = "Catholic"
        case empty = ""
        case muslim = "Muslim"
    }

    enum ShowMeTo: String, Codable {
        case empty = ""
        case kz = "KZ"
        case tj = "TJ"
        case tr = "TR"
    }

    enum SmokeTxt: String, Codable {
        case empty = ""
        case iSmokeSometimes = "I smoke sometimes"
    }

    enum Song: String, Codable {
        case asd = "asd"
        case empty = ""
    }

    enum Sport: String, Codable {
        case empty = ""
        case swimming = "Swimming"
    }

    enum Src: String, Codable {
        case facebook = "Facebook"
        case site = "site"
        case wowonder = "wowonder"
    }

    enum Timezone: String, Codable {
        case utc = "UTC"
    }

    enum TravelTxt: String, Codable {
        case empty = ""
        case yesSometimes = "Yes, sometimes"
    }

    enum Tv: String, Codable {
        case empty = ""
        case mtv = "MTV"
    }

    enum Twitter: String, Codable {
        case empty = ""
        case engWaelAnjo = "Eng_Wael_Anjo"
    }

    enum TypeEnum: String, Codable {
        case user = "user"
    }

    enum WorkStatusTxt: String, Codable {
        case empty = ""
        case i039MWorking = "I&#039;m working"
        case selfEmployed = "Self-Employed"
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
class LikeDislikeDeleteModel:BaseModel{


    // MARK: - Welcome
    struct LikeDislikeDeleteSuccessModel: Codable {
        var message: String?
        var code: Int?
        var data: [JSONAny]?
    }

    // MARK: - Errors
    struct Errors: Codable {
        var errorID, errorText: String?

        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
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

    class JSONCodingKey: CodingKey {
        let key: String

        required init?(intValue: Int) {
            return nil
        }

        required init?(stringValue: String) {
            key = stringValue
        }

        var intValue: Int? {
            return nil
        }

        var stringValue: String {
            return key
        }
    }

    class JSONAny: Codable {

        let value: Any

        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }

        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }

        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }

        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }

        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }

        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }

        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }

        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }

        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }

        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }

        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }

        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }

}
