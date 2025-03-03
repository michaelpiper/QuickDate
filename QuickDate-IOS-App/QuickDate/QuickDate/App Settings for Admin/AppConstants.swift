
import Foundation
import UIKit


struct AppConstant {
    //cert key for Quickdate
    //Demo Key
    /*
     VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OT1JuQkhXa2hPYUdKVlZqVldWekZ2WVRGSmVGZHFXbGhXUlRWTVdUQmtUMU5XVmxsV2JIQk9ZVzEzZHlOV01uaFRVekpGZUdORmFGaFhSM2hoV1ZkemVFMUdVWGRWYlRWc1lYcFZNVlJWVWtOVWJGcElXa1JhVlZKc1NubFVWbFUxVTBaU1dWVnJOVk5TV0VKNFZqRlNTMVJ0Vm5KUFZtaFdWMGQ0YUZWcldsWk5RVDA5UURFME9UZzFPQ1F5TkRNNE5qY3lNZz09
     
     
     */
    
    //Demo Key
    
    static let key = "Vm0wd2QyVkZOVWRXV0docFVteHdUMVp0TVZOWFZteDBZM3BHYUZKc1ZqTlhhMUpUVm14S2MxTnNiR0ZXVjJoeVZrUkdTMk14U25GVmJHUnBWa1ZhU1ZadGNFdFRNVmw0V2toV2FsSnRVbGhhVjNSaFRXeGFkR05GU214U01EVllWVEo0VjFWdFNrZGpTRUpXWVd0d2RsWkdXbUZUUjFaSVVtMTBUbFl4U2xsV2EyTXhWVEpHVjFOWWJHaFNWR3hYV1Zkek1WUXhVbk5VVkZKUVZsaE9NMVV4VWxkWlZtUkdVMnRPVlZkSE9UTlpNblF6WlVaa1dXRkdhR2xTTVVwM1ZrWmFZVll3TUhoVmJHUlhZbFJzV0ZacVFsZE9WbkJXVjIxR1YwMXJWalJaTUZKUFZqRkplbUZFVGxkaGExcFlXa1phVTJOck9WZFViV3hvVFVoQ1MxWnRjRXROUjBsNFZWaHNVMkV5YUZWWmExcDNWMFpzV0dWSFJsaFNiSEF4V1RCV2EyRXlTa2hsUmxwV1lsaFNNMWxyV2t0a1JsWjFZVVprVG1KdGFESldiWEJIVXpGYVYxZHVTazVXYldoWVZXeFdkMlZXV25KVmEyUlZUVlpzTkZZeU5VOWhWa3AwVlc1Q1ZrMUdXa3hXVlZwclZqRnJlbUZGTlU1aVJXdzJWbFZhVW1ReVRuSmxSRnBPVmxSR1YxWnVjRmRqTVZKelYyeGFhbUV6WnpKVVZscFhWakpLUm1OR2JGaFdiRnBvV1hwQk1XTXhVbk5pUjNCVFZrWmFVRmRXVWt0bGJWWkhWMWhvWVZOSFVuRlpXSEJIWlZaU1YxZHRPVmROVjFKS1ZWZDRSMVl5Um5KWGEyUmhWbFp3VkZZd1ZYaFdhelZZWlVaa1YxSnJhM2hXYlhocVpVVTFSMVZ1VWxkaWEzQlZXVzF6TVZac1duVmpSV1JZVW0xNGVsWnNhRzlVTWtwR1RsUkNWVlpzVlRGWmEyUkdaREZrVlZOc1pFNWliRXA1Vm10amVGVnRVWGRPVmxwVVlrVmFXRlZyVmtaT1ZrMTZZWHBTVUZac2JEVldWM0JIVlVaS1dWcDZSbFJOTW5Nd1ZERmFZV1JGTVZWUmJXaE9Va1phU2xaWGVHOWlNV3hYVkd0a1ZHSkhVbGhVVldSVFZrWmFWbGRzV210TldFSkdWbGQ0YjFVeVNrbFJhbFpYWWxSQmVGbFVSbXRqTVdSMVZHMXdWRkl6YUZsV1JtUjNWakZXUjFkcmFHeFNXRkp4VkZaV2QyVkdXbGhsUnpsb1VsUkdXRmt3YUhOWFJscHpZMGRvV0Zac2NHaFdNRnBQWTJ4d1IxcEhiRk5pU0VKYVZtMHdlRTFIVVhoVGJHUllZbXR3YUZWcldrdFhWbXh6VjJ0a1RrMVdTbGhXYlhoclZtc3hjbU5GYUZkTmJtaFVWakl4Um1WR1pIRlViRlpwVjBkb2VWWnRjRWRoTWsxNFdraFNiRkpyTlU5VmExcGhWMnhhZEUxSWFFOVNNREUwVmpJMVUxVXlSbk5qUm1oYVlURndURlp0ZUdGa1IxWkpXa1pvVTJKRmNGZFdWekUwWkRKS1IxTnVVbFppYmtKWVZXcE9iMkZHV2toTlZWcHNVakExUjFscldtOVdNVXBXWTBSS1YySkdTa2hXTWpGWFVqSk9SbGR0YUZOaVNFSjNWbGQ0VjJReVNYaFhibEpxVWxSc1YxUldWVEZUUmxwWVpVaE9XR0pXV2pCYVZWcExWakZhYzFKcVRsVk5WVlUxVlVaRk9WQlJQVDA9/LHBhc3M9/UmpaeVJFaGxOVXBNTVhoYVRUSmlaME5uYm4xZmNtUjRTbGw0TkZSMlQyWlJkV2xqYXlSVmNsSm1OVEpyTmlSRVlYUmxLaVI1V1ZoUkszQkRhRjQ1TkRnbQ=="
    
}

// MARK: - ControlSettings

struct ControlSettings {
    
    static let AppName = "Rosmance"
    
    // MARK: Social Login Settings
    // Change these values according to your choice
    static let showFacebookLogin = true
    static let showGoogleLogin = true
    static let showWoWonderLogin = true
    
    static let agoraCallingToken = "a32621ab5952434a9cbb8bfd64b629a0"//"cea80c3b9a744f69ba90a68d07ca9167"
    static let agoraAppID = "40c142727b8247a2b9eb220bf06cb070"//"8b5c5b3b604a4f37bd6056175a1c76d6"

    static let isVideo = true
    static let isAudio = true
    static var shouldShowAddMobBanner:Bool = true
    
    static var interestialCount:Int? = 3
    
    static var aboutUS = "https://quickdatescript.com/about"
    static var help_app = "https://quickdatescript.com/contact"
    static var terms = "https://quickdatescript.com/terms"
    static var privacy = "https://quickdatescript.com/privacy"
    
    /*
     * change it with your wowonder Script Server key
     */
    static let wowonder_ServerKey = "131c471c8b4edf662dd0ebf7adf3c3d7365838b9"
    /*
     * change it with your wowonder Script URL
     */
    static let wowonder_URL = "https://demo.wowonder.com/"
    /*
     * change it with your banner Ad ID
     */
    static let addUnitId = "ca-app-pub-3940256099942544/2934735716"
    /*
     * change it with your InterestialAddUnit ID
     */
    static let googleInterstitialAdsUnitId = "ca-app-pub-3940256099942544/4411468910"
    /* 
     * change it with your facebook placementID 
     */
    static let addsOfFacebookPlacementID = "1121123558333256_1121124154999863"
//    static let addsOfFacebookPlacementID = "YOUR_PLACEMENT_ID"

    static let googleClientKey = "497109148599-u0g40f3e5uh53286hdrpsj10v505tral.apps.googleusercontent.com"
    static let googleApiKey = "AIzaSyB53ZP5QZzkT0a4aABB8wv0wIDAk0bgxmc"
    //
    
    /*
     * change it with your onesignal app ID
     */
    static let oneSignalAppId = "5615ee75-d301-4681-9e6e-b8e32a21fb21"
    /*
     * Change it with your stripe ID
     */
    static let stripeId = "pk_test_1ujWeV5SjafkpuEK7NMpURNz"
    
    /*
     * Get google API key and remove it with yours
     */
    static let googlePlacesAPIKey = "AIzaSyB53ZP5QZzkT0a4aABB8wv0wIDAk0bgxmc"
    
    /*
     * if you want to enable facebook ads, make facebook variable value to true and google variable value to false
     * if you want to enable google ads, make google variable value to true and facebook variable value to false
     */
    static let facebookAds = false
    static let googleAds = true
    
    //you will get this from brainTree Sandbox account
    static let paypalAuthorizationToken = "sandbox_zjzj7brd_fzpwr2q9pk2m568s"
    /*
     * in this you need replace your bundle id before .payment
     * you need to add this URL scheme in your Project info list
     */
    static let BrainTreeURLScheme = "com.nazmiyavuz.app.ios.app.payments"
    
}

extension UIColor {
    
    //    64265C
    //64265C
    
    //Main colors will be change from AppSetting Theme class
    
    @nonobjc class var Main_StartColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#64265C")
    }
    @nonobjc class var Main_EndColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#A731A0")
    }
    @nonobjc class var Button_StartColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#64265C")
    }
    @nonobjc class var Button_EndColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#A731A0")
    }
    @nonobjc class var Button_TextColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#FFFFFF")
    }
    
    @nonobjc class var PrimaryColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#FF007F")
    }
    
    @nonobjc class var SecondaryColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#BF00FF")
    }
    
    
}
