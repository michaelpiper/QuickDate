//
//  AppManager.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 5.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import UIKit
import Async
import DropDown
import FBAudienceNetwork
import FBSDKLoginKit
import GoogleSignIn
import GoogleMobileAds
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import JGProgressHUD
import OneSignal
import Reachability
import RealmSwift
import Stripe
import SwiftEventBus
import SwiftyBeaver
import SwiftUI
import QuickDateSDK

final class AppManager {
    // Instance
    static let shared = AppManager()
    private let isInternetConnected = Connectivity.isConnectedToNetwork()
    private let defaults: Defaults = .shared
    
    // MARK: - Properties
    // Property Injections
    internal let appInstance: AppInstance = .shared
    internal let networkManager: NetworkManager = .shared
    // create realm to access realSwift database
    private var hud: JGProgressHUD?
    internal let realm = try? Realm()
    // Local Data Objects
    private var localAdminSetting: AdminSettings?
    private var localUserSettings: UserSettings?
    private var giftsAndStickers: GiftsAndStickers?
    
    private var adminSavingData: Data?
    private var profileSettingsData: Data?
    internal var giftsData: Data?
    internal var stickersData: Data?

    var onResetFilter: (() -> ())?
    var onUpdateProfile: (() -> ())?
    
    // MARK: - Initializer
    
    private init() {
        // Local Database
        initializeRealmClasses()
        fetchRealmObjects()
        fetchAdminSettingsFromRealmSwift()
        fetchUserSettingsFromRealmSwift()
        fetchFiltersFromLocalData()
        // Frameworks
        initializeGoogleFrameworks()
        initializeFacebookAds()
        initializeBrainTree()
        // TODO: initializeSwiftyBeaver will be deleted after all changes will have been completed.
        //        initializeSwiftyBeaver()
        initializeIQKeyboardManager()
        initializeDropDown()
        initializeStripe()
        initializeA4WPurchaseManager()
        setArabicLanguageDirection()
        
    }
    
    // TODO: Change this function and local database logic
    
    private func initializeRealmClasses() {
        let isAdminSettings = realm?.object(ofType: AdminSettings.self, forPrimaryKey: 1) == nil
        let isUserSettings = realm?.object(ofType: UserSettings.self, forPrimaryKey: 1) == nil
        let isGiftAndSticker = realm?.object(ofType: GiftsAndStickers.self, forPrimaryKey: 1) == nil
        
        guard isAdminSettings && isUserSettings && isGiftAndSticker else { return }
        
        let adminSettings = AdminSettings()
        adminSettings.id = 1
        let userSettings = UserSettings()
        userSettings.id = 1
        let giftAndSticker = GiftsAndStickers()
        giftAndSticker.id = 1
        
        do {
            try realm?.write {
                realm?.add(adminSettings, update: .all)
                realm?.add(userSettings, update: .all)
                realm?.add(giftAndSticker, update: .all)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Frameworks Setups
    
    func initializeFacebookFramework(_ application: UIApplication, didFinishLaunchingWithOptions
                                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    private func initializeFacebookAds() {
        // FIXME: Uncomment for testing Facebook Ads
        /// If you want to test facebook ads, uncomment the lines below.
        //        FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
        //        FBAdSettings.clearTestDevice(FBAdSettings.testDeviceHash())
    }
    
    // Private Setups
    
    private func initializeGoogleFrameworks() {
        GMSServices.provideAPIKey(ControlSettings.googlePlacesAPIKey)
        GMSPlacesClient.provideAPIKey(ControlSettings.googlePlacesAPIKey)
        // TODO: Change this
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    private func initializeBrainTree() {
        //BTAppSwitch.setReturnURLScheme(ControlSettings.BrainTreeURLScheme)
    }
    
    private func initializeIQKeyboardManager() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Dismiss"
    }
    
    private func initializeDropDown() {
        DropDown.startListeningToKeyboard()
    }
    
    private func initializeStripe() {
        Stripe.setDefaultPublishableKey(ControlSettings.stripeId)
    }
    
    private func initializeA4WPurchaseManager() {
        A4WPurchaseManager.shared.initialize()
    }
    
    private func setArabicLanguageDirection() {
        let preferredLanguage = NSLocale.preferredLanguages[0]
        let isArabic = preferredLanguage.starts(with: "ar")
        UIView.appearance().semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
    }
    
    /// Turn Data to [JSON](x-source-tag://JSON) Format
    /// - Parameter data: Data format
    /// - Returns: [JSON](x-source-tag://JSON)
    private func getDataWithJSONFormat(from data: Data) -> JSON {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDictionary = json as? JSON,
              let settingsData = jsonDictionary["data"] as? JSON else {
                  Logger.error("getting json and jsonDictionary"); return [:]
              }
        return settingsData
    }
    
}

// MARK: - Reload All Data

extension AppManager {
    // TODO: Add this code to dashboard
    /// Reload all data to handle changes by the admin and the user
    func reloadAllDataFromRemoteDatabase() {
        fetchAdminSettingsFromRemoteServer()
        fetchUserProfile()
        fetchGiftsFromRemoteServer()
        fetchStickersFromRemoteServer()
    }
    
    private func fetchFiltersFromLocalData() {
        let filters = defaults.get(for: .trendingFilter) ?? TrendingFilter()
        appInstance.trendingFilters = filters
    }
}

// MARK: - Admin Settings

extension AppManager {
    
    /// During first opening every time settings will be fetched from local data base
    func fetchAdminSettingsFromRealmSwift() {
        let settings = realm?.object(ofType: AdminSettings.self, forPrimaryKey: 1)
        if let data = settings?.localData {
            self.adminSavingData = data
            let adminData = self.getDataWithJSONFormat(from: data)
            self.appInstance.adminSettings = AdminAppSettings(dict: adminData)
        } else {
            fetchAdminSettingsFromRemoteServer()
        }
    }
    
    /// Every time adminSettings will fetch from remote server in the background
    /// during first opening the app in order to handle changes which is done by Admin
    func fetchAdminSettingsFromRemoteServer() {
        let locale = Locale.preferredLanguages.first
        Logger.verbose("Language = \(String(describing: locale))")
        let language = NSLocale.preferredLanguages[0]
        
        guard let url = URL(string: API.COMMON_CONSTANT_METHODS.GET_OPTIONS_API) else {
            Logger.error("getting URL"); return
        }
        
        GetSettingsManager.instance.getSettings(language: language) { success, sessionError, err in }
        let params: APIParameters = [API.PARAMS.language: language]
        
        Async.background({
            self.networkManager.fetchData(with: url,
                                          method: .post, parameters: params)
            { (result: Result<Data, NetworkError>) in
                switch result {
                case .failure(let error):
                    Logger.error(error)
                case .success(let data):
                    self.adminSavingData = data
                    let adminData = self.getDataWithJSONFormat(from: data)
                    self.appInstance.adminSettings = AdminAppSettings(dict: adminData)
                }
            }
        })
    }
}

// MARK: - User Settings

extension AppManager {
    
    /// During first opening every time settings will be fetched from local data base
    func fetchUserSettingsFromRealmSwift() {
        // Fetch accessToken and userId
        getUserSession()
        let settings = realm?.object(ofType: UserSettings.self, forPrimaryKey: 1)
        if let data = settings?.localData {
            self.profileSettingsData = data
            let userData = getDataWithJSONFormat(from: data)
            self.appInstance.userProfileSettings = UserProfileSettings(dict: userData)
        } else {
            fetchUserProfile()
        }
    }
    
    @discardableResult
    func getUserSession() -> (userID: Int, accessToken: String)? {
        
        let accessToken = defaults.get(for: .accessToken)
        let userID = defaults.get(for: .userID)
        guard let accessToken = accessToken,
              let userID = userID else { return nil }
        
        self.appInstance.accessToken = accessToken
        self.appInstance.userId = userID
        
        return (userID, accessToken)
    }
    
    func fetchUserProfile() {
        let session = getUserSession()
        if let session = session {
            let params: APIParameters = [
                API.PARAMS.user_id: "\(session.userID)",
                API.PARAMS.access_token: session.accessToken,
                API.PARAMS.fetch: "data,media,likes,blocks,payments,reports,visits"
            ]
            Async.background({ [self] in
                networkManager.fetchData(with: API.USERS_CONSTANT_METHODS.PROFILE_API,
                                         method: .post,
                                         parameters: params) { (result: Result<Data, NetworkError>) in
                    switch result {
                    case .failure(let error):
                        Logger.error(error)
                    case .success(let data):
                        self.profileSettingsData = data
                        let userData = self.getDataWithJSONFormat(from: data)
                        AppInstance.shared.userProfileSettings = UserProfileSettings(dict: userData)
                        self.onUpdateProfile?()
                    }
                }
            })
        }
    }
}

// MARK: - Handling Realm

extension AppManager {
    
    private func fetchRealmObjects() {
        localAdminSetting = realm?.objects(AdminSettings.self).first
        localUserSettings = realm?.objects(UserSettings.self).first
        giftsAndStickers = realm?.objects(GiftsAndStickers.self).first
    }
    
    private func saveAdminSettingsToRealm() {
        guard let adminSavingData = adminSavingData else {
            Logger.error("getting gift data"); return
        }
        
        do {
            try realm?.write {
                self.localAdminSetting?.localData = adminSavingData
                self.localAdminSetting?.updatedDate = Date()
            }
        } catch {
            Logger.error(error)
        }
    }
    
    private func saveUserProfileSettingsToRealm() {
        guard let profileSettingsData = profileSettingsData else {
            Logger.error("getting gift data"); return
        }
        do {
            try realm?.write {
                self.localUserSettings?.localData = profileSettingsData
                self.localUserSettings?.updatedDate = Date()
            }
        } catch {
            Logger.error(error)
        }
    }
    
    func saveGiftsAndStickersToRealm() {
        guard let giftsData = giftsData else {
            Logger.error("getting gift data"); return
        }
        guard let stickersData = stickersData else {
            Logger.error("getting gift data"); return
        }
        
        do {
            try realm?.write {
                self.giftsAndStickers?.giftsData = giftsData
                self.giftsAndStickers?.stickersData = stickersData
                self.giftsAndStickers?.updatedDate = Date()
            }
        } catch {
            Logger.error(error)
        }
    }
    
    func saveSettingsToLocalDataBase() {
        saveAdminSettingsToRealm()
        saveUserProfileSettingsToRealm()
        saveGiftsAndStickersToRealm()
    }
}
