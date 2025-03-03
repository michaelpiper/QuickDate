//
//  DashboardVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import FittedSheets
import Shuffle_iOS
import QuickDateSDK
import GooglePlaces
import SafariServices
import Alamofire
import Braintree
import Razorpay

/// Activity Indicator actions
enum Process {
    case start
    case stop
}

class DashboardViewController: BaseViewController {
    
    // MARK: - Views
    
    // @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageVIewCircle: UIImageView!
    @IBOutlet weak var swipeCardStack: SwipeCardStack!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelBackgroundView: UIView!
    //    @IBOutlet weak var nameAndAgeLabel: UILabel!
    //    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var btnSetLocation: UIButton!
    @IBOutlet weak var btnBottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var viewShowIndicator: UIView!
    //    @IBOutlet weak var isVerifiedImage: UIImageView!
    //    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var bottomStackView: UIView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var lblUserAddress: UILabel!
    
    internal var googleInterstitial: GADInterstitialAd?
    internal var facebookInterstitial: FBInterstitialAd?
    
    private var interstitialAd: FBInterstitialAd?
    
    // MARK: - Properties
    // Property Injections
    internal let appInstance: AppInstance = .shared
    private let defaults: Defaults = .shared
    private let networkManager: NetworkManager = .shared
    internal let appNavigator: AppNavigator = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    private let locationManager: LocationManager = .shared
    private let appManager: AppManager = .shared
    // Others
    private var randomUserList: [UserProfileSettings] = []
    
    private let limit = 30
    private var offSet: Int? = 0
    
    private var likedUserIdList: [String] = []
    private var dislikedUserIdList: [String] = []
    private var progressCount = 0
    private var lastDirection: SwipeDirection?
    private var didBackButtonPress: Bool?
    
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
        setUpConfigures()
        swipeCardStack.delegate = self
        swipeCardStack.dataSource = self
        self.startLocationUpdate()
        fetchRandomUsersInFirstLoadingOrAfterFilter()
        
        if !(defaults.get(for: .wasDoneFirstLoading) ?? false) {
            appManager.saveGiftsAndStickersToRealm()
            appNavigator.popUpNavigate(to: .tutorial)
        }
        
        // Handle saving changes
        appManager.reloadAllDataFromRemoteDatabase()
        initializeGoogleAds()
        btnFav.cornerRadiusV = btnFav.frame.height / 2
        
        RAZOR_KEY_ID = AppInstance.shared.adminAllSettings?.data?.razorpayKeyId ?? "rzp_test_ruzI7R7AkonOIi"
        razorpayObj = RazorpayCheckout.initWithKey(RAZOR_KEY_ID, andDelegate: self)
        razorpayObj?.setExternalWalletSelectionDelegate(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let tabHeight = (self.tabBarController as? MainTabBarViewController)?.customTabBarView.frame.height {
            self.btnBottonConstraint.constant = tabHeight + 10.0
        }
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
        labelBackgroundView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
    }
    
    // MARK: - Services
    
    private func initializeGoogleAds() {
        if ControlSettings.googleAds {
            createGoogleAds()
        }
    }
    
    private func setSearchParameters() -> APIParameters {
        var params: APIParameters = [
            API.PARAMS.limit: "\(limit)",
            API.PARAMS.access_token: self.accessToken,
        ]
        
        if let offSet = offSet {
            params[API.PARAMS.offset] = "\(offSet)"
        }
        
        if let filters = defaults.get(for: .dashboardFilter) {
            filters.params.forEach { params[$0.key] = $0.value }
        }
        
        return params
    }
    
    private func startLocationUpdate() {
        AppLocationManager.shared.startLocationUpdate { (currentLocation) in
            GetMapAddress.getAddress(selectedLat: currentLocation.latitude, selectedLon: currentLocation.longitude) { stAddress in
                self.lblUserAddress.text = stAddress
            }
        }
    }
    
    private func fetchRandomUsersInFirstLoadingOrAfterFilter() {
        self.randomUserList.removeAll()
        self.activityIndicatorProcess(to: .start)
        
        guard Connectivity.isConnectedToNetwork() else {
            self.view.makeToast(InterNetError)
            self.activityIndicatorProcess(to: .stop); return
        }
        let params = setSearchParameters()
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.RANDOM_USER_API,
                method: .post, parameters: params) { [weak self] (response: Result<JSON, Error>) in
                    switch response {
                    case .failure(let error):
                        Logger.error(error)
                        Async.main({
                            self?.dismissProgressDialog {
                                self?.presentCustomAlertPresentableWith(error, isNavBar: false)
                                self?.activityIndicatorProcess(to: .stop)
                            }
                        })
                    case .success(let dict):
                        Async.main({
                            self?.dismissProgressDialog {
                                guard let dictionaryList = dict["data"] as? [JSON] else {
                                    Logger.error("getting random users data"); return
                                }
                                self?.randomUserList = dictionaryList.map { UserProfileSettings(dict: $0) }
                                
                                self?.handleOffsetValue()
                                self?.swipeCardStack.reloadData()
                                self?.activityIndicatorProcess(to: .stop)
                            }
                        })
                    }
                }
        })
        
    }
    
    private func handleAppendingUsers() {
        if progressCount == randomUserList.count - 5 {
            self.appendRandomUsers()
        }
    }
    
    private func appendRandomUsers() {
        let newIndexList = createAdditionRandomIndexList(with: randomUserList.count)
        let params = setSearchParameters()
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.RANDOM_USER_API,
                method: .post, parameters: params) { [weak self] (response: Result<JSON, Error>) in
                    guard let strongSelf = self else {
                        Logger.error("getting strong self"); return
                    }
                    switch response {
                    case .failure(let error):
                        Logger.error(error)
                    case .success(let dict):
                        guard let dictionaryList = dict["data"] as? [JSON] else {
                            Logger.error("getting random users data"); return
                        }
                        let additionalUserList = dictionaryList.map { UserProfileSettings(dict: $0) }
                        Logger.info("append users")
                        Async.main({
                            strongSelf.randomUserList.append(contentsOf: additionalUserList)
                            strongSelf.handleOffsetValue()
                            strongSelf.swipeCardStack.appendCards(atIndices: newIndexList)
                        })
                    }
                }
        })
    }
    private func postLikeAndDislikeIds() {
        
        var params: APIParameters = [
            API.PARAMS.access_token: self.accessToken
        ]
        if let likeIdString = turnIdsToStringWithComma(from: self.likedUserIdList) {
            params[API.PARAMS.likes] = likeIdString
            Logger.info(likeIdString)
        }
        if let dislikeIdString = turnIdsToStringWithComma(from: self.dislikedUserIdList) {
            params[API.PARAMS.dislikes] = dislikeIdString
            Logger.info(dislikeIdString)
        }
        Async.background({
            self.networkManager.fetchDataWithRequest(urlString: API.USERS_CONSTANT_METHODS.ADD_LIKES_API, method: .post,
                                                     parameters: params) { [weak self] (response: Result<JSON, Error>) in
                switch response {
                case .failure(let error): Logger.error(error)
                case .success(let dict):
                    Logger.verbose(dict["message"] as? String ?? "nil")
                    self?.likedUserIdList.removeAll()
                    self?.dislikedUserIdList.removeAll()
                }
            }
        })
    }
    
    //animate ripple effect
    func animateRippleEffect(){
        self.imageVIewCircle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
            self.imageVIewCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } completion: { finished in
            if self.viewShowIndicator.isHidden == false {
                self.animateRippleEffect()
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func activityIndicatorProcess(to process: Process) {
        self.viewShowIndicator.isHidden = process == .start ? false : true
        switch process {
        case .start:
            self.imageVIewCircle.layer.zPosition = 1111
            self.viewShowIndicator.isHidden = false
            self.swipeCardStack.isHidden = true
            self.labelBackgroundView.isHidden = true
            self.animateRippleEffect()
        case .stop:
            self.swipeCardStack.isHidden = false
            self.labelBackgroundView.isHidden = false
            self.viewShowIndicator.isHidden = true
        }
    }
    
    private func fetchImageFromURL(with urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {
            Logger.error("getting URL"); return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            Logger.error(error)
            return nil
        }
    }
    
    private func createAdditionRandomIndexList(with count: Int) -> [Int] {
        Array(count...(count + self.limit - 1)).map { $0 }
    }
    
    private func handleOffsetValue() {
        guard let lastUserId = randomUserList.last?.id else {
            Logger.error("getting user id"); return
        }
        self.offSet = Int(lastUserId)
    }
    
    private func turnIdsToStringWithComma(from intArray: [String]) -> String? {
        return intArray.isEmpty ? nil : intArray.joined(separator: ",")
    }
    
    private func deleteLastIdAccording(to direction: SwipeDirection) {
        if direction == .left {
            guard !dislikedUserIdList.isEmpty else { return } // Safety check
            dislikedUserIdList.removeLast()
        } else if direction == .right {
            guard !likedUserIdList.isEmpty else { return } // Safety check
            likedUserIdList.removeLast()
        }
    }
    // Create to handle loading swipe card
    // At first loading shuffle loads 2 card with index 0 and 1
    //MARK:  During swipe shuffle loads future index
    private func showUserInfo(with index: Int) {
        /*guard index > 0 else { return } // Safety Check
         let randomUser = randomUserList[index - 1]
         isVerifiedImage.isHidden = !randomUser.isVerified
         onlineView.isHidden = !randomUser.isOnline
         nameAndAgeLabel.text = "\(randomUser.fullName), \(randomUser.age)"
         Async.main({
         self.locationManager.fetchLocation(with: randomUser.coordinate) {  [self] (response: Result<String, LocationManager.LocationError>) in
         switch response {
         case .failure(let error):
         Logger.error(error)
         case .success(let place):
         addressLabel.text = place
         }
         }
         })   */
    }
    
    private func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.name.rawValue) |
                                                                   UInt(GMSPlaceField.placeID.rawValue)))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func filterPressed(_ sender: UIButton) {
        let viewController = DashboardFilterViewController
            .instantiate(fromStoryboardNamed: .dashboard)
        viewController.delegate = self
        viewController.filterType = .dashboard
        /*let controller = SheetViewController(controller: viewController,
         sizes: [.fixed(525)])
         //        controller.hasBlurBackground = true
         //        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
         self.present(controller, animated: true, completion: nil)*/
        
        let panVC: PanModalPresentable.LayoutType = viewController
        presentPanModal(panVC)
        
        
    }
    
    @IBAction func onBtnSelectLocation(_ sender: UIButton) {
        self.autocompleteClicked()
    }
    
    @IBAction func boostPressed(_ sender: UIButton) {
        let vc = R.storyboard.main.boostVC()
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        swipeCardStack.undoLastSwipe(animated: true)
        didBackButtonPress = true
        guard let lastDirection = lastDirection else {
            return
        }
        deleteLastIdAccording(to: lastDirection)
        progressCount -= 1
    }
    
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
        swipeCardStack.swipe(.left, animated: true)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        swipeCardStack.swipe(.right, animated: true)
    }
}

//MARK: - Boost View Delegate -
extension DashboardViewController: BoostViewDelegate {
    func navigateToBuyCredit() {
        self.goToCreditPage()
    }
}

// MARK: - SwipeCardStackDataSource
extension DashboardViewController: SwipeCardStackDataSource {
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return randomUserList.count
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        for direction in card.swipeDirections {
            card.setOverlay(MatchingCardOverlay(direction: direction), forDirection: direction)
        }
        let randomUser = randomUserList[index]
        Async.main({
            card.content = MatchingCardContentView(withImage: URL(string: randomUser.avatar))
            card.footer = MatchingCardFooterView(withTitle: "\(randomUser.fullname), \(randomUser.age)", subtitle: randomUser)
        })
        self.showUserInfo(with: index)
        
        return card
    }
}

// MARK: - SwipeCardStackDelegate

extension DashboardViewController: SwipeCardStackDelegate {
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        let userId = randomUserList[index].id
        GetMapAddress.getAddress(selectedLat: Double(randomUserList[index].coordinate.latitude) ?? 0, selectedLon: Double(randomUserList[index].coordinate.longitude) ?? 0, completion: { stAddress in
            //self.lblUserAddress.text = stAddress
        })
        if direction == .left {
            dislikedUserIdList.append("\(userId)")
        } else if direction == .right {
            likedUserIdList.append("\(userId)")
        }
        progressCount += 1
        handleProgressWithSwipe(with: progressCount)
        
        //        handleAppendingUsers()
        self.lastDirection = direction
        // Send like and dislike ids in every 10 matches
        // if users turn back at progressCount % 10 == 0, won't work postLikeAndDislikeIds() function
        guard !(didBackButtonPress ?? false) else {
            didBackButtonPress = nil; return
        }
        if progressCount % 10 == 0  {
            postLikeAndDislikeIds()
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        progressCount += 1
        handleProgressWithSwipe(with: progressCount)
        let user = randomUserList[index]
        appInstance.addCount = appInstance.addCount + 1
        appNavigator.dashboardNavigate(to: .userDetail(user: .randomUser(user), delegate: .controller(self)))
    }
}

// MARK: - UserInteractionDelegate

extension DashboardViewController: UserInteractionDelegate {
    func performUserInteraction(with action: UserInteraction) {
        switch action {
        case .like:    swipeCardStack.swipe(.right, animated: true)
        case .dislike: swipeCardStack.swipe(.left, animated: true)
        }
    }
}

// MARK: - FilterDelegate
extension DashboardViewController: DashboardFilterDelegate {
    func applyFilterSettings() {
        fetchRandomUsersInFirstLoadingOrAfterFilter()
    }
}

// MARK: - Helper
extension DashboardViewController {
    private func handleGradientColors() {
        //        let startColor = Theme.primaryStartColor.colour
        //        let endColor = Theme.primaryEndColor.colour
        //        createMainViewGradientLayer(to: upperPrimaryView,
        //                                    startColor: startColor,
        //                                    endColor: endColor)
    }
}

// MARK: - ThemeLoadable
extension DashboardViewController: LabelThemeLoadable, ButtonThemeLoadable, NavBarThemeLoadable {
    internal func configureButtons() {
        returnButton.setTheme(background: .secondaryBackgroundColor, tint: .primaryTextColor)
    }
    
    internal func configureNavBar() {
        //  navBarView.setThemeBackgroundColor(.secondaryBackgroundColor)
        self.navBarView.clipsToBounds = true
        navBarView.layer.cornerRadius = 15
        navBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    internal func configureLabels() {
        //        nameAndAgeLabel.setTheme(themeColor: .primaryTextColor, font: .semiBoldTitle(size: 15))
        //        addressLabel.setTheme(themeColor: .secondaryTextColor, font: .regularText(size: 13))
    }
    
    internal func configureUIViews() {
        //        self.view.setThemeBackgroundColor(.primaryBackgroundColor)
        //        bottomStackView.setThemeBackgroundColor(.primaryBackgroundColor)
        //        swipeCardStack.setThemeBackgroundColor(.primaryBackgroundColor)
        //        labelBackgroundView.setThemeBackgroundColor(.secondaryBackgroundColor)
    }
    
    internal func setUpConfigures() {
        configureButtons()
        configureNavBar()
        configureLabels()
        configureUIViews()
    }
}

extension DashboardViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.lblUserAddress.text = place.name
        self.fetchRandomUsersInFirstLoadingOrAfterFilter()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
