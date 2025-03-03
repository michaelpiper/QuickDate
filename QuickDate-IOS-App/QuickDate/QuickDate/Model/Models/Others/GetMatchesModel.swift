

import Foundation
//class GetMatchModel:BaseModel{
//     struct GetMatchSuccessModel: Codable {
//         var data: [Datum]?
//         var code: Int?
//         var message: String?
//     }
//
//     // MARK: - Datum
//     struct Datum: Codable {
//         var id, online, lastseen: Int?
//         var username: String?
//         var avater: String?
//         var country, firstName, lastName, location: String?
//         var birthday: String?
//         var language: String?
//         var relationship: Int?
//         var height: String?
//         var body, smoke, ethnicity, pets: Int?
//         var gender: String?
//         var countryText: String?
//         var relationshipText, bodyText, smokeText, ethnicityText: String?
//         var petsText: String?
//         var genderText: String?
//
//         enum CodingKeys: String, CodingKey {
//             case id, online, lastseen, username, avater, country
//             case firstName = "first_name"
//             case lastName = "last_name"
//             case location, birthday, language, relationship, height, body, smoke, ethnicity, pets, gender
//             case countryText = "country_text"
//             case relationshipText = "relationship_text"
//             case bodyText = "body_text"
//             case smokeText = "smoke_text"
//             case ethnicityText = "ethnicity_text"
//             case petsText = "pets_text"
//             case genderText = "gender_text"
//         }
//     }
//
//     enum Language: String, Codable {
//         case english = "english"
//         case french = "french"
//     }
//
//     // MARK: - Errors
//     struct Errors: Codable {
//         var errorID, errorText: String?
//
//         enum CodingKeys: String, CodingKey {
//             case errorID = "error_id"
//             case errorText = "error_text"
//         }
//     }
//
//     // MARK: - Encode/decode helpers
//
//     class JSONNull: Codable, Hashable {
//
//         public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//             return true
//         }
//
//         public var hashValue: Int {
//             return 0
//         }
//
//         public init() {}
//
//         public required init(from decoder: Decoder) throws {
//             let container = try decoder.singleValueContainer()
//             if !container.decodeNil() {
//                 throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//             }
//         }
//
//         public func encode(to encoder: Encoder) throws {
//             var container = encoder.singleValueContainer()
//             try container.encodeNil()
//         }
//     }
//
//}

//class GetMatchModel :BaseModel{
//
//    struct GetMatchSuccessModel: Codable {
//        let data: [Datum]?
//        let code: Int?
//        let errors: Errors?
//        let message: String?
//    }
//
//    // MARK: - Datum
//    struct Datum: Codable {
//        let id: String?
//        let verifiedFinal: Bool?
//        let fullname, countryTxt, fullPhoneNumber: String?
//        let password: String?
//        let age, profileCompletion: Int?
//        let profileCompletionMissing: [String]?
//        let avater: String?
//        let fullName, username, email, firstName: String?
//        let lastName, address, gender: String?
//        let genderTxt: String?
//        let facebook, google, twitter, linkedin: String?
//        let website, instagram, webDeviceID: String?
//        let language: String?
//        let languageTxt: String?
//        let emailCode: String?
//        let src: String?
//        let ipAddress: String?
//        let type: String?
//        let phoneNumber: String?
//        let timezone: String?
//        let lat, lng, about, birthday: String?
//        let country, registered, lastseen, smscode: String?
//        let proTime, lastLocationUpdate, balance, verified: String?
//        let status, active, admin, startUp: String?
//        let isPro, proType, socialLogin, createdAt: String?
//        let updatedAt, deletedAt, mobileDeviceID, webToken: String?
//        let mobileToken, height: String?
//        let heightTxt: String?
//        let hairColor: String?
//        let hairColorTxt: String?
//        let webTokenCreatedAt, mobileTokenCreatedAt, mobileDevice: String?
//        let interest: String?
//        let location: String?
//        let ccPhoneNumber, zip, state, relationship: String?
//        let relationshipTxt: String?
//        let workStatus: String?
//        let workStatusTxt: String?
//        let education: String?
//        let educationTxt: String?
//        let ethnicity: String?
//        let ethnicityTxt: String?
//        let body: String?
//        let bodyTxt: String?
//        let character: String?
//        let characterTxt: String?
//        let children: String?
//        let childrenTxt: String?
//        let friends: String?
//        let friendsTxt: String?
//        let pets, petsTxt, liveWith: String?
//        let liveWithTxt: String?
//        let car: String?
//        let carTxt: String?
//        let religion: String?
//        let religionTxt: String?
//        let smoke: String?
//        let smokeTxt: String?
//        let drink: String?
//        let drinkTxt: String?
//        let travel: String?
//        let travelTxt: String?
//        let music: String?
//        let dish: String?
//        let song: String?
//        let hobby: String?
//        let city: String?
//        let sport: String?
//        let book: String?
//        let movie: String?
//        let colour: String?
//        let tv: String?
//        let privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: String?
//        let emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: String?
//        let emailOnAnnouncements, phoneVerified, online, isBoosted: String?
//        let boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: String?
//        let userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: String?
//        let showMeTo, emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest: String?
//        let lastEmailSent, approvedAt, snapshot, hotCount: String?
//        let spamWarning, activationRequestCount, lastActivationRequest, twoFactor: String?
//        let twoFactorVerified, twoFactorEmailCode, newEmail, newPhone: String?
//        let permission, referrer, affBalance, paypalEmail: String?
//        let confirmFollowers, rewardDailyCredit, lockProVideo, lockPrivatePhoto: String?
//        let conversationID, infoFile, paystackRef, securionpayKey: String?
//        let lastseenTxt: String?
//        let lastseenDate: Date?
////        let mediafiles: [JSONAny]?
//        let isOwner, isLiked, isBlocked, isFavorite: Bool?
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case verifiedFinal = "verified_final"
//            case fullname
//            case countryTxt = "country_txt"
//            case fullPhoneNumber = "full_phone_number"
//            case password, age
//            case profileCompletion = "profile_completion"
//            case profileCompletionMissing = "profile_completion_missing"
//            case avater
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
//            case webToken = "web_token"
//            case mobileToken = "mobile_token"
//            case height
//            case heightTxt = "height_txt"
//            case hairColor = "hair_color"
//            case hairColorTxt = "hair_color_txt"
//            case webTokenCreatedAt = "web_token_created_at"
//            case mobileTokenCreatedAt = "mobile_token_created_at"
//            case mobileDevice = "mobile_device"
//            case interest, location
//            case ccPhoneNumber = "cc_phone_number"
//            case zip, state, relationship
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
//            case twoFactor = "two_factor"
//            case twoFactorVerified = "two_factor_verified"
//            case twoFactorEmailCode = "two_factor_email_code"
//            case newEmail = "new_email"
//            case newPhone = "new_phone"
//            case permission, referrer
//            case affBalance = "aff_balance"
//            case paypalEmail = "paypal_email"
//            case confirmFollowers = "confirm_followers"
//            case rewardDailyCredit = "reward_daily_credit"
//            case lockProVideo = "lock_pro_video"
//            case lockPrivatePhoto = "lock_private_photo"
//            case conversationID = "conversation_id"
//            case infoFile = "info_file"
//            case paystackRef = "paystack_ref"
//            case securionpayKey = "securionpay_key"
//            case lastseenTxt = "lastseen_txt"
//            case lastseenDate = "lastseen_date"
////            case mediafiles
//            case isOwner = "is_owner"
//            case isLiked = "is_liked"
//            case isBlocked = "is_blocked"
//            case isFavorite = "is_favorite"
//        }
//    }
//
//    enum BodyTxt: String, Codable {
//        case curvy = "Curvy"
//    }
//
//    enum Book: String, Codable {
//        case book = "book"
//    }
//
//    enum CarTxt: String, Codable {
//        case myOwnCar = "My own car"
//    }
//
//    enum CharacterTxt: String, Codable {
//        case lively = "Lively"
//    }
//
//    enum ChildrenTxt: String, Codable {
//        case somedayMaybe = "Someday, maybe"
//    }
//
//    enum City: String, Codable {
//        case city = "city"
//    }
//
//    enum Colour: String, Codable {
//        case red = "red"
//    }
//
//    enum Dish: String, Codable {
//        case meat = "meat"
//    }
//
//    enum DrinkTxt: String, Codable {
//        case iDrinkSometimes = "I drink sometimes"
//    }
//
//    enum EducationTxt: String, Codable {
//        case college = "College"
//    }
//
//    enum EthnicityTxt: String, Codable {
//        case middleEastern = "Middle Eastern"
//    }
//
//    enum FriendsTxt: String, Codable {
//        case manyFriends = "Many friends"
//    }
//
//    enum GenderTxt: String, Codable {
//        case female = "Female"
//        case male = "Male"
//    }
//
//    enum HairColorTxt: String, Codable {
//        case brown = "Brown"
//    }
//
//    enum HeightTxt: String, Codable {
//        case the152CM50Prime = "152 cm (5' 0&Prime;)"
//    }
//
//    enum Hobby: String, Codable {
//        case hobby = "hobby"
//    }
//
//    enum Interest: String, Codable {
//        case sintAutemInventoreAutOfficia = "Sint autem inventore aut officia"
//    }
//
//    enum IPAddress: String, Codable {
//        case the18812918019 = "188.129.180.19"
//    }
//
//    enum Language: String, Codable {
//        case english = "english"
//    }
//
//    enum LanguageTxt: String, Codable {
//        case english = "English"
//    }
//
//    enum LastseenTxt: String, Codable {
//        case the20HoursAgo = "20 hours ago"
//    }
//
//    enum LiveWithTxt: String, Codable {
//        case friends = "Friends"
//    }
//
//    enum Location: String, Codable {
//        case ducimus = "Ducimus"
//    }
//
//    enum Movie: String, Codable {
//        case movie = "movie"
//    }
//
//    enum Music: String, Codable {
//        case pop = "pop"
//    }
//
//    enum Password: String, Codable {
//        case empty = "**********************"
//    }
//
//    enum ProfileCompletionMissing: String, Codable {
//        case pets = "pets"
//    }
//
//    enum RelationshipTxt: String, Codable {
//        case single = "Single"
//    }
//
//    enum ReligionTxt: String, Codable {
//        case muslim = "Muslim"
//    }
//
//    enum SmokeTxt: String, Codable {
//        case iSmokeSometimes = "I smoke sometimes"
//    }
//
//    enum Song: String, Codable {
//        case song = "song"
//    }
//
//    enum Sport: String, Codable {
//        case sport = "sport"
//    }
//
//    enum Src: String, Codable {
//        case fake = "Fake"
//    }
//
//    enum Timezone: String, Codable {
//        case utc = "UTC"
//    }
//
//    enum TravelTxt: String, Codable {
//        case yesSometimes = "Yes, sometimes"
//    }
//
//    enum Tv: String, Codable {
//        case tv = "tv"
//    }
//
//    enum TypeEnum: String, Codable {
//        case user = "user"
//    }
//
//    enum WorkStatusTxt: String, Codable {
//        case i039MWorking = "I&#039;m working"
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
