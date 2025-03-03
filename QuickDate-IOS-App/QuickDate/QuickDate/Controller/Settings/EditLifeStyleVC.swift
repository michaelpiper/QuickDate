
import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditLifeStyleVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var travelTextField: UITextField!
    @IBOutlet weak var drinkTextFIeld: UITextField!
    @IBOutlet weak var smokeTextField: UITextField!
    @IBOutlet weak var religionTextField: UITextField!
    @IBOutlet weak var carTextField: UITextField!
    @IBOutlet weak var iLiveInTextField: UITextField!
    
    // MARK: - Properties
    // Property Injections
    private let appInstance: AppInstance = .shared
    private let appNavigator: AppNavigator = .shared
    // Others
    var liveWithStringIndex:String? = ""
    var carStringIndex:String? = ""
    var religionStringIndex:String? = ""
    var smokeStringIndex:String? = ""
    var drinkStringIndex:String? = ""
    var travelStringIndex:String? = ""
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        updateLifeStyle()
    }
    
    @IBAction func onBtnLive(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .liveWith))
    }
    
    @IBAction func onBtnCarTapped(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .car))
    }
    @IBAction func onBtnReligionTapped(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .religion))
    }
    
    @IBAction func onBtnSmokeTapped(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .smoke))
    }
    
    @IBAction func onBtnDrinkTapped(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .drink))
    }
    
    @IBAction func onBtnTravelTapped(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .travel))
    }
        
    private func setupUI() {
        if ControlSettings.shouldShowAddMobBanner{
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        self.iLiveInTextField.placeholder = "I live With".localized
        self.carTextField.placeholder = "Car".localized
        self.religionTextField.placeholder = "Religion".localized
        self.smokeTextField.placeholder = "smoke".localized
        self.drinkTextFIeld.placeholder = "Drink".localized
        self.travelTextField.placeholder = "Travel".localized
        
        let userSettings = appInstance.userProfileSettings
        if let liveWith = userSettings?.profile.liveWith.text {
            self.iLiveInTextField.text = liveWith
        }
        
        if let car = userSettings?.profile.car.text {
            self.carTextField.text = car
        }
        
        if let religion = userSettings?.profile.religion.text {
            self.religionTextField.text = religion
        }
        
        if let smoke = userSettings?.profile.smoke.text {
            self.smokeTextField.text = smoke
        }
        
        if let drink = userSettings?.profile.drink.text {
            self.drinkTextFIeld.text = drink
        }
        if let travel = userSettings?.profile.travel.text {
            self.travelTextField.text = travel
        }
        
        self.liveWithStringIndex = userSettings?.profile.liveWith.type
        self.carStringIndex = userSettings?.profile.car.type
        self.religionStringIndex = userSettings?.profile.religion.type
        self.smokeStringIndex = userSettings?.profile.smoke.type
        self.drinkStringIndex = userSettings?.profile.drink.type
        self.travelStringIndex = userSettings?.profile.travel.type
        
        self.iLiveInTextField.delegate = self
        self.carTextField.delegate = self
        self.religionTextField.delegate = self
        self.smokeTextField.delegate = self
        self.drinkTextFIeld.delegate = self
        self.travelTextField.delegate = self
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    
    private func updateLifeStyle(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let travel  = self.travelStringIndex ?? ""
            let drink = self.drinkStringIndex ?? ""
            let smoke = self.smokeStringIndex ?? ""
            let religion = self.religionStringIndex ?? ""
            let car = self.carStringIndex ?? ""
            let liveIn = self.liveWithStringIndex ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.live_with: liveIn,
                API.PARAMS.car: car,
                API.PARAMS.religion: religion,
                API.PARAMS.smoke: smoke,
                API.PARAMS.drink: drink,
                API.PARAMS.travel: travel
                ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension EditLifeStyleVC: DidSetProfilesParamDelegate {
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .liveWith {
            self.iLiveInTextField.text = selectedString
            self.liveWithStringIndex = index
        } else if type == .car {
            self.carTextField.text = selectedString
            self.carStringIndex = index
        } else if type == .religion {
            self.religionTextField.text = selectedString
            self.religionStringIndex = index
        } else if type == .smoke {
            self.smokeTextField.text = selectedString
            self.smokeStringIndex = index
        } else if type == .drink {
            self.drinkTextFIeld.text = selectedString
            self.drinkStringIndex = index
        } else if type == .travel {
            self.travelTextField.text = selectedString
            self.travelStringIndex = index
        }
    }
}
