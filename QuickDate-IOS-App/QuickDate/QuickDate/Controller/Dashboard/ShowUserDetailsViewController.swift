//
//  ShowUserDetailsViewController.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK
import Alamofire
import Braintree
import Razorpay

protocol UserInteractionDelegate: AnyObject {
    func performUserInteraction(with action: UserInteraction)
}

/// - Tag: ShowUserDetailsViewController
class ShowUserDetailsViewController: BaseViewController {
    
    // MARK: - View
   // @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewLike: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ShowUserDetailsTableItem.self) // 0
            tableView.register(cellType: UserAboutCell.self) // 1
            tableView.register(cellType: UserImagesCell.self) // 2
            tableView.register(cellType: UserTagViewCell.self) // 3
            tableView.register(cellType: UserLocationCell.self) // 4
            tableView.register(cellType: UserActivityCell.self) // 5, 6, 7, 8
            tableView.register(cellType: UserSocialLinkCell.self) // 9
        }
    }
    // Property Injections
    private let networkManager: NetworkManager = .shared
    var otherUser: OtherUser?
    var delegate: UserInteractionDelegate?
        
    var shallNotify = false
    private var mediaFileList: [MediaFile] = []
        
    // FIXME: If it's not necessary then delete it
    var fromProf: Bool = false
    
    var selectedAmount = 0
    var selectedCredit = 0
    var selectedMemberShip = 1
    var selectedPaymentType = ""
    var razorpayObj: RazorpayCheckout? = nil
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    var RAZOR_KEY_ID = "rzp_test_ruzI7R7AkonOIi"
    var selectedPaymentMethod: PaymentName = .flutterWave
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserFeatures()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Services
    private func getUserFeatures() {
        guard let otherUser = otherUser else {
            Logger.error("getting random user"); return
        }
        shallNotify = otherUser.shallNotify
    }
    
    private func performUserInteraction(with userId: String, action: UserInteraction) {
        let accessToken = AppInstance.shared.accessToken ?? ""
        var params: APIParameters = [
            API.PARAMS.access_token: accessToken
        ]
        switch action {
        case .like:    params[API.PARAMS.likes] = userId
        case .dislike: params[API.PARAMS.dislikes] = userId
        }
        guard Connectivity.isConnectedToNetwork() else {
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError); return
        }
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.ADD_LIKES_API,
                method: .post,
                parameters: params) { [weak self] (response: Result<JSON, Error>) in
                switch response {
                case .failure(let error):
                    Async.main({
                        self?.dismissProgressDialog {
                            self?.view.makeToast(error.localizedDescription)
                            Logger.error("error = \(error.localizedDescription)")
                        }
                    })
                case .success(_):
                    Async.main({
                        self?.dismissProgressDialog {
                            self?.delegate?.performUserInteraction(with: action)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chatPressed(_ sender: UIButton) {
        guard let userDetails = otherUser?.userDetails else {
            Logger.error("getting other user"); return
        }
        
        let vc = R.storyboard.chat.chatScreenVC()
        vc?.toUserId = "\(userDetails.id)"
        vc?.usernameString = userDetails.username
        vc?.lastSeenString =  String(userDetails.lastseen)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        guard let userId = otherUser?.userDetails.id else {
            Logger.error("getting user id"); return
        }
//        self.addLike(with: userId)
        performUserInteraction(with: userId, action: .like)
      
    }
    
    @IBAction func dislikePressed(_ sender: UIButton) {
        guard let userId = otherUser?.userDetails.id else {
            Logger.error("getting user id"); return
        }
        performUserInteraction(with: userId, action: .dislike)
    }
}

// MARK: Helper
extension ShowUserDetailsViewController {
    
    private func handleGradientColors() {
//        let startColor = Theme.primaryStartColor.colour
//        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    private func setupUI() {
        RAZOR_KEY_ID = AppInstance.shared.adminAllSettings?.data?.razorpayKeyId ?? "rzp_test_ruzI7R7AkonOIi"
        razorpayObj = RazorpayCheckout.initWithKey(RAZOR_KEY_ID, andDelegate: self)
        razorpayObj?.setExternalWalletSelectionDelegate(self)
        
        backButton.setTitle("", for: .normal)
        handleGradientColors()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        guard let otherUser = otherUser else {
            Logger.error("getting other user"); return
        }
        mediaFileList = otherUser.mediaFiles
        viewLike.circleView()
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            
        }
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - DataSource

extension ShowUserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let otherUser = otherUser else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ShowUserDetailsTableItem
            cell.delegate = self
            cell.otherUser = otherUser
            cell.blogDelegate = self
            cell.controller = self
            cell.baseVC = self
            cell.isNotification = self.shallNotify
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserImagesCell
            cell.vc = self
            cell.mediaFilesList = otherUser.mediaFiles
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserActivityCell
            cell.titleText = "More info"
            cell.otherUser = otherUser
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserLocationCell
            cell.coordinate = otherUser.userDetails.coordinate
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserTagViewCell
            if otherUser.userDetails.profile.workStatus.text != "" {
                cell.titleText = "Work"
                let text = otherUser.userDetails
                    .profile.workStatus.text.htmlAttributedString ?? ""
                cell.explanation = text
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserTagViewCell
            if otherUser.userDetails.profile.education.text != "" {
                cell.titleText = "Education"
                let text = otherUser.userDetails
                    .profile.education.text.htmlAttributedString ?? ""
                cell.explanation = text
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserTagViewCell
            if otherUser.userDetails.interest != "" {
                cell.titleText = "Interests"
                let text = otherUser.userDetails.interest
                cell.explanation = text
            }
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserTagViewCell
            if otherUser.userDetails.profile.preferredLanguage.text != "" {
                cell.titleText = "Languages"
                let text =
                otherUser.userDetails.profile.preferredLanguage.text.htmlAttributedString ?? ""
                cell.explanation = text
            }
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserSocialLinkCell
            cell.superVC = self
            cell.bindOtherUser(data: otherUser)
            cell.selectionStyle = .none
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return UITableView.automaticDimension//400//330.0
        case 1:
            return otherUser?.mediaFiles.isEmpty ?? true ? 0 : 125
        case 2:
            return UITableView.automaticDimension
        case 3:
            guard let latitude = otherUser?.userDetails.coordinate.latitude,
                  let longitude = otherUser?.userDetails.coordinate.longitude else {
                return 0
            }
            return latitude == "0" || longitude == "0" ? 0 : UITableView.automaticDimension
        case 4:
            let workStatus = otherUser?.userDetails.profile.workStatus.text ?? ""
            return workStatus == "" ? 0 : UITableView.automaticDimension
        case 5:
            let education = otherUser?.userDetails.profile.education.text ?? ""
            return education == "" ? 0 : UITableView.automaticDimension
        case 6:
            let interest = otherUser?.userDetails.interest ?? ""
            return interest == "" ? 0 : UITableView.automaticDimension
        case 7:
            let language = otherUser?.userDetails.profile.preferredLanguage.text ?? ""
            return language == "" ? 0 : UITableView.automaticDimension
        case 8:
            guard let social = otherUser?.userDetails.socialMedia else {
                return 0
            }
            let isEmpty = social.facebook.isEmpty || social.google.isEmpty
            || social.instagram.isEmpty || social.webSite.isEmpty
            return isEmpty ? 0 : 95
        default:  return 0.0
        }
    }
}

extension ShowUserDetailsViewController: BlogUserDelegate {
    func dislikeUser() {
        self.delegate?.performUserInteraction(with: .dislike)
    }
}

extension ShowUserDetailsViewController: ShowUserDetailsTableDelegate {
    func giftBtn(_ sender: UIButton) {
        self.goToCreditPage()
    }
    
    func goToCreditPage() {
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

//MARK: - Buy Credit Delegate -
extension ShowUserDetailsViewController: BuyCreditDelegate {
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
extension ShowUserDetailsViewController: PaymentOptionDelegate {
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
extension ShowUserDetailsViewController {
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
extension ShowUserDetailsViewController: NgeniusPayWebViewDelegate {
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
extension ShowUserDetailsViewController {
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
extension ShowUserDetailsViewController {
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
extension ShowUserDetailsViewController: AamarPayWebViewDelegate {
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
extension ShowUserDetailsViewController: PayStackEmailPopupVCDelegate, PaystackWebViewDelegate {
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
extension ShowUserDetailsViewController: PaymentCardViewDelegate {
    func cardView(_ isSuccess: Bool) {
        if isSuccess {
            self.fetchProfile()
        }
    }
}

//MARK: - Iyzi Pay -
extension ShowUserDetailsViewController {
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
extension ShowUserDetailsViewController: RazorpayProtocol, ExternalWalletSelectionProtocol, RazorpayPaymentCompletionProtocol {
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
extension ShowUserDetailsViewController: CashfreePopupVCDelegate {
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
