

import UIKit

import Async
import DropDown
import FBSDKLoginKit
import GoogleSignIn
import GoogleMobileAds
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import OneSignal
import Reachability
import Stripe
import SwiftEventBus
import SwiftyBeaver
import QuickDateSDK

/// - Tag: SplashScreenVC
class SplashScreenVC: BaseViewController, OSSubscriptionObserver {
    
    // MARK: - Views
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showStack: UIStackView!
    
    // MARK: - Properties
    // Property Injections
    private let appNavigator: AppNavigator
    private let appManager: AppManager = .shared
    
    // MARK: - Initialiser
    init?(coder: NSCoder, navigator: AppNavigator) {
        self.appNavigator = navigator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeSettingsClass()
        
        self.initializeOneSignal()
        
        self.initFrameworks()
        self.activityIndicator.startAnimating()
        
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.showStack.isHidden = false
            self.fetchUserProfile()
        }
        
        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            // no need
//            self.showStack.isHidden = true
//            self.activityIndicator.stopAnimating()
        }
        self.fetchUserProfile()
    }
    deinit {
        SwiftEventBus.unregister(self)
        
    }
    
    private func fetchUserProfile() {
//        if appDelegate.isInternetConnected{
//            self.activityIndicator.startAnimating()
////            let status = AppInstance.shared.getUserSession()
//            let status = true
//
//            if status{
//
//                if (AppInstance.shared.accessToken == "") ||
//                    (AppInstance.shared.accessToken == nil) {
//
//                    SwiftEventBus.unregister(self)
//                    appNavigator.navigate(to: .mainTab)
//
//                } else {
//
//                    self.showStack.isHidden = true
//                    self.activityIndicator.stopAnimating()
//                    let dashboardNav =  R.storyboard.main.mainTabBarViewController()
//                    dashboardNav?.modalPresentationStyle = .fullScreen
//                    self.present(dashboardNav!, animated: true, completion: nil)
//
//                    let userId = AppInstance.shared.userId ?? 0
//                    let accessToken = AppInstance.shared.accessToken ?? ""
//                    Async.background({
//                        ProfileManger.instance.getProfile(UserId: userId, AccessToken: accessToken, FetchString: "data,media,likes,blocks,payments,reports,visits", completionBlock: { (success, sessionError, error) in
//                            if success != nil{
//                                Async.main({
//                                    let data = success?["data"] as? [String:Any]
////                                    AppInstance.shared.userProfile = data ?? [:]
//                                    SwiftEventBus.unregister(self)
//                                })
//                            }else if sessionError != nil{
//                                Async.main({
//                                    self.activityIndicator.stopAnimating()
//                                    self.showStack.isHidden = true
//                                    let errors = sessionError?["errors"] as? [String:Any]
//                                    let errorText = errors?["error_text"] as? String
//                                    Logger.error("sessionError = \(errorText ?? "")")
//                                    self.view.makeToast(errorText ?? "")
//                                })
//
//                            }else {
//                                Async.main({
//                                    self.activityIndicator.stopAnimating()
//                                    self.showStack.isHidden = true
//                                    Logger.error("error = \(error?.localizedDescription ?? "")")
//                                    self.view.makeToast(error?.localizedDescription)
//                                })
//                            }
//
//                        })
//                    })
//                }
//
//            }else{
//                SwiftEventBus.unregister(self)
//                appNavigator.navigate(to: .authentication)
//            }
//        }else {
//            self.view.makeToast(InterNetError)
//        }
    }
    
    func initializeSettingsClass() {
        /* Init Settings.Class */
//        let data = UserDefaults.standard.getSettings(Key: Local.SETTINGS.Settings)
//        let settingsObject = try? PropertyListDecoder().decode(GetSettingsModel.DataClass.self ,from: data!)
//        if settingsObject != nil{
//            AppInstance.shared.adminSettings = settingsObject!
//        }else{
//            appManager.saveSettingsToLocalDataBase()
//        }
        
    }
    
    func initializeOneSignal() {
        // OneSignal initialization
        let oneSignalInitSettings = [kOSSettingsKeyAutoPrompt: false,kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(appDelegate.launchOptions,
                                        appId: ControlSettings.oneSignalAppId,
                                        handleNotificationAction: nil,
                                        settings: oneSignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        OneSignal.add(self as OSSubscriptionObserver)
        
        // Recommend moving the below line to prompt for push after informing the user about
        // how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            Logger.verbose("User accepted notifications: \(accepted)")
        })
    }
    
    func initFrameworks() {
        ApplicationDelegate.shared.application(appDelegate.application!, didFinishLaunchingWithOptions: appDelegate.launchOptions)
        DropDown.startListeningToKeyboard()
        GMSServices.provideAPIKey(ControlSettings.googlePlacesAPIKey)
        GMSPlacesClient.provideAPIKey(ControlSettings.googlePlacesAPIKey)
        
        A4WPurchaseManager.shared.initialize()
        
        let preferredLanguage = NSLocale.preferredLanguages[0]
        
        if preferredLanguage.starts(with: "ar"){
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        let status = UserDefaults.standard.getDarkMode(Key: "darkMode")
        
        // TODO: Change this
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //BTAppSwitch.setReturnURLScheme(ControlSettings.BrainTreeURLScheme)
        
        /* Stripe of Setup */
        Stripe.setDefaultPublishableKey(ControlSettings.stripeId)
       
        
        /* Init Swifty Beaver */
//        let console = ConsoleDestination()
//        let file = FileDestination()
//        log.addDestination(console)
//        log.addDestination(file)
        
        
        /* IQ Keyboard */
        
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        //
        
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            UserDefaults.standard.setDeviceId(value: playerId ?? "", ForKey: Local.DEVICE_ID.DeviceId)
        }
    }
    
}
