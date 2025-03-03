
import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditLooksVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var ethnicityTextField: UITextField!
    
    var ethnicityStringIndex:String? = ""
    var bodyStringIndex:String? = ""
    var heightStringIndex:String? = ""
    var colorStringIndex:String? = ""
    
    var ethnicityStatus = false
    var bodyStatus = false
    var heightStatus = false
    var bannerView: GADBannerView!
    
    // MARK: - Properties
    // Property Injections
    private let appNavigator: AppNavigator = .shared
    private let userSettings = AppInstance.shared.userProfileSettings

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
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        updateLooks()
    }
    
    @IBAction func onBtnEthnicityTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .ethnicity))
    }
    
    @IBAction func onBodyTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .body))
    }
    
    @IBAction func onBtnHeightTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .height))
    }
    
    @IBAction func onBtnHairColorTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .hairColor))
    }
    
    private func updateLooks() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let color = self.colorStringIndex ?? ""
            let height = self.heightStringIndex ?? ""
            let body = self.bodyStringIndex ?? ""
            let ethnicity = self.ethnicityStringIndex ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.hair_color: color,
                API.PARAMS.body: body,
                API.PARAMS.height: height,
                API.PARAMS.ethnicity: ethnicity
                ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil {
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
    
    // MARK: - textfield delegate -
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    private func setupUI() {
        if ControlSettings.shouldShowAddMobBanner {
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        self.ethnicityTextField.placeholder = "Ethnicity".localized
        self.bodyTextField.placeholder = "Body".localized
        self.heightTextField.placeholder = "Height".localized
        self.colorTextField.placeholder = "Hair Color".localized

        if let hairColor = userSettings?.profile.hairColor.text {
            self.colorTextField.text = hairColor
        }
        
        if let ethnicity = userSettings?.profile.ethnicity.text {
            self.ethnicityTextField.text = ethnicity
        }
        
        if let body = userSettings?.profile.body.text {
            self.bodyTextField.text = body
        }
        
        if let height = userSettings?.profile.height.text {
            self.heightTextField.text = height
        }
        
        self.ethnicityStringIndex = userSettings?.profile.ethnicity.type
        self.bodyStringIndex = userSettings?.profile.body.type
        self.heightStringIndex = userSettings?.profile.height.type
        self.colorStringIndex = userSettings?.profile.hairColor.type
        
        self.ethnicityTextField.delegate = self
        self.bodyTextField.delegate = self
        self.heightTextField.delegate = self
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

}
extension EditLooksVC:DidSetProfilesParamDelegate{
    
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .ethnicity {
            self.ethnicityTextField.text = selectedString
            self.ethnicityStringIndex = index
        } else if type == .body {
            self.bodyTextField.text = selectedString
            self.bodyStringIndex = index
        } else if type == .height {
            self.heightTextField.text = selectedString
            self.heightStringIndex = index
        } else if type == .hairColor {
            self.colorTextField.text = selectedString
            self.colorStringIndex = index
        }
    }
}
