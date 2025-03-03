
import Foundation
import UIKit
//class LoginModel:BaseModel{
//
//    // MARK: - Welcome
//    struct LoginSuccessModel: Codable {
//        let message: String?
//        let code: Int?
//        let data: DataClass?
//    }
//    
//    // MARK: - DataClass
//    struct DataClass: Codable {
//        let userID: Int?
//        let accessToken: String?
//        let userInfo: UserInfo?
//        
//        enum CodingKeys: String, CodingKey {
//            case userID = "user_id"
//            case accessToken = "access_token"
//            case userInfo = "user_info"
//        }
//    }
//    
//    // MARK: - UserInfo
//    struct UserInfo: Codable {
//        let verifiedFinal: Bool?
//        let fullname, countryTxt: String?
//        let age, profileCompletion: Int?
//        let profileCompletionMissing: [String]?
//        let fullName, username, email, firstName: String?
//        let lastName, address, gender, genderTxt: String?
//        let facebook, google, twitter, linkedin: String?
//        let website, instagram, webDeviceID, language: String?
//        let languageTxt, emailCode, src, ipAddress: String?
//        let type, phoneNumber, timezone, lat: String?
//        let lng, about, birthday, country: String?
//        let registered, lastseen, smscode, proTime: String?
//        let lastLocationUpdate, balance, verified, status: String?
//        let active, admin, startUp, isPro: String?
//        let proType, socialLogin, createdAt, updatedAt: String?
//        let deletedAt, mobileDeviceID, mobileToken, height: String?
//        let heightTxt, hairColor, hairColorTxt, webTokenCreatedAt: String?
//        let mobileTokenCreatedAt, mobileDevice, interest, location: String?
//        let relationship, relationshipTxt, workStatus, workStatusTxt: String?
//        let education, educationTxt, ethnicity, ethnicityTxt: String?
//        let body, bodyTxt, character, characterTxt: String?
//        let children, childrenTxt, friends, friendsTxt: String?
//        let pets, petsTxt, liveWith, liveWithTxt: String?
//        let car, carTxt, religion, religionTxt: String?
//        let smoke, smokeTxt, drink, drinkTxt: String?
//        let travel, travelTxt, music, dish: String?
//        let song, hobby, city, sport: String?
//        let book, movie, colour, tv: String?
//        let privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: String?
//        let emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: String?
//        let emailOnAnnouncements, phoneVerified, online, isBoosted: String?
//        let boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: String?
//        let userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: String?
//        let showMeTo, emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest: String?
//        let lastEmailSent, approvedAt, snapshot, hotCount: String?
//        let spamWarning, activationRequestCount, lastActivationRequest, lastseenTxt: String?
//        let mediafiles: [JSONAny]?
//       
//        enum CodingKeys: String, CodingKey {
//            case verifiedFinal = "verified_final"
//            case fullname
//            case countryTxt = "country_txt"
//            case age
//            case profileCompletion = "profile_completion"
//            case profileCompletionMissing = "profile_completion_missing"
//            case fullName = "full_name"
//            case username, email
//            case firstName = "first_name"
//            case lastName = "last_name"
//            case address, gender
//            case genderTxt = "gender_txt"
//            case facebook, google, twitter, linkedin, website, instagram
//            case webDeviceID = "web_device_id"
//            case language
//            case languageTxt = "language_txt"
//            case emailCode = "email_code"
//            case src
//            case ipAddress = "ip_address"
//            case type
//            case phoneNumber = "phone_number"
//            case timezone, lat, lng, about, birthday, country, registered, lastseen, smscode
//            case proTime = "pro_time"
//            case lastLocationUpdate = "last_location_update"
//            case balance, verified, status, active, admin
//            case startUp = "start_up"
//            case isPro = "is_pro"
//            case proType = "pro_type"
//            case socialLogin = "social_login"
//            case createdAt = "created_at"
//            case updatedAt = "updated_at"
//            case deletedAt = "deleted_at"
//            case mobileDeviceID = "mobile_device_id"
//            case mobileToken = "mobile_token"
//            case height
//            case heightTxt = "height_txt"
//            case hairColor = "hair_color"
//            case hairColorTxt = "hair_color_txt"
//            case webTokenCreatedAt = "web_token_created_at"
//            case mobileTokenCreatedAt = "mobile_token_created_at"
//            case mobileDevice = "mobile_device"
//            case interest, location, relationship
//            case relationshipTxt = "relationship_txt"
//            case workStatus = "work_status"
//            case workStatusTxt = "work_status_txt"
//            case education
//            case educationTxt = "education_txt"
//            case ethnicity
//            case ethnicityTxt = "ethnicity_txt"
//            case body
//            case bodyTxt = "body_txt"
//            case character
//            case characterTxt = "character_txt"
//            case children
//            case childrenTxt = "children_txt"
//            case friends
//            case friendsTxt = "friends_txt"
//            case pets
//            case petsTxt = "pets_txt"
//            case liveWith = "live_with"
//            case liveWithTxt = "live_with_txt"
//            case car
//            case carTxt = "car_txt"
//            case religion
//            case religionTxt = "religion_txt"
//            case smoke
//            case smokeTxt = "smoke_txt"
//            case drink
//            case drinkTxt = "drink_txt"
//            case travel
//            case travelTxt = "travel_txt"
//            case music, dish, song, hobby, city, sport, book, movie, colour, tv
//            case privacyShowProfileOnGoogle = "privacy_show_profile_on_google"
//            case privacyShowProfileRandomUsers = "privacy_show_profile_random_users"
//            case privacyShowProfileMatchProfiles = "privacy_show_profile_match_profiles"
//            case emailOnProfileView = "email_on_profile_view"
//            case emailOnNewMessage = "email_on_new_message"
//            case emailOnProfileLike = "email_on_profile_like"
//            case emailOnPurchaseNotifications = "email_on_purchase_notifications"
//            case emailOnSpecialOffers = "email_on_special_offers"
//            case emailOnAnnouncements = "email_on_announcements"
//            case phoneVerified = "phone_verified"
//            case online
//            case isBoosted = "is_boosted"
//            case boostedTime = "boosted_time"
//            case isBuyStickers = "is_buy_stickers"
//            case userBuyXvisits = "user_buy_xvisits"
//            case xvisitsCreatedAt = "xvisits_created_at"
//            case userBuyXmatches = "user_buy_xmatches"
//            case xmatchesCreatedAt = "xmatches_created_at"
//            case userBuyXlikes = "user_buy_xlikes"
//            case xlikesCreatedAt = "xlikes_created_at"
//            case showMeTo = "show_me_to"
//            case emailOnGetGift = "email_on_get_gift"
//            case emailOnGotNewMatch = "email_on_got_new_match"
//            case emailOnChatRequest = "email_on_chat_request"
//            case lastEmailSent = "last_email_sent"
//            case approvedAt = "approved_at"
//            case snapshot
//            case hotCount = "hot_count"
//            case spamWarning = "spam_warning"
//            case activationRequestCount = "activation_request_count"
//            case lastActivationRequest = "last_activation_request"
//            case lastseenTxt = "lastseen_txt"
//           
//            
//            case mediafiles
//        }
//    }
//    
//    // MARK: - Errors
//    struct Errors: Codable {
//        let errorID, errorText: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case errorID = "error_id"
//            case errorText = "error_text"
//        }
//    }
//    
//    // MARK: - Encode/decode helpers
//    
//    class JSONNull: Codable, Hashable {
//        
//        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//        }
//        
//        public var hashValue: Int {
//            return 0
//        }
//        
//        public init() {}
//        
//        public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//        }
//        
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//        }
//    }
//    
//    class JSONCodingKey: CodingKey {
//        let key: String
//        
//        required init?(intValue: Int) {
//            return nil
//        }
//        
//        required init?(stringValue: String) {
//            key = stringValue
//        }
//        
//        var intValue: Int? {
//            return nil
//        }
//        
//        var stringValue: String {
//            return key
//        }
//    }
//    
//    class JSONAny: Codable {
//        
//        let value: Any
//        
//        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//            return DecodingError.typeMismatch(JSONAny.self, context)
//        }
//        
//        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//            return EncodingError.invalidValue(value, context)
//        }
//        
//        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//            if let value = try? container.decode(Bool.self) {
//                return value
//            }
//            if let value = try? container.decode(Int64.self) {
//                return value
//            }
//            if let value = try? container.decode(Double.self) {
//                return value
//            }
//            if let value = try? container.decode(String.self) {
//                return value
//            }
//            if container.decodeNil() {
//                return JSONNull()
//            }
//            throw decodingError(forCodingPath: container.codingPath)
//        }
//        
//        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//            if let value = try? container.decode(Bool.self) {
//                return value
//            }
//            if let value = try? container.decode(Int64.self) {
//                return value
//            }
//            if let value = try? container.decode(Double.self) {
//                return value
//            }
//            if let value = try? container.decode(String.self) {
//                return value
//            }
//            if let value = try? container.decodeNil() {
//                if value {
//                    return JSONNull()
//                }
//            }
//            if var container = try? container.nestedUnkeyedContainer() {
//                return try decodeArray(from: &container)
//            }
//            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//                return try decodeDictionary(from: &container)
//            }
//            throw decodingError(forCodingPath: container.codingPath)
//        }
//        
//        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//            if let value = try? container.decode(Bool.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decode(Int64.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decode(Double.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decode(String.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decodeNil(forKey: key) {
//                if value {
//                    return JSONNull()
//                }
//            }
//            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//                return try decodeArray(from: &container)
//            }
//            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//                return try decodeDictionary(from: &container)
//            }
//            throw decodingError(forCodingPath: container.codingPath)
//        }
//        
//        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//            var arr: [Any] = []
//            while !container.isAtEnd {
//                let value = try decode(from: &container)
//                arr.append(value)
//            }
//            return arr
//        }
//        
//        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//            var dict = [String: Any]()
//            for key in container.allKeys {
//                let value = try decode(from: &container, forKey: key)
//                dict[key.stringValue] = value
//            }
//            return dict
//        }
//        
//        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//            for value in array {
//                if let value = value as? Bool {
//                    try container.encode(value)
//                } else if let value = value as? Int64 {
//                    try container.encode(value)
//                } else if let value = value as? Double {
//                    try container.encode(value)
//                } else if let value = value as? String {
//                    try container.encode(value)
//                } else if value is JSONNull {
//                    try container.encodeNil()
//                } else if let value = value as? [Any] {
//                    var container = container.nestedUnkeyedContainer()
//                    try encode(to: &container, array: value)
//                } else if let value = value as? [String: Any] {
//                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                    try encode(to: &container, dictionary: value)
//                } else {
//                    throw encodingError(forValue: value, codingPath: container.codingPath)
//                }
//            }
//        }
//        
//        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//            for (key, value) in dictionary {
//                let key = JSONCodingKey(stringValue: key)!
//                if let value = value as? Bool {
//                    try container.encode(value, forKey: key)
//                } else if let value = value as? Int64 {
//                    try container.encode(value, forKey: key)
//                } else if let value = value as? Double {
//                    try container.encode(value, forKey: key)
//                } else if let value = value as? String {
//                    try container.encode(value, forKey: key)
//                } else if value is JSONNull {
//                    try container.encodeNil(forKey: key)
//                } else if let value = value as? [Any] {
//                    var container = container.nestedUnkeyedContainer(forKey: key)
//                    try encode(to: &container, array: value)
//                } else if let value = value as? [String: Any] {
//                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                    try encode(to: &container, dictionary: value)
//                } else {
//                    throw encodingError(forValue: value, codingPath: container.codingPath)
//                }
//            }
//        }
//        
//        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//        
//        public required init(from decoder: Decoder) throws {
//            if var arrayContainer = try? decoder.unkeyedContainer() {
//                self.value = try JSONAny.decodeArray(from: &arrayContainer)
//            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//                self.value = try JSONAny.decodeDictionary(from: &container)
//            } else {
//                let container = try decoder.singleValueContainer()
//                self.value = try JSONAny.decode(from: container)
//            }
//        }
//        
//        public func encode(to encoder: Encoder) throws {
//            if let arr = self.value as? [Any] {
//                var container = encoder.unkeyedContainer()
//                try JSONAny.encode(to: &container, array: arr)
//            } else if let dict = self.value as? [String: Any] {
//                var container = encoder.container(keyedBy: JSONCodingKey.self)
//                try JSONAny.encode(to: &container, dictionary: dict)
//            } else {
//                var container = encoder.singleValueContainer()
//                try JSONAny.encode(to: &container, value: self.value)
//            }
//        }
//    }
//
//}
class RegisterModel:BaseModel{
    
    // MARK: - Welcome
    struct RegisterSuccessModel {
        var code: Int
        var success_type: String
        var message: String
        var data: [String:Any]
        var errors: [String:Any]
//        var message: String?
//        var code: Int?
//        var success_type:
//        var data: DataClass?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let successType = json["success_type"] as? String
            let message = json["message"] as? String
            let data = json["data"] as? [String:Any]
            let error = json["errors"] as? [String:Any]
            self.code = code ?? 0
            self.success_type = successType ?? ""
            self.message = message ?? ""
            self.data = data ?? ["":""]
            self.errors = error ?? ["":""]
        }
        
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let userID: Int?
        let accessToken: String?
        let userInfo: UserInfo?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case accessToken = "access_token"
            case userInfo = "user_info"
        }
    }
    
    // MARK: - UserInfo
    struct UserInfo: Codable {
        let verifiedFinal: Bool?
        let fullname, countryTxt: String?
        let age, profileCompletion: Int?
        let profileCompletionMissing: [String]?
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
        let deletedAt, mobileDeviceID, mobileToken, height: String?
        let heightTxt, hairColor, hairColorTxt, webTokenCreatedAt: String?
        let mobileTokenCreatedAt, mobileDevice, interest, location: String?
        let relationship, relationshipTxt, workStatus, workStatusTxt: String?
        let education, educationTxt, ethnicity, ethnicityTxt: String?
        let body, bodyTxt, character, characterTxt: String?
        let children, childrenTxt, friends, friendsTxt: String?
        let pets, petsTxt, liveWith, liveWithTxt: String?
        let car, carTxt, religion, religionTxt: String?
        let smoke, smokeTxt, drink, drinkTxt: String?
        let travel, travelTxt, music, dish: String?
        let song, hobby, city, sport: String?
        let book, movie, colour, tv: String?
        let privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: String?
        let emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: String?
        let emailOnAnnouncements, phoneVerified, online, isBoosted: String?
        let boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: String?
        let userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: String?
        let showMeTo, emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest: String?
        let lastEmailSent, approvedAt, snapshot, hotCount: String?
        let spamWarning, activationRequestCount, lastActivationRequest, lastseenTxt: String?
        let mediafiles: [JSONAny]?
      
        
        enum CodingKeys: String, CodingKey {
            case verifiedFinal = "verified_final"
            case fullname
            case countryTxt = "country_txt"
            case age
            case profileCompletion = "profile_completion"
            case profileCompletionMissing = "profile_completion_missing"
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
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
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
class LogoutModel:BaseModel{
    struct LogoutSuccessModel: Codable {
        let code: Int?
        let message: String?
    
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
//class DeleteAccountModel:BaseModel{
//    struct DeleteAccountSuccessModel: Codable {
//        let code: Int?
//        let message: String?
//        
//    }
//    
//    // MARK: - Errors
//    struct Errors: Codable {
//        let errorID, errorText: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case errorID = "error_id"
//            case errorText = "error_text"
//        }
//    }
//}

