//
//  DashboardViewController+SwipeHandling.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 5.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds
import QuickDateSDK
import Braintree
import Razorpay
import Alamofire

extension DashboardViewController {
    
    private func showAdd() {
        guard ControlSettings.shouldShowAddMobBanner else { return }
        
        if ControlSettings.facebookAds {
            initializeFacebookAds()
        } else if ControlSettings.googleAds {
            showGoogleAdd()
        }
    }
    
    internal func handleProgressWithSwipe(with progress: Int) {
        
        if progress % 3 == 0 {
            showAdd(); return
        }
        
        if progress % 7 == 0 {
            if appInstance.userProfileSettings?.balance == 0.0 {
                goToCreditPage()
            } else {
                showAdd()
            }
            return
        }
        
        if progress % 10 == 0 {
            if (appInstance.userProfileSettings?.is_pro ?? false) == false {
                goToUpgradeAccount()
            } else {
                showAdd()
            }
            return
        }
        
    }
    
    func goToCreditPage() {
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func goToUpgradeAccount() {
        let vc = R.storyboard.credit.upgradeAccountVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

// MARK: - Google Ads
extension DashboardViewController: GADFullScreenContentDelegate {
    
    internal func createGoogleAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: ControlSettings.googleInterstitialAdsUnitId,
                               request: request, completionHandler: { [self] ad, error in
            if let error = error {
                Logger.error(error); return
            }
            googleInterstitial = ad
            googleInterstitial?.fullScreenContentDelegate = self
        })
    }
    
    private func showGoogleAdd() {
        if googleInterstitial != nil {
            googleInterstitial?.present(fromRootViewController: self)
        } else {
            Logger.error("getting google add")
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.error("Ad did fail to present full screen content.")
        createGoogleAds()
    }
    
    /// Tells the delegate that the ad presented full screen content.
    //    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    //        Logger.debug("Ad did present full screen content.")
    //
    //    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Logger.debug("Ad did dismiss full screen content.")
        createGoogleAds()
    }
    
}

// MARK: - Facebook Ads
extension DashboardViewController: FBInterstitialAdDelegate  {
    
    internal func initializeFacebookAds() {
        let interstitialAd = FBInterstitialAd(
            //            placementID: ControlSettings.addsOfFacebookPlacementID
            placementID: "YOUR_PLACEMENT_ID"
        ) // "YOUR_PLACEMENT_ID" for testing
        
        interstitialAd.delegate = self
        interstitialAd.load()
        self.facebookInterstitial = interstitialAd
    }
    
    internal func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        guard interstitialAd.isAdValid else {
            return
        }
        print("Ad is loaded and ready to be displayed")
        interstitialAd.show(fromRootViewController: self)
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        Logger.error("Interstitial ad failed to load with error \(error.localizedDescription)")
    }
}

//MARK: - Upgrade Account Delegate -
extension DashboardViewController: UpgradeAccountDelegate {
    func selectedMemberShipType(_ price: Int, type: Int) {
        self.selectedAmount = price
        self.selectedMemberShip = type
        self.selectedPaymentType = "go_pro"
        if let viewController = R.storyboard.credit.paymentOpetionViewController() {
            viewController.delegate = self
            let panVC: PanModalPresentable.LayoutType = viewController
            presentPanModal(panVC)
        }
    }
}

//MARK: - Buy Credit Delegate -
extension DashboardViewController: BuyCreditDelegate {
    func selectedCreditType(_ index: Int, Amount: Int) {
        self.selectedAmount = Amount
        self.selectedCredit = ((index == 0) ? 1000 : (index == 1) ? 5000 : 10000)
        self.selectedPaymentType = "credit"
        if let viewController = R.storyboard.credit.paymentOpetionViewController() {
            viewController.delegate = self
            let panVC: PanModalPresentable.LayoutType = viewController
            presentPanModal(panVC)
        }
    }
}

//MARK: - Payment Options Delegate -
extension DashboardViewController: PaymentOptionDelegate {
    func selectedPaymentMethod(vc: PaymentOpetionViewController, _ type: PaymentName) {
        self.selectedPaymentMethod = type
        switch type {
        case .paypal:
            self.startPaypalCheckouts()
            break
        case .creditCard:
            let viewController = PaymentCardVC.instantiate(fromStoryboardNamed: .credit)
            viewController.amount = self.selectedAmount
            viewController.paymentType = .creditCard
            if selectedPaymentType == "go_pro" {
                viewController.memberShipType = self.selectedMemberShip
            }else {
                viewController.credits = self.selectedCredit
            }
            viewController.payType = self.selectedPaymentType
            viewController.delegate = self
            self.navigationController?
                .pushViewController(viewController, animated: true)
            break
        case .bank:
            let viewController = BankTransferVC.instantiate(fromStoryboardNamed: .credit)
            viewController.amount = self.selectedAmount
            viewController.credits = self.selectedCredit
            viewController.payType = self.selectedPaymentType
            self.navigationController?
                .pushViewController(viewController, animated: true)
            break
        case .razorPay:
            self.view.makeToast("Please wait.....")
            self.openRazorpayCheckout()
            break
        case .securionPay:
            break
        case .authorizeNet:
            let viewController = PaymentCardVC.instantiate(fromStoryboardNamed: .credit)
            viewController.amount = self.selectedAmount
            viewController.paymentType = .authorizeNet
            viewController.payType = self.selectedPaymentType
            viewController.delegate = self
            self.navigationController?
                .pushViewController(viewController, animated: true)
            break
        case .iyziPay:
            self.openIyziPayment()
            break
        case .cashfree:
            let popupVC = R.storyboard.popUps.cashfreePopupVC()
            popupVC?.delegate = self
            self.present(popupVC!, animated: true)
            break
        case .paystack:
            let popupVC = R.storyboard.popUps.payStackEmailPopupVC()
            popupVC?.delegate = self
            self.present(popupVC!, animated: true)
            break
        case .aamarPay:
            self.openAamarPayAPI()
            break
        case .flutterWave:
            let popupVC = R.storyboard.popUps.payStackEmailPopupVC()
            popupVC?.delegate = self
            self.present(popupVC!, animated: true)
            break
        case .coinbase:
            self.openCoinBasePayment()
            break
        case .ngenius:
            self.openNgeniusPayment()
            break
        }
    }
}

//MARK: - Paypal -
extension DashboardViewController {
    func startPaypalCheckouts() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: NSLocalizedString("Loading...", comment: "Loading..."))
            self.braintreeClient = BTAPIClient(authorization: ControlSettings.paypalAuthorizationToken)!
            let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient!)
            let request = BTPayPalCheckoutRequest(amount: "\(self.selectedAmount)")
            request.currencyCode = "USD"
            payPalDriver.tokenizePayPalAccount(with: request) { tokenizedPayPalAccount, error in
                if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                    self.dismissProgressDialog {
                        print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                    }
                } else if let error = error {
                    self.dismissProgressDialog {
                        self.view.makeToast(error.localizedDescription)
                        Logger.verbose("error = \(error.localizedDescription)")
                    }
                } else {
                    self.dismissProgressDialog {
                        self.view.makeToast(error?.localizedDescription ?? "")
                        Logger.verbose("error = \(error?.localizedDescription ?? "")")
                    }
                }
            }
        } else {
            self.view.makeToast(InterNetError)
        }
    }
}

//MARK: - Ngenius -
extension DashboardViewController: NgeniusPayWebViewDelegate {
    func ngeniusView(_ isSuccess: Bool, referanceID: String, credit: String) {
        //        self.view.makeToast("Payment Complete SuccessFully!.....", position: .center)
        print(referanceID)
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "credit": credit,
            "ref": referanceID
        ]
        PaymentManager.instance.fetchNgeniusSuccessPaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error, position: .center)
                    return
                }else {
                    if let url = Success?["message"] as? String {
                        self.view.makeToast(url, position: .center)
                        self.fetchProfile()
                    }
                }
            }
        }
    }
    
    
    func fetchProfile() {
        AppManager.shared.fetchUserProfile()
    }
    
    func openNgeniusPayment() {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "price": self.selectedAmount
        ]
        PaymentManager.instance.fetchNgeniusPaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .ngenius
                        vc.iyzipayJS = url
                        vc.ngeniusDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Coinbase -
extension DashboardViewController {
    func openCoinBasePayment() {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "price": self.selectedAmount
        ]
        PaymentManager.instance.fetchCoinbasePaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .coinbase
                        vc.iyzipayJS = url
                        //                        vc.aamarPayDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - FlutteWave -
extension DashboardViewController {
    func openFlutteWavePaymentMethodAPI(email: String) {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "type": self.selectedPaymentType,
            "email": email,
            "amount": self.selectedAmount
        ]
        PaymentManager.instance.fetchFlutteWavePaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .flutterWave
                        vc.iyzipayJS = url
                        vc.aamarPayDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Aamar Pay -
extension DashboardViewController: AamarPayWebViewDelegate {
    func aamarPayView(_ isSuccess: Bool, referanceID: String) {
        self.view.makeToast("Payment Complete SuccessFully!.....", position: .center)
        self.fetchProfile()
    }
    
    func openAamarPayAPI() {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "type": self.selectedPaymentType,
            "email": AppInstance.shared.userProfileSettings?.email ?? "",
            "name": AppInstance.shared.userProfileSettings?.fullname ?? "",
            "phone": "98989898898",
            "price": self.selectedAmount
        ]
        PaymentManager.instance.fetchAamarPaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .aamarPay
                        vc.iyzipayJS = url
                        vc.aamarPayDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - PayStack -
extension DashboardViewController: PayStackEmailPopupVCDelegate, PaystackWebViewDelegate {
    func webView(_ isSuccess: Bool, referanceID: String) {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "reference": referanceID,
            "pay_type": self.selectedPaymentType,
            "price": self.selectedAmount,
            "membershipType": self.selectedMemberShip,
            "amount": self.selectedAmount
        ]
        
        PayStackPaymentGatewayManager.instance.payStackPaymentSuccessAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error, position: .center)
                    return
                }else {
                    print(Success ?? [:])
                    self.fetchProfile()
                }
            }
        }
    }
    
    func handlePayStackPayNowButtonTap(email: String) {
        if self.selectedPaymentMethod == .flutterWave {
            self.openFlutteWavePaymentMethodAPI(email: email)
        }else {
            self.openPayStackPaymentMethodsAPI(email: email)
        }
    }
    
    func openPayStackPaymentMethodsAPI(email: String) {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "type": self.selectedPaymentType,
            "email": email,
            "price": self.selectedAmount
        ]
        PayStackPaymentGatewayManager.instance.payStackInitializeAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .paystack
                        vc.iyzipayJS = url
                        vc.paystackDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Card Payment Delegate -
extension DashboardViewController: PaymentCardViewDelegate {
    func cardView(_ isSuccess: Bool) {
        if isSuccess {
            self.fetchProfile()
        }
    }
}

//MARK: - Iyzi Pay -
extension DashboardViewController {
    func openIyziPayment() {
        self.showProgressDialog(with: "Loading...")
        let params: JSON = [
            API.PARAMS.access_token: AppInstance.shared.accessToken ?? "",
            API.PARAMS.price: self.selectedAmount
        ]
        
        PaymentManager.instance.iyzipayCreateSession(params: params) { stHtmlText, error in
            self.dismissProgressDialog {
                guard error == nil else {
                    self.view.makeToast(error)
                    return
                }
                if let text = stHtmlText {
                    guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                    vc.paymentType = .iyziPay
                    vc.iyzipayJS = text
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// MARK: - Razorpay Setup -
extension DashboardViewController: RazorpayProtocol, ExternalWalletSelectionProtocol, RazorpayPaymentCompletionProtocol {
    private func openRazorpayCheckout() {
        let options = [
            "amount" : self.selectedAmount * 100,
            "currency" : "INR",
            "description" : "Booking For: \(description)",
            "image" : UIImage(named: "Logo") ?? UIImage(),
            "name" : "Add To Balance",
            "prefill" :
                ["email" : "", "contact": ""],
            "theme" : ["color" : "#FF007E"]
        ] as [String : Any]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.razorpayObj?.open(options, displayController:  appDelegate.window?.rootViewController ?? self)
        (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = true
    }
    
    func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
        
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        self.view.makeToast("error: \(code) \(str)")
        (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        if let accessToken = AppInstance.shared.accessToken {
            PaymentManager.instance.razorPaySuccess(AccessToken: accessToken, payment_id: payment_id, merchant_amount: "\(self.selectedAmount)") { json, error in
                guard error == nil else {
                    self.view.makeToast(error)
                    (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
                    return
                }
                self.fetchProfile()
                self.view.makeToast(NSLocalizedString("The RazorPay transaction was complete.", comment: "The RazorPay transaction was complete"))
                (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
            }
        } else {
            self.view.makeToast("Something went wrong, please try again")
            (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
        }
    }
}

//MARK: - CashFree -
extension DashboardViewController: CashfreePopupVCDelegate {
    func handleCashfreePayNowButtonTap(name: String, email: String, phone: String) {
        //        self.initializeCashfreeWalletApi(name: name, email: email, phone: phone, amount: self.amount)
        createCashfreeOrderID(name: "Ravij", email: "ravijasoliya@yopmail.com", phone: "9898987878")
    }
    
    func createCashfreeOrderID(name: String, email: String, phone: String) {
        let urlString = "https://sandbox.cashfree.com/pg/orders"
        
        let detailsParam: JSON = [
            "customer_id": "4544587ftyffg",
            "customer_name": "Ravij",
            "customer_phone": "9898987878",
            "customer_email": "ravijasoliya@yopmail.com"
        ]
        
        let params: JSON = [
            "customer_details": detailsParam,
            "order_amount": 50,
            "order_currency": "INR"
        ]
        
        let header: HTTPHeaders = [
            "Content-Type":"application/json",
            "x-api-version":"2022-09-01",
            "x-client-id":"128533c99484c7e3061ceac5935821",
            "x-client-secret":"12eb1d28deb9af29f9e684157aeec4ea96f5b94d"
        ]
        
        AF.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { response in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                print(res)
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                
            }
        }
    }
}
