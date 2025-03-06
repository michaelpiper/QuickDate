# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

target 'QuickDate' do
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'GoogleSignIn'
  pod 'ESTabBarController-swift'
  pod 'IQKeyboardManagerSwift'
  pod 'Koloda'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage'
  pod 'Toast'
  pod 'SwiftEventBus'
  pod 'SwiftyBeaver'
  pod "AsyncSwift"
  pod 'DropDown'
  pod 'JGProgressHUD'
  pod 'R.swift'
  pod 'Toast-Swift'
  pod 'FittedSheets'
  pod 'ReachabilitySwift'
  pod 'WARangeSlider'
  pod 'Braintree'
  pod 'BraintreeDropIn'
  pod 'Shuffle-iOS'
  pod 'Stripe'
  #  pod 'TwilioVoice', '~> 3.0'
  pod 'TwilioVoice'
  pod 'TwilioVideo'#, '~> 2.3'
  pod 'XLPagerTabStrip'
  pod 'TwilioChatClient'
  pod 'Google-Mobile-Ads-SDK'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'FBAudienceNetwork'
  pod 'RealmSwift'
  pod 'AgoraRtcEngine_iOS'
  pod 'razorpay-pod'
  #  pod 'LazyPay'
  #  pod 'SecurionPay', "~> 1.10.1"
  pod 'AuthorizeNetAccept'
  pod 'lottie-ios'
  
  # Extensible animation framework for iOS and OS X.
  pod 'pop', '~> 1.0'
end

target 'OneSignalNotificationServiceExtension' do
  use_frameworks!
  pod 'OneSignal', '>= 2.6.2', '< 3.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
