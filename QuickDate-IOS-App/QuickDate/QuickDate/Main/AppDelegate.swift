

import UIKit

import OneSignal
import QuickDateSDK
import GoogleSignIn
import IQKeyboardManagerSwift

//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSSubscriptionObserver {
    
    // MARK: - Properties
    var window: UIWindow?
    
    var isInternetConnected = Connectivity.isConnectedToNetwork()
    let hostNames = ["google.com", "google.com", "google.com"]
    //    var hostIndex = 0
    
    var launchOptions = [UIApplication.LaunchOptionsKey: Any]()
    var application:UIApplication?
    
    // Property Injections
    private let appNavigator: AppNavigator = .shared
    private let networkObserver: NetworkObserver = .shared
    private var appManager: AppManager?
    
    // MARK: - Functions
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        networkObserver.startHost(hostNames, at: 0)
        //        startHost(at: 0)
        /* Decryption of Cert Key */
        ServerCredentials.setServerDataWithKey(key: AppConstant.key)
        appManager = AppManager.shared
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.main.async {
            AppInstance.shared.fetchContacts()
        }
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        let status = UserDefaults.standard.getDarkMode(Key: "darkMode")
        let isSystemTheme = UserDefaults.standard.getSystemTheme(Key: "SystemTheme")
        if #available(iOS 13.0, *) {
            if isSystemTheme {
                window?.overrideUserInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            }else {
                if status {
                    window?.overrideUserInterfaceStyle = .dark
                } else {
                    window?.overrideUserInterfaceStyle = .light
                }
            }
        }        
        if #available(iOS 15.0, *) {
            UITableView.appearance().isPrefetchingEnabled = false
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        self.launchOptions = launchOptions ?? [:]
        self.application = application
        initializeOneSignal(launchOptions)
        appManager?.initializeFacebookFramework(application, didFinishLaunchingWithOptions: launchOptions)        
        let defaults: Defaults = .shared
        
        if defaults.get(for: .didLogUserIn) ?? false {
            switch isInternetConnected {
            case false: appNavigator.start(from: .noInternet)
            case true:  appNavigator.start(from: .mainTab)
            }
        } else {
            appNavigator.start(from: .authentication)
            //            if let vc = R.storyboard.authentication.newStartViewController() {
            //                if let window = UIApplication.shared.windows.first{
            //                    window.rootViewController = vc
            //                    window.makeKeyAndVisible()
            //                }
            //            }
        }
        
        return true
    }
    
    private func initializeOneSignal(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // OneSignal initialization
        let oneSignalInitSettings = [kOSSettingsKeyAutoPrompt: false,kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
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
    // get deviceID(playerID) at first downloading the app
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            UserDefaults.standard.setDeviceId(value: playerId, ForKey: Local.DEVICE_ID.DeviceId)
        }
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.debug("applicationDidEnterBackground")
        appManager?.saveSettingsToLocalDataBase()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.debug("applicationWillTerminate")
        appManager?.saveSettingsToLocalDataBase()
        //        networkObserver.stopToObserve()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
