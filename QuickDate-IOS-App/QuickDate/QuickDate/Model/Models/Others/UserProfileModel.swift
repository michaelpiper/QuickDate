
import Foundation

class UserProfileModel:BaseModel{
  
    
    // MARK: - Welcome
    struct UserProfileSuccessModel: Codable {
        var data: WelcomeData?
        let message: String?
        let code: Int?
    }
    
    // MARK: - WelcomeData
    struct WelcomeData: Codable {
        let id: String?
        let verifiedFinal: Bool?
        let fullname, webToken: String?
        let password: String?
        let age, profileCompletion: Int?
        let avater: String?
        let fullName, username, email, firstName: String?
        let lastName, address, gender: String?
        let genderTxt: String?
        let facebook, google, twitter, linkedin: String?
        let website, instagram, webDeviceID: String?
        let language: String?
        let languageTxt: String?
        let emailCode: String?
        let ipAddress: String?
        let type: String?
        let phoneNumber: String?
        let timezone: String?
        let lat, lng, about, birthday: String?
        let country, registered, lastseen, smscode: String?
        let proTime, lastLocationUpdate, balance, verified: String?
        let status, active, admin, startUp: String?
        let isPro, proType, socialLogin, createdAt: String?
        let updatedAt, deletedAt, mobileDeviceID, mobileToken: String?
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
        let emailOnSpecialOffers, emailOnAnnouncements, phoneVerified: String?
        let isBoosted, boostedTime, isBuyStickers, userBuyXvisits: String?
        let xvisitsCreatedAt, userBuyXmatches, xmatchesCreatedAt, userBuyXlikes: String?
        let xlikesCreatedAt, showMeTo, emailOnGetGift, emailOnGotNewMatch: String?
        let emailOnChatRequest, lastEmailSent, approvedAt, snapshot: String?
        let hotCount, spamWarning, activationRequestCount, lastActivationRequest: String?
        let lastseenTxt: String?
        let twoFactorVerified,twoFactor:String? 
        
        
        
        let mediafiles: [FluffyMediafile]?
        let likes: [Like]?
        var blocks: [Block]?
        let payments: [JSONAny]?
        let reports: [Report]?
        let visits: [JSONAny]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case verifiedFinal = "verified_final"
            case fullname
            case webToken = "web_token"
            case password, age
            case profileCompletion = "profile_completion"
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
            case twoFactorVerified = "two_factor_verified"
            case twoFactor = "two_factor"

            
            case mediafiles, likes, blocks, payments, reports, visits
        }
    }
    
    // MARK: - Block
    struct Block: Codable {
        let id, blockUserid: Int?
        let createdAt: String?
        let data: BlockData?
        
        enum CodingKeys: String, CodingKey {
            case id
            case blockUserid = "block_userid"
            case createdAt = "created_at"
            case data
        }
    }
    
    // MARK: - BlockData
    struct BlockData: Codable {
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
        let facebook, google, twitter, linkedin: String?
        let website, instagram, webDeviceID: String?
        let language: String?
        let languageTxt: String?
        let emailCode: String?
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
        let location, relationship: String?
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
        let music: String?
        let dish: String?
        let song: String?
        let hobby: String?
        let city: String?
        let sport: String?
        let book, movie: String?
        let colour: String?
        let tv: String?
        let privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: String?
        let emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: String?
        let emailOnAnnouncements, phoneVerified, isBoosted: String?
        let boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: String?
        let userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: String?
        let showMeTo, emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest: String?
        let lastEmailSent, approvedAt, snapshot, hotCount: String?
        let spamWarning, activationRequestCount, lastActivationRequest, lastseenTxt: String?
        let mediafiles: [PurpleMediafile]?
        
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
    
    enum About: String, Codable {
        case cvccccccccccccccccccccccccccccccccc = "cvccccccccccccccccccccccccccccccccc"
        case empty = ""
        case iAmALovingGirlFromAfrica = "I am a loving girl from Africa"
        case thisIsAllAboutMeDealWithIt = "This is all about me. Deal with it"
    }
    
    enum BodyTxt: String, Codable {
        case empty = ""
        case slim = "Slim"
        case sporty = "Sporty"
    }
    
    enum Book: String, Codable {
        case empty = ""
        case sdv = "sdv"
    }
    
    enum CarTxt: String, Codable {
        case empty = ""
        case myOwnCar = "My own car"
    }
    
    enum CharacterTxt: String, Codable {
        case accommodating = "Accommodating"
        case empty = ""
    }
    
    enum ChildrenTxt: String, Codable {
        case empty = ""
        case expecting = "Expecting"
        case noNever = "No, never"
    }
    
    enum Colour: String, Codable {
        case empty = ""
        case vds = "vds"
    }
    
    enum Dish: String, Codable {
        case empty = ""
        case sdvd = "sdvd"
    }
    
    enum DrinkTxt: String, Codable {
        case empty = ""
        case iDrinkSometimes = "I drink sometimes"
    }
    
    enum EducationTxt: String, Codable {
        case empty = ""
        case university = "University"
    }
    
    enum EthnicityTxt: String, Codable {
        case black = "Black"
        case empty = ""
        case middleEastern = "Middle Eastern"
        case mixed = "Mixed"
    }
    
    enum FriendsTxt: String, Codable {
        case empty = ""
        case onlyGoodFriends = "Only good friends"
        case someFriends = "Some friends"
    }
    
    enum GenderTxt: String, Codable {
        case female = "Female"
        case male = "Male"
    }
    
    enum Hobby: String, Codable {
        case empty = ""
        case vsd = "vsd"
    }
    
    enum Interest: String, Codable {
        case courageousCool = "courageous,cool,"
        case empty = ""
        case loveGirlFuckSex = "love,girl,fuck,sex,"
    }
    
    enum Language: String, Codable {
        case english = "english"
        case portuguese = "portuguese"
        case turkish = "turkish"
    }
    
    enum LanguageTxt: String, Codable {
        case english = "English"
        case portuguese = "Portuguese"
        case turkish = "Turkish"
    }
    
    enum LiveWithTxt: String, Codable {
        case empty = ""
        case friends = "Friends"
        case parents = "Parents"
    }
    
    // MARK: - PurpleMediafile
    struct PurpleMediafile: Codable {
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
    
    enum Music: String, Codable {
        case empty = ""
        case ssdvds = "ssdvds"
    }
    
    enum Password: String, Codable {
        case empty = "**********************"
    }
    
    enum PetsTxt: String, Codable {
        case empty = ""
        case havePets = "Have pets"
    }
    
    enum RelationshipTxt: String, Codable {
        case empty = ""
        case married = "Married"
        case single = "Single"
    }
    
    enum ReligionTxt: String, Codable {
        case buddhist = "Buddhist"
        case catholic = "Catholic"
        case empty = ""
    }
    
    enum SmokeTxt: String, Codable {
        case chainSmoker = "Chain Smoker"
        case empty = ""
        case iSmokeSometimes = "I smoke sometimes"
    }
    
    enum Song: String, Codable {
        case empty = ""
        case vd = "vd"
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
        case yesAllTheTime = "Yes, all the time"
        case yesSometimes = "Yes, sometimes"
    }
    
    enum TypeEnum: String, Codable {
        case user = "user"
    }
    
    enum WorkStatusTxt: String, Codable {
        case empty = ""
        case i039MStudying = "I&#039;m studying"
        case i039MWorking = "I&#039;m working"
        case selfEmployed = "Self-Employed"
    }
    
    // MARK: - Like
    struct Like: Codable {
        let id, likeUserid, isLike, isDislike: Int?
        let data: BlockData?
        
        enum CodingKeys: String, CodingKey {
            case id
            case likeUserid = "like_userid"
            case isLike = "is_like"
            case isDislike = "is_dislike"
            case data
        }
    }
    
    // MARK: - FluffyMediafile
    struct FluffyMediafile: Codable {
        let id: Int?
        let full, avater: String?
    }
    
    // MARK: - Report
    struct Report: Codable {
        let id, reportUserid: Int?
        let createdAt: String?
        let data: BlockData?
        
        enum CodingKeys: String, CodingKey {
            case id
            case reportUserid = "report_userid"
            case createdAt = "created_at"
            case data
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
class ForgetPasswordModel:BaseModel{
    
    struct ForgetPasswordSuccessModel: Codable {
       
    }
}
//class UpdateAccountModel:BaseModel{
//
//        struct UpdateAccountSuccessModel: Codable {
//            let message: String?
//            let data:String?
//            let code: Int?
//
//        }
//        // MARK: - Errors
//        struct Errors: Codable {
//            let errorID, errorText: String?
//
//            enum CodingKeys: String, CodingKey {
//                case errorID = "error_id"
//                case errorText = "error_text"
//            }
//        }
//
//
//}

//class ChangePasswordModel:BaseModel{
//    
//    struct ChangePasswordSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//        
//    }
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
//    
//}
//class UpdateSocialAccountsModel:BaseModel{
//
//    struct UpdateSocialAccountsSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//class UpdateSettingsModel:BaseModel{
//
//    struct UpdateSettingsSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//class EditProfileModel:BaseModel{
//
//    struct EditProfileSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//
//class EditLooksModel:BaseModel{
//
//    struct EditLooksSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//
//
//
//class EditPersonalityModel:BaseModel{
//
//    struct EditPersonalitySuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//
//class EditLifeStyleModel:BaseModel{
//
//    struct EditLifeSuccessStyleModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//
//
//class EditFavouriteModel:BaseModel{
//
//    struct EditFavouriteSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//class UpdateAboutMeModel:BaseModel{
//
//    struct UpdateAboutMeSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
//class UpdateInterestModel:BaseModel{
//
//    struct UpdateInterestSuccessModel: Codable {
//        let message: String?
//        let data:String?
//        let code: Int?
//
//    }
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
//
//}
