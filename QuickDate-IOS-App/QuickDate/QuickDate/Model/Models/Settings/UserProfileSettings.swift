//
//  UserProfileSettings.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 14.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

// MARK: - UserProfileSettings
class UserProfileSettings: Equatable {
    
    public var id : String
    public var profile_completion : Int
    public var profile_completion_missing : Array<String>
    public var username : String
    public var email : String
    public var password : String
    public var first_name : String
    public var last_name : String
    public var profile: ProfileFeatures
    public var favourites: Favourites
    public var avatar : String
    public var address : String
    public var gender : Gender
    public var gender_txt : String
    public var facebook : String
    public var google : String
    public var twitter : String
    public var linkedin : String
    public var okru : String
    public var mailru : String
    public var discord : String
    public var wechat : String
    public var qq : String
    public var website : String
    public var instagram : String
    public var web_device_id : String
    public var language : String
    public var language_txt : String
    public var email_code : String
    public var src : String
    public var ip_address : String
    public var type : String
    public var phone_number : String
    public var timezone : String
    public var lat : String
    public var lng : String
    public var about : String
    public var birthday : String
    public var country : String
    public var registered : String
    public var lastseen : String
    public var smscode : String
    public var pro_time : String
    public var last_location_update : String
    public var balance : Double
    public var verified : Bool
    public var status : String
    public var active : String
    public var admin : String
    public var start_up : String
    public var is_pro : Bool
    public var pro_type : String
    public var social_login : String
    public var created_at : String
    public var updated_at : String
    public var deleted_at : String
    public var mobile_device_id : String
    public var web_token : String
    public var mobile_token : String
    public var height : String
    public var height_txt : String
    public var hair_color : String
    public var hair_color_txt : String
    public var web_token_created_at : String
    public var mobile_token_created_at : String
    public var mobile_device : String
    public var interest : String
    public var location : String
    public var cc_phone_number : String
    public var zip : String
    public var state : String
    public var relationship : String
    public var relationship_txt : String
    public var work_status : String
    public var work_status_txt : String
    public var education : String
    public var education_txt : String
    public var ethnicity : String
    public var ethnicity_txt : String
    public var body : String
    public var body_txt : String
    public var character : String
    public var character_txt : String
    public var children : String
    public var children_txt : String
    public var friends : String
    public var friends_txt : String
    public var pets : String
    public var pets_txt : String
    public var live_with : String
    public var live_with_txt : String
    public var car : String
    public var car_txt : String
    public var religion : String
    public var religion_txt : String
    public var smoke : String
    public var smoke_txt : String
    public var drink : String
    public var drink_txt : String
    public var travel : String
    public var travel_txt : String
    public var music : String
    public var dish : String
    public var song : String
    public var hobby : String
    public var city : String
    public var sport : String
    public var book : String
    public var movie : String
    public var colour : String
    public var tv : String
    public var privacy_show_profile_on_google : Bool
    public var privacy_show_profile_random_users : Bool
    public var privacy_show_profile_match_profiles : Bool
    public var email_on_profile_view : String
    public var email_on_new_message : String
    public var email_on_profile_like : String
    public var email_on_purchase_notifications : String
    public var email_on_special_offers : String
    public var email_on_announcements : String
    public var phone_verified : Bool
    public var online : Bool
    public var is_boosted : String
    public var boosted_time : String
    public var is_buy_stickers : String
    public var user_buy_xvisits : String
    public var xvisits_created_at : String
    public var user_buy_xmatches : String
    public var xmatches_created_at : String
    public var user_buy_xlikes : String
    public var xlikes_created_at : String
    public var show_me_to : String
    public var email_on_get_gift : String
    public var email_on_got_new_match : String
    public var email_on_chat_request : String
    public var last_email_sent : String
    public var approved_at : String
    public var snapshot : String
    public var hot_count : String
    public var spam_warning : String
    public var activation_request_count : String
    public var last_activation_request : String
    public var two_factor : Bool
    public var two_factor_verified : Bool
    public var two_factor_email_code : String
    public var new_email : String
    public var new_phone : String
    public var permission : String
    public var referrer : String
    public var aff_balance : String
    public var paypal_email : String
    public var confirm_followers : Bool
    public var reward_daily_credit : String
    public var lock_pro_video : String
    public var lock_private_photo : String
    public var conversation_id : String
    public var info_file : String
    public var paystack_ref : String
    public var securionpay_securionpay_key : String
    public var coinbase_hash : String
    public var coinbase_code : String
    public var yoomoney_hash : String
    public var coinpayments_txn_id : String
    public var fortumo_hash : String
    public var ngenius_ref : String
    public var aamarpay_tran_id : String
    public var find_match_data : String
    public var verified_final : Bool
//    public var fullname : String
    public var country_txt : String
    public var full_phone_number : String
    public var age : Int
    public var full_name : String
    public var lastseen_txt : String
    public var lastseen_date : String
    public var mediafiles : [MediaFile]
    public var pro_icon : String
    public var is_friend_request : Bool
    public var is_friend : Bool
    public var likes : [Likes]
    public var likes_count : Int
    public var blocks : [Blocks]
    public var payments : [String]
    public var reports : [String]
    public var visits : [Visits]
    public var visits_count : Int
    public var referrals : Array<String>
    public var aff_payments : Array<String>
    public var is_favorite : Bool
    public var userData: UserProfileSettings?
    public var isLiked: Bool
    
    var fullname: String {
        return first_name.isEmpty && last_name.isEmpty ? username
        : first_name.isEmpty ? first_name
        : last_name.isEmpty ? username
        : "\(first_name) \(last_name)"
    }
    
    var socialMedia: SocialMedia {
        return SocialMedia(
            google: google,
            facebook: facebook,
            instagram: instagram,
            webSite: website,
            linkedin: linkedin,
            twitter: twitter
        )
    }    
    
    var avatarURL: URL? {
        return URL(string: avatar)
    }
    
    var coordinate: Coordinate {
        return (self.lat,self.lng)
    }
        
    init(dict: JSON) {        
        profile = ProfileFeatures(from: dict)
        favourites = Favourites(from: dict)
        id = dict.getIntType(with: "id")
        profile_completion = dict["profile_completion"] as? Int ?? 0
        profile_completion_missing = dict.getStringList(with: "profile_completion_missing")
        username = dict["username"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        password = dict["password"] as? String ?? ""
        first_name = dict["first_name"] as? String ?? ""
        last_name = dict["last_name"] as? String ?? ""
        avatar = dict["avater"] as? String ?? ""
        address = dict["address"] as? String ?? ""
        gender = Gender(stringValue: dict["gender"] as? String ?? "")
        gender_txt = dict["gender_txt"] as? String ?? ""
        facebook = dict["facebook"] as? String ?? ""
        google = dict["google"] as? String ?? ""
        twitter = dict["twitter"] as? String ?? ""
        linkedin = dict["linkedin"] as? String ?? ""
        okru = dict["okru"] as? String ?? ""
        mailru = dict["mailru"] as? String ?? ""
        discord = dict["discord"] as? String ?? ""
        wechat = dict["wechat"] as? String ?? ""
        qq = dict["qq"] as? String ?? ""
        website = dict["website"] as? String ?? ""
        instagram = dict["instagram"] as? String ?? ""
        web_device_id = dict["web_device_id"] as? String ?? ""
        language = dict["language"] as? String ?? ""
        language_txt = dict["language_txt"] as? String ?? ""
        email_code = dict["email_code"] as? String ?? ""
        src = dict["src"] as? String ?? ""
        ip_address = dict["ip_address"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        phone_number = dict["phone_number"] as? String ?? ""
        timezone = dict["timezone"] as? String ?? ""
        lat = dict["lat"] as? String ?? ""
        lng = dict["lng"] as? String ?? ""
        about = dict["about"] as? String ?? ""
        birthday = dict["birthday"] as? String ?? ""
        country = dict["country"] as? String ?? ""
        registered = dict["registered"] as? String ?? ""
        lastseen = dict.getIntType(with: "lastseen")
        smscode = dict["smscode"] as? String ?? ""
        pro_time = dict["pro_time"] as? String ?? ""
        last_location_update = dict["last_location_update"] as? String ?? ""
        balance = dict.getDoubleType(with: "balance")
        verified = dict.getBoolType(with: "verified")//["verified"] as? String ?? ""
        status = dict["status"] as? String ?? ""
        active = dict["active"] as? String ?? ""
        admin = dict["admin"] as? String ?? ""
        start_up = dict["start_up"] as? String ?? ""
        is_pro = dict.getBoolType(with: "is_pro")
        pro_type = dict["pro_type"] as? String ?? ""
        social_login = dict["social_login"] as? String ?? ""
        created_at = dict["created_at"] as? String ?? ""
        updated_at = dict["updated_at"] as? String ?? ""
        deleted_at = dict["deleted_at"] as? String ?? ""
        mobile_device_id = dict["mobile_device_id"] as? String ?? ""
        web_token = dict["web_token"] as? String ?? ""
        mobile_token = dict["mobile_token"] as? String ?? ""
        height = dict["height"] as? String ?? ""
        height_txt = dict["height_txt"] as? String ?? ""
        hair_color = dict["hair_color"] as? String ?? ""
        hair_color_txt = dict["hair_color_txt"] as? String ?? ""
        web_token_created_at = dict["web_token_created_at"] as? String ?? ""
        mobile_token_created_at = dict["mobile_token_created_at"] as? String ?? ""
        mobile_device = dict["mobile_device"] as? String ?? ""
        interest = dict["interest"] as? String ?? ""
        location = dict["location"] as? String ?? ""
        cc_phone_number = dict["cc_phone_number"] as? String ?? ""
        zip = dict["zip"] as? String ?? ""
        state = dict["state"] as? String ?? ""
        relationship = dict["relationship"] as? String ?? ""
        relationship_txt = dict["relationship_txt"] as? String ?? ""
        work_status = dict["work_status"] as? String ?? ""
        work_status_txt = dict["work_status_txt"] as? String ?? ""
        education = dict["education"] as? String ?? ""
        education_txt = dict["education_txt"] as? String ?? ""
        ethnicity = dict["ethnicity"] as? String ?? ""
        ethnicity_txt = dict["ethnicity_txt"] as? String ?? ""
        body = dict["body"] as? String ?? ""
        body_txt = dict["body_txt"] as? String ?? ""
        character = dict["character"] as? String ?? ""
        character_txt = dict["character_txt"] as? String ?? ""
        children = dict["children"] as? String ?? ""
        children_txt = dict["children_txt"] as? String ?? ""
        friends = dict["friends"] as? String ?? ""
        friends_txt = dict["friends_txt"] as? String ?? ""
        pets = dict["pets"] as? String ?? ""
        pets_txt = dict["pets_txt"] as? String ?? ""
        live_with = dict["live_with"] as? String ?? ""
        live_with_txt = dict["live_with_txt"] as? String ?? ""
        car = dict["car"] as? String ?? ""
        car_txt = dict["car_txt"] as? String ?? ""
        religion = dict["religion"] as? String ?? ""
        religion_txt = dict["religion_txt"] as? String ?? ""
        smoke = dict["smoke"] as? String ?? ""
        smoke_txt = dict["smoke_txt"] as? String ?? ""
        drink = dict["drink"] as? String ?? ""
        drink_txt = dict["drink_txt"] as? String ?? ""
        travel = dict["travel"] as? String ?? ""
        travel_txt = dict["travel_txt"] as? String ?? ""
        music = dict["music"] as? String ?? ""
        dish = dict["dish"] as? String ?? ""
        song = dict["song"] as? String ?? ""
        hobby = dict["hobby"] as? String ?? ""
        city = dict["city"] as? String ?? ""
        sport = dict["sport"] as? String ?? ""
        book = dict["book"] as? String ?? ""
        movie = dict["movie"] as? String ?? ""
        colour = dict["colour"] as? String ?? ""
        tv = dict["tv"] as? String ?? ""
        privacy_show_profile_on_google = dict.getBoolType(with: "privacy_show_profile_on_google")
        privacy_show_profile_random_users = dict.getBoolType(with: "privacy_show_profile_random_users")
        privacy_show_profile_match_profiles = dict.getBoolType(with: "privacy_show_profile_match_profiles")
        email_on_profile_view = dict["email_on_profile_view"] as? String ?? ""
        email_on_new_message = dict["email_on_new_message"] as? String ?? ""
        email_on_profile_like = dict["email_on_profile_like"] as? String ?? ""
        email_on_purchase_notifications = dict["email_on_purchase_notifications"] as? String ?? ""
        email_on_special_offers = dict["email_on_special_offers"] as? String ?? ""
        email_on_announcements = dict["email_on_announcements"] as? String ?? ""
        phone_verified = dict.getBoolType(with: "phone_verified")//["phone_verified"] as? String ?? ""
        online = dict.getBoolType(with: "online")//["online"] as? Int ?? 0
        is_boosted = dict["is_boosted"] as? String ?? ""
        boosted_time = dict["boosted_time"] as? String ?? ""
        is_buy_stickers = dict["is_buy_stickers"] as? String ?? ""
        user_buy_xvisits = dict["user_buy_xvisits"] as? String ?? ""
        xvisits_created_at = dict["xvisits_created_at"] as? String ?? ""
        user_buy_xmatches = dict["user_buy_xmatches"] as? String ?? ""
        xmatches_created_at = dict["xmatches_created_at"] as? String ?? ""
        user_buy_xlikes = dict["user_buy_xlikes"] as? String ?? ""
        xlikes_created_at = dict["xlikes_created_at"] as? String ?? ""
        show_me_to = dict["show_me_to"] as? String ?? ""
        email_on_get_gift = dict["email_on_get_gift"] as? String ?? ""
        email_on_got_new_match = dict["email_on_got_new_match"] as? String ?? ""
        email_on_chat_request = dict["email_on_chat_request"] as? String ?? ""
        last_email_sent = dict["last_email_sent"] as? String ?? ""
        approved_at = dict["approved_at"] as? String ?? ""
        snapshot = dict["snapshot"] as? String ?? ""
        hot_count = dict["hot_count"] as? String ?? ""
        spam_warning = dict["spam_warning"] as? String ?? ""
        activation_request_count = dict["activation_request_count"] as? String ?? ""
        last_activation_request = dict["last_activation_request"] as? String ?? ""
        two_factor = dict.getBoolType(with: "two_factor")
        two_factor_verified = dict.getBoolType(with: "two_factor_verified")
        two_factor_email_code = dict["two_factor_email_code"] as? String ?? ""
        new_email = dict["new_email"] as? String ?? ""
        new_phone = dict["new_phone"] as? String ?? ""
        permission = dict["permission"] as? String ?? ""
        referrer = dict["referrer"] as? String ?? ""
        aff_balance = dict["aff_balance"] as? String ?? ""
        paypal_email = dict["paypal_email"] as? String ?? ""
        confirm_followers = dict.getBoolType(with: "confirm_followers")
        reward_daily_credit = dict["reward_daily_credit"] as? String ?? ""
        lock_pro_video = dict["lock_pro_video"] as? String ?? ""
        lock_private_photo = dict["lock_private_photo"] as? String ?? ""
        conversation_id = dict["conversation_id"] as? String ?? ""
        info_file = dict["info_file"] as? String ?? ""
        paystack_ref = dict["paystack_ref"] as? String ?? ""
        securionpay_securionpay_key = dict["securionpay_key"] as? String ?? ""
        coinbase_hash = dict["coinbase_hash"] as? String ?? ""
        coinbase_code = dict["coinbase_code"] as? String ?? ""
        yoomoney_hash = dict["yoomoney_hash"] as? String ?? ""
        coinpayments_txn_id = dict["coinpayments_txn_id"] as? String ?? ""
        fortumo_hash = dict["fortumo_hash"] as? String ?? ""
        ngenius_ref = dict["ngenius_ref"] as? String ?? ""
        aamarpay_tran_id = dict["aamarpay_tran_id"] as? String ?? ""
        find_match_data = dict["find_match_data"] as? String ?? ""
        verified_final = dict["verified_final"] as? Bool ?? false
//        fullname = dict["fullname"] as? String ?? ""
        country_txt = dict["country_txt"] as? String ?? ""
        full_phone_number = dict["full_phone_number"] as? String ?? ""
        age = dict["age"] as? Int ?? 0
        full_name = dict["full_name"] as? String ?? ""
        lastseen_txt = dict["lastseen_txt"] as? String ?? ""
        lastseen_date = dict["lastseen_date"] as? String ?? ""
        mediafiles = dict.getMediaFileList(with: "mediafiles")
        pro_icon = dict["pro_icon"] as? String ?? ""
        is_friend_request = dict["is_friend_request"] as? Bool ?? false
        is_friend = dict["is_friend"] as? Bool ?? false
        likes = dict.getLikesList(with: "likes")
        likes_count = dict["likes_count"] as? Int ?? 0
        blocks = dict.getBlocksList(with: "blocks")
        payments = dict.getStringList(with: "payments")
        reports = dict.getStringList(with: "reports")
        visits = dict.getVisitList(with: "visits")
        visits_count = dict["visits_count"] as? Int ?? 0
        referrals = dict.getStringList(with: "referrals")
        aff_payments = dict.getStringList(with: "aff_payments")
        is_favorite = dict["is_favorite"] as? Bool ?? false
        userData = dict.getUserDataList(with: "userData")
        isLiked = dict.getBoolType(with: "is_liked")
    }
    
    static func == (lhs: UserProfileSettings, rhs: UserProfileSettings) -> Bool {
        return lhs.id == rhs.id
    }    
}

// MARK: - UserInteractions

enum UserInteraction {
    case like
    case dislike
}

/*// MARK: - Relation
class Relation {
    
    enum RelationType {
        case liked
        case blocked
    }
    
    let relationType: RelationType
    
    let like: UserInteraction?
    
    let id, userIdOfRelatedUser: Int
    let username, firstName, lastName, fullName: String
    let genderCode, avatarURL: String
    
    init(type: RelationType, from dict: JSON) {
        self.relationType = type
        self.id = dict["id"] as? Int ?? 0
        let userIdKey: String = type == .liked ? "like_userid" : "block_userid"
        self.userIdOfRelatedUser = dict[userIdKey] as? Int ?? 0
        
        if type == .liked {
            let isLike = dict["is_like"] as? Int ?? 0 == 1 && dict["is_dislike"] as? Int ?? 0 == 0
            self.like = isLike ? .like : .dislike
        } else {
            self.like = nil
        }
        
        let data = dict["data"] as? JSON
        self.username = data?["username"] as? String ?? ""
        self.firstName = data?["first_name"] as? String ?? ""
        self.lastName = data?["last_name"] as? String ?? ""
        self.fullName = data?["full_name"] as? String ?? ""
        self.genderCode = data?["gender"] as? String ?? ""
        self.avatarURL = data?["avater"] as? String ?? ""

    }
    
}
*/
