//
//  AdminAppSettings.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 21.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

/// Help to get admin choices from server
typealias AdminChoices = [String: String]

class AdminAppSettings {
    
    let sms_t_phone_number: String
    let sms_twilio_username: String
    let sms_twilio_password: String
    let sms_provider: String
    let height: AdminChoices
    let gender: AdminChoices
    let notification: AdminChoices
    let blogCategories: AdminChoices
    let hairColor: AdminChoices
    let travel: AdminChoices
    let drink: AdminChoices
    let smoke: AdminChoices
    let religion: AdminChoices
    let car: AdminChoices
    let liveWith: AdminChoices
    let pets: AdminChoices
    let friends, children: AdminChoices
    let character: AdminChoices
    let body, ethnicity, education: AdminChoices
    let workStatus: AdminChoices
    let relationship: AdminChoices
    let language: AdminChoices
    let paypal_currency: String
    
    init(dict: JSON) {
        self.height = dict.turnToAdminChoicesFromDictionaryArray(with: .height)
        self.gender = dict.turnToAdminChoicesFromDictionaryArray(with: .gender)
        self.notification = dict.turnToAdminChoicesFromDictionaryArray(with: .notification)
        self.blogCategories = dict.turnToAdminChoicesFromDictionaryArray(with: .blogCategories)
        self.hairColor = dict.turnToAdminChoicesFromDictionaryArray(with: .hairColor)
        self.travel = dict.turnToAdminChoicesFromDictionaryArray(with: .travel)
        self.drink = dict.turnToAdminChoicesFromDictionaryArray(with: .drink)
        self.smoke = dict.turnToAdminChoicesFromDictionaryArray(with: .smoke)
        self.religion = dict.turnToAdminChoicesFromDictionaryArray(with: .religion)
        self.car = dict.turnToAdminChoicesFromDictionaryArray(with: .car)
        self.liveWith = dict.turnToAdminChoicesFromDictionaryArray(with: .liveWith)
        self.pets = dict.turnToAdminChoicesFromDictionaryArray(with: .pets)
        self.friends = dict.turnToAdminChoicesFromDictionaryArray(with: .friends)
        self.children = dict.turnToAdminChoicesFromDictionaryArray(with: .children)
        self.character = dict.turnToAdminChoicesFromDictionaryArray(with: .character)
        self.education = dict.turnToAdminChoicesFromDictionaryArray(with: .education)
        self.ethnicity = dict.turnToAdminChoicesFromDictionaryArray(with: .ethnicity)
        self.body = dict.turnToAdminChoicesFromDictionaryArray(with: .body)
        self.workStatus = dict.turnToAdminChoicesFromDictionaryArray(with: .workStatus)
        self.relationship = dict.turnToAdminChoicesFromDictionaryArray(with: .relationship)
        self.language = dict.turnToAdminChoicesFromDictionaryArray(with: .language)
        self.paypal_currency = dict["paypal_currency"] as? String ?? "USD"
        self.sms_t_phone_number = dict["sms_t_phone_number"] as? String ?? ""
        self.sms_twilio_username = dict["sms_twilio_username"] as? String ?? ""
        self.sms_twilio_password = dict["sms_twilio_password"] as? String ?? ""
        self.sms_provider = dict["sms_provider"] as? String ?? ""
    }
    
    fileprivate enum JSONKeys: String {
        case height = "Height"
        case notification = "Notification"
        case gender = "Gender"
        case blogCategories = "BlogCategories"
        case countries = "Countries"
        case hairColor = "HairColor"
        case travel = "Travel"
        case drink = "Drink"
        case smoke = "Smoke"
        case religion = "Religion"
        case car = "Car"
        case liveWith = "LiveWith"
        case pets = "Pets"
        case friends = "Friends"
        case children = "Children"
        case character = "Character"
        case body = "Body"
        case ethnicity = "Ethnicity"
        case education = "Education"
        case workStatus = "WorkStatus"
        case relationship = "Relationship"
        case language = "Language"
        case paypal_currency = "paypal_currency"
    }
}

extension JSON {
    fileprivate func getValue<T>(key: AdminAppSettings.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    /// fetch MediaFile type and turn its to array
    fileprivate func turnToAdminChoicesFromDictionaryArray(with jsonKey: AdminAppSettings.JSONKeys) -> AdminChoices {
        guard let dictArray = self[jsonKey.rawValue] as? [JSON] else { return [:] }
        var resultDict: AdminChoices = [:]
        dictArray.forEach { json in
            json.forEach { (key: String, value: Any) in
                let returnValue = value as? String ?? ""
                resultDict[key] = returnValue
            }
        }
        return resultDict
    }
}

//fileprivate enum JSONKeys: String {
//    case height = "Height"
//    case notification = "Notification"
//    case gender = "Gender"
//    case blogCategories = "BlogCategories"
//    case countries = "Countries"
//    case hairColor = "HairColor"
//    case travel = "Travel"
//    case drink = "Drink"
//    case smoke = "Smoke"
//    case religion = "Religion"
//    case car = "Car"
//    case liveWith = "LiveWith"
//    case pets = "Pets"
//    case friends = "Friends"
//    case children = "Children"
//    case character = "Character"
//    case body = "Body"
//    case ethnicity = "Ethnicity"
//    case education = "Education"
//    case workStatus = "WorkStatus"
//    case relationship = "Relationship"
//    case language = "Language"
//
//    case loadConfigInSession = "load_config_in_session"
//    case metaDescription = "meta_description"
//    case metaKeywords = "meta_keywords"
//    case defaultTitle = "default_title"
//    case siteName = "site_name"
//    case defaultLanguage = "default_language"
//    case smtpOrMail = "smtp_or_mail"
//    case smtpHost = "smtp_host"
//    case smtpUsername = "smtp_username"
//    case smtpPassword = "smtp_password"
//    case smtpEncryption = "smtp_encryption"
//    case smtpPort = "smtp_port"
//    case siteEmail, theme
//    case allLogin = "AllLogin"
//    case googleLogin, facebookLogin, twitterLogin, linkedinLogin
//    case vkontakteLogin = "VkontakteLogin"
//    case facebookAppID = "facebookAppId"
//    case facebookAppKey
//    case googleAppID = "googleAppId"
//    case googleAppKey
//    case twitterAppID = "twitterAppId"
//    case twitterAppKey
//    case linkedinAppID = "linkedinAppId"
//    case linkedinAppKey
//    case vkontakteAppID = "VkontakteAppId"
//    case vkontakteAppKey = "VkontakteAppKey"
//    case instagramAppID = "instagramAppId"
//    case instagramAppkey, instagramLogin
//    case smsOrEmail = "sms_or_email"
//    case smsPhoneNumber = "sms_phone_number"
//    case paypalID = "paypal_id"
//    case paypalSecret = "paypal_secret"
//    case paypalMode = "paypal_mode"
//    case currency
//    case lastBackup = "last_backup"
//    case amazoneS3 = "amazone_s3"
//    case bucketName = "bucket_name"
//    case amazoneS3Key = "amazone_s3_key"
//    case amazoneS3SKey = "amazone_s3_s_key"
//    case region
//    case smsTPhoneNumber = "sms_t_phone_number"
//    case smsTwilioUsername = "sms_twilio_username"
//    case smsTwilioPassword = "sms_twilio_password"
//    case smsProvider = "sms_provider"
//    case profilePictureWidthCrop = "profile_picture_width_crop"
//    case profilePictureHeightCrop = "profile_picture_height_crop"
//    case userDefaultAvatar
//    case profilePictureImageQuality = "profile_picture_image_quality"
//    case emailValidation
//    case stripeSecret = "stripe_secret"
//    case stripeID = "stripe_id"
//    case pushID = "push_id"
//    case pushKey = "push_key"
//    case pushID2 = "push_id_2"
//    case pushKey2 = "push_key_2"
//    case terms, about
//    case privacyPolicy = "privacy_policy"
//    case facebookURL = "facebook_url"
//    case twitterURL = "twitter_url"
//    case googleURL = "google_url"
//    case currencySymbol = "currency_symbol"
//    case bagOfCreditsPrice = "bag_of_credits_price"
//    case bagOfCreditsAmount = "bag_of_credits_amount"
//    case boxOfCreditsPrice = "box_of_credits_price"
//    case boxOfCreditsAmount = "box_of_credits_amount"
//    case chestOfCreditsPrice = "chest_of_credits_price"
//    case chestOfCreditsAmount = "chest_of_credits_amount"
//    case weeklyProPlan = "weekly_pro_plan"
//    case monthlyProPlan = "monthly_pro_plan"
//    case yearlyProPlan = "yearly_pro_plan"
//    case lifetimeProPlan = "lifetime_pro_plan"
//    case workerUpdateDelay = "worker_updateDelay"
//    case profileRecordViewsMinute = "profile_record_views_minute"
//    case costPerGift = "cost_per_gift"
//    case deleteAccount
//    case userRegistration = "user_registration"
//    case maxUpload
//    case mimeTypes = "mime_types"
//    case normalBoostMeCreditsPrice = "normal_boost_me_credits_price"
//    case moreStickersCreditsPrice = "more_stickers_credits_price"
//    case proBoostMeCreditsPrice = "pro_boost_me_credits_price"
//    case boostExpireTime = "boost_expire_time"
//    case notProChatLimitDaily = "not_pro_chat_limit_daily"
//    case notProChatCredit = "not_pro_chat_credit"
//    case notProChatStickersCredit = "not_pro_chat_stickers_credit"
//    case notProChatStickersLimit = "not_pro_chat_stickers_limit"
//    case costPerXvisits = "cost_per_xvisits"
//    case xvisitsExpireTime = "xvisits_expire_time"
//    case costPerXmatche = "cost_per_xmatche"
//    case xmatcheExpireTime = "xmatche_expire_time"
//    case costPerXlike = "cost_per_xlike"
//    case xlikeExpireTime = "xlike_expire_time"
//    case googlePlaceAPI = "google_place_api"
//    case wowonderLogin = "wowonder_login"
//    case wowonderAppID = "wowonder_app_ID"
//    case wowonderAppKey = "wowonder_app_key"
//    case wowonderDomainURI = "wowonder_domain_uri"
//    case wowonderDomainIcon = "wowonder_domain_icon"
//    case bankTransferNote = "bank_transfer_note"
//    case maxSwaps = "max_swaps"
//    case stripeVersion = "stripe_version"
//    case payseraProjectID = "paysera_project_id"
//    case payseraPassword = "paysera_password"
//    case payseraTestMode = "paysera_test_mode"
//    case messageRequestSystem = "message_request_system"
//    case videoChat = "video_chat"
//    case audioChat = "audio_chat"
//    case videoAccountSid = "video_accountSid"
//    case videoAPIKeySid = "video_apiKeySid"
//    case videoAPIKeySecret = "video_apiKeySecret"
//    case giphyAPI = "giphy_api"
//    case defaultUnit = "default_unit"
//    case maintenanceMode = "maintenance_mode"
//    case displaymode
//    case bankDescription = "bank_description"
//    case version
//    case googleTagCode = "google_tag_code"
//    case avcallPro = "avcall_pro"
//    case proSystem = "pro_system"
//    case imgBlurAmount = "img_blur_amount"
//    case emailNotification
//    case activationLimitSystem = "activation_limit_system"
//    case maxActivationRequest = "max_activation_request"
//    case activationRequestTimeLimit = "activation_request_time_limit"
//    case freeFeatures = "free_features"
//    case oppositeGender = "opposite_gender"
//    case imageVerification = "image_verification"
//    case pendingVerification = "pending_verification"
//    case push
//    case spamWarning = "spam_warning"
//    case imageVerificationStart = "image_verification_start"
//    case twoFactor = "two_factor"
//    case twoFactorType = "two_factor_type"
//    case affiliateSystem = "affiliate_system"
//    case affiliateType = "affiliate_type"
//    case mWithdrawal = "m_withdrawal"
//    case amountRef = "amount_ref"
//    case amountPercentRef = "amount_percent_ref"
//    case connectivitySystem, connectivitySystemLimit
//    case showUserOnHomepage = "show_user_on_homepage"
//    case showedUser = "showed_user"
//    case maxPhotoPerUser = "max_photo_per_user"
//    case reviewMediaFiles = "review_media_files"
//    case ffmpegSys = "ffmpeg_sys"
//    case maxVideoDuration = "max_video_duration"
//    case ffmpegBinary = "ffmpeg_binary"
//    case disablePhoneField = "disable_phone_field"
//    case socialMediaLinks = "social_media_links"
//    case ytAPI = "yt_api"
//    case seo
//    case lockPrivatePhoto = "lock_private_photo"
//    case lockPrivatePhotoFee = "lock_private_photo_fee"
//    case lockProVideo = "lock_pro_video"
//    case lockProVideoFee = "lock_pro_video_fee"
//    case verificationOnSignup = "verification_on_signup"
//    case creditEarnSystem = "credit_earn_system"
//    case creditEarnMaxDays = "credit_earn_max_days"
//    case creditEarnDayAmount = "credit_earn_day_amount"
//    case specificEmailSignup = "specific_email_signup"
//    case push1
//    case checkoutPayment = "checkout_payment"
//    case checkoutMode = "checkout_mode"
//    case checkoutCurrency = "checkout_currency"
//    case checkoutSellerID = "checkout_seller_id"
//    case checkoutPublishableKey = "checkout_publishable_key"
//    case checkoutPrivateKey = "checkout_private_key"
//    case cashfreePayment = "cashfree_payment"
//    case cashfreeMode = "cashfree_mode"
//    case cashfreeClientKey = "cashfree_client_key"
//    case cashfreeSecretKey = "cashfree_secret_key"
//    case iyzipayPayment = "iyzipay_payment"
//    case iyzipayMode = "iyzipay_mode"
//    case iyzipayKey = "iyzipay_key"
//    case iyzipayBuyerID = "iyzipay_buyer_id"
//    case iyzipaySecretKey = "iyzipay_secret_key"
//    case iyzipayBuyerName = "iyzipay_buyer_name"
//    case iyzipayBuyerSurname = "iyzipay_buyer_surname"
//    case iyzipayBuyerGSMNumber = "iyzipay_buyer_gsm_number"
//    case iyzipayBuyerEmail = "iyzipay_buyer_email"
//    case iyzipayIdentityNumber = "iyzipay_identity_number"
//    case iyzipayAddress = "iyzipay_address"
//    case iyzipayCity = "iyzipay_city"
//    case iyzipayCountry = "iyzipay_country"
//    case iyzipayZip = "iyzipay_zip"
//    case googleMapAPIKey = "google_map_api_key"
//    case payuPayment = "payu_payment"
//    case payuMode = "payu_mode"
//    case payuMerchantID = "payu_merchant_id"
//    case payuSecretKey = "payu_secret_key"
//    case payuBuyerName = "payu_buyer_name"
//    case payuBuyerSurname = "payu_buyer_surname"
//    case payuBuyerGSMNumber = "payu_buyer_gsm_number"
//    case payuBuyerEmail = "payu_buyer_email"
//    case preventSystem = "prevent_system"
//    case badLoginLimit = "bad_login_limit"
//    case lockTime = "lock_time"
//    case paystackPayment = "paystack_payment"
//    case paystackSecretKey = "paystack_secret_key"
//    case twilioChatCall = "twilio_chat_call"
//    case agoraChatCall = "agora_chat_call"
//    case agoraChatAppID = "agora_chat_app_id"
//    case agoraChatAppCertificate = "agora_chat_app_certificate"
//    case agoraChatCustomerID = "agora_chat_customer_id"
//    case agoraChatCustomerSecret = "agora_chat_customer_secret"
//    case liveVideo = "live_video"
//    case liveVideoSave = "live_video_save"
//    case agoraLiveVideo = "agora_live_video"
//    case agoraAppID = "agora_app_id"
//    case agoraAppCertificate = "agora_app_certificate"
//    case agoraCustomerID = "agora_customer_id"
//    case agoraCustomerCertificate = "agora_customer_certificate"
//    case amazoneS32 = "amazone_s3_2"
//    case bucketName2 = "bucket_name_2"
//    case amazoneS3Key2 = "amazone_s3_key_2"
//    case amazoneS3SKey2 = "amazone_s3_s_key_2"
//    case region2 = "region_2"
//    case qqAppID = "qqAppId"
//    case qqAppkey
//    case weChatAppID = "WeChatAppId"
//    case weChatAppkey = "WeChatAppkey"
//    case discordAppID = "DiscordAppId"
//    case discordAppkey = "DiscordAppkey"
//    case mailruAppID = "MailruAppId"
//    case mailruAppkey = "MailruAppkey"
//    case qqLogin
//    case weChatLogin = "WeChatLogin"
//    case discordLogin = "DiscordLogin"
//    case mailruLogin = "MailruLogin"
//    case twilioProvider = "twilio_provider"
//    case bulksmsProvider = "bulksms_provider"
//    case bulksmsUsername = "bulksms_username"
//    case bulksmsPassword = "bulksms_password"
//    case messagebirdProvider = "messagebird_provider"
//    case messagebirdKey = "messagebird_key"
//    case messagebirdPhone = "messagebird_phone"
//    case authorizePayment = "authorize_payment"
//    case authorizeLoginID = "authorize_login_id"
//    case authorizeTransactionKey = "authorize_transaction_key"
//    case authorizeTestMode = "authorize_test_mode"
//    case securionpayPayment = "securionpay_payment"
//    case securionpayPublicKey = "securionpay_public_key"
//    case securionpaySecretKey = "securionpay_secret_key"
//    case inviteLinksSystem = "invite_links_system"
//    case userLinksLimit = "user_links_limit"
//    case expireUserLinks = "expire_user_links"
//    case infobipProvider = "infobip_provider"
//    case infobipUsername = "infobip_username"
//    case infobipPassword = "infobip_password"
//    case msg91Provider = "msg91_provider"
//    case msg91AuthKey = "msg91_authKey"
//    case autoUserLike = "auto_user_like"
//    case developersPage = "developers_page"
//    case isRTL = "is_rtl"
//    case uri
//    case s3SiteURL2 = "s3_site_url_2"
//
//    case customFields = "custom_fields"
//}
