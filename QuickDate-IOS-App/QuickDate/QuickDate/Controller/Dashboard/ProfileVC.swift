//
//  ProfileVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import QuickDateSDK
import SafariServices
import Braintree
import Razorpay
import Alamofire
import MediaPlayer

class ProfileVC: BaseViewController {
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var lblCredit: UILabel!
    @IBOutlet var backView: UIView!
    
    var items: [[String : String]] = []
    
    private var selectedAmount = 0
    private var selectedCredit = 0
    private var selectedMemberShip = 1
    private var selectedPaymentType = ""
    var razorpayObj: RazorpayCheckout? = nil
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    var RAZOR_KEY_ID = "rzp_test_ruzI7R7AkonOIi"
    var selectedPaymentMethod: PaymentName = .flutterWave
    private var isProTest = true
    private var isPageLoaded: Bool?
    private var userSettings: UserProfileSettings?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        isPageLoaded = true
        RAZOR_KEY_ID = AppInstance.shared.adminAllSettings?.data?.razorpayKeyId ?? "rzp_test_ruzI7R7AkonOIi"
        razorpayObj = RazorpayCheckout.initWithKey(RAZOR_KEY_ID, andDelegate: self)
        razorpayObj?.setExternalWalletSelectionDelegate(self)
        
        //        SecurionPay.shared.publicKey = "pk_test_WoOlrf6NeiNsQkq9UBDz9Fsn"
        //        SecurionPay.shared.bundleIdentifier = "com.nazmiyavuz.app.ios.app"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
        
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func creditsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func popularityButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.main.boostVC()
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func lifeTimeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let isPro = userSettings?.is_pro, isPro {
            let vc = R.storyboard.popUps.premiumPopupVC()
            vc?.delegate = self
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true, completion: nil)
        }else{
            let vc = R.storyboard.credit.upgradeAccountVC()
            vc?.delegate = self
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        self.profileTableView.separatorStyle = .none
        self.profileTableView.register(UINib(resource: R.nib.profileSectionOneTableItem), forCellReuseIdentifier: R.reuseIdentifier.profileSectionOneTableItem.identifier)
        self.profileTableView.register(UINib(resource: R.nib.profileSectionTwoTableItem), forCellReuseIdentifier: R.reuseIdentifier.profileSectionTwoTableItem.identifier)
        profileTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        items = createItemList()
        profileTableView.reloadData()
        self.fetchProfile()
    }
    
    func fetchProfile() {
        AppManager.shared.fetchUserProfile()
        AppManager.shared.onUpdateProfile = { [self] in
            Async.main {
                self.userSettings = AppInstance.shared.userProfileSettings
                self.lblCredit.text = "\(self.userSettings?.balance ?? 0)"
                self.profileTableView.reloadData()
            }
        }
    }
    
    private func didSelectSection(_ indexPath: IndexPath) {
        let isPro = self.isProTest
        let row = isPro ? 1 : 0
        if isPro && indexPath.row == 0 {
            let vc = R.storyboard.live.liveUserVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == row { // favourite users
            let vc = R.storyboard.settings.listFriendsVC()
            navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == row + 1 { // invite friends
            let vc = R.storyboard.settings.favoriteVC()
            navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == row + 2 {
            let vc = R.storyboard.settings.likedUsersVC()
            navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.row == row + 3 {
            let vc = R.storyboard.settings.dislikeUsersVC()
            navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.row == row + 4 {
            let vc = R.storyboard.blogs.blogsVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == row + 5 {
            let vc = R.storyboard.settings.inviteFriendsVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == row + 6 {
            let vc = R.storyboard.settings.helpVC()
            vc?.checkString = "help"
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : 1//items.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileSectionOneTableItem.identifier, for: indexPath) as! ProfileSectionOneTableItem
            cell.delegate = self
            cell.vc = self
            cell.configData()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileSectionTwoTableItem.identifier, for: indexPath) as! profileSectionTwoTableItem
            cell.items = items
            cell.reloadCollectionView()
            cell.onDidSelect = { [weak self] (index) in
                guard let self = self else { return }
                self.didSelectSection(index)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.width
        print(height)
        return indexPath.section == 0 ? UITableView.automaticDimension : indexPath.section == 1 ? height : 0
    }
}

//MARK: - Boost View Delegate -
extension ProfileVC: BoostViewDelegate {
    func navigateToBuyCredit() {
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

//MARK: - Profile Header Section Delegate -
extension ProfileVC: ProfileHeaderSectionDelegate {
    func likeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let isPro = self.userSettings?.is_pro, isPro {
            let vc = R.storyboard.settings.userLikesVC()
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }else{
            let vc = R.storyboard.credit.upgradeAccountVC()
            vc?.delegate = self
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func onVisitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let vc = R.storyboard.settings.profileVisitVC() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func settingsBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.settings.settingsVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func editButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.settings.profilePreviewVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func onBtnShare(_ sender: UIButton) {
        self.view.endEditing(true)
        let appInstance: AppInstance = .shared
        appInstance.addCount = appInstance.addCount + 1
        let text = "\(API.baseURL)@\(appInstance.userProfileSettings?.username ?? "")"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension ProfileVC {
    private func createItemList() -> [[String : String]] {
        var dictArray: [[String : String]] = isProTest
        ? [
            [
                "icon": "ic_video_f",
                "title": "Live".localized,
                "info": "Start your own live stream now".localized
            ]
        ]
        : []
        
        let otherDict = [
            [
                "icon": "ic_friends_f",
                "title": NSLocalizedString("Friends", comment: "Friends"),
                "info": "Display all your friend users".localized
            ],
            
            [
                "icon": "ic_fi-rr-star",
                "title": NSLocalizedString("Favorite", comment: "Favorite"),
                "info": "Display all your favorite users".localized
            ],
            
            [
                "icon": "heart",
                "title": NSLocalizedString("People i Liked", comment: "People i Liked"),
                "info": "Display Users i give them a like".localized
            ],
            
            [
                "icon": "ic_dislike_f",
                "title": "People I Disliked".localized,
                "info": "Display users i didn't like".localized
            ],
            
            [
                "icon": "ic_blog_f",
                "title": NSLocalizedString("Blogs", comment: "Blogs"),
                "info":  "Read the latest Articles".localized
            ],
            
            [
                "icon": "ic_add_f",
                "title": NSLocalizedString("Invite Friends", comment: "Invite Friends"),
                "info": "Invite Friends to the app".localized
            ],
            
            [
                "icon": "ic_faq_f",
                "title": "Need Help?",
                "info": "FAQ, contact us, privacy".localized
            ]
        ]
        
        dictArray.append(contentsOf: otherDict)
        return dictArray
    }
}

extension ProfileVC: PremiumPopupDelegate {
    func renewPremium(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.credit.upgradeAccountVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

//MARK: - Upgrade Account Delegate -
extension ProfileVC: UpgradeAccountDelegate {
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
extension ProfileVC: BuyCreditDelegate {
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
extension ProfileVC: PaymentOptionDelegate {
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
extension ProfileVC {
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
extension ProfileVC: NgeniusPayWebViewDelegate {
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
extension ProfileVC {
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
extension ProfileVC {
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
extension ProfileVC: AamarPayWebViewDelegate {
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
extension ProfileVC: PayStackEmailPopupVCDelegate, PaystackWebViewDelegate {
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
extension ProfileVC: PaymentCardViewDelegate {
    func cardView(_ isSuccess: Bool) {
        if isSuccess {
            self.fetchProfile()
        }
    }
}

//MARK: - Iyzi Pay -
extension ProfileVC {
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
extension ProfileVC: RazorpayProtocol, ExternalWalletSelectionProtocol, RazorpayPaymentCompletionProtocol {
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
extension ProfileVC: CashfreePopupVCDelegate {
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
