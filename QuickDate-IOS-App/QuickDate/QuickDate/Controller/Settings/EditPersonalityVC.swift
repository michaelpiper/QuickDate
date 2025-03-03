

import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditPersonalityVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var petTextFIeld: UITextField!
    @IBOutlet weak var friendsTextField: UITextField!
    @IBOutlet weak var childrenTextField: UITextField!
    @IBOutlet weak var characterTextIField: UITextField!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let appNavigator: AppNavigator = .shared
    
    var characterStringIndex:String? = ""
    var childrenStringIndex:String? = ""
    var friendsStringIndex:String? = ""
    var petStringIndex:String? = ""
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
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        updatePersonality()
    }
    
    @IBAction func onBtnCharacterTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .character))
    }
    
    @IBAction func onBtnChildrenTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .children))
    }
    
    @IBAction func onBtnFriendTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .friends))
    }
    
    @IBAction func onBtnPetTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .pets))
    }
    
    
    private func setupUI(){
        if ControlSettings.shouldShowAddMobBanner{
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        self.characterTextIField.placeholder = "Character".localized
        self.childrenTextField.placeholder = "Children".localized
        self.friendsTextField.placeholder = "Friends".localized
        self.petTextFIeld.placeholder = "Pet".localized
        
        let userSettings = appInstance.userProfileSettings
        
        if let character = userSettings?.profile.character.text {
            self.characterTextIField.text = character
        }
        
        if let children = userSettings?.profile.children.text {
            self.childrenTextField.text = children
        }
        
        if let friends = userSettings?.profile.friends.text {
            self.friendsTextField.text = friends
        }
        
        if let pets = userSettings?.profile.pets.text {
            self.petTextFIeld.text = pets
        }
        
        self.characterStringIndex = userSettings?.profile.character.type
        self.childrenStringIndex = userSettings?.profile.children.type
        self.friendsStringIndex = userSettings?.profile.friends.type
        self.petStringIndex = userSettings?.profile.pets.type
                
        self.characterTextIField.delegate = self
        self.childrenTextField.delegate = self
        self.friendsTextField.delegate = self
        self.petTextFIeld.delegate = self
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
    
    private func updatePersonality() {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let pet  = self.petStringIndex ?? ""
            let friend = self.friendsStringIndex ?? ""
            let children = self.childrenStringIndex ?? ""
            let character = self.characterStringIndex ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.character: character,
                API.PARAMS.children: children,
                API.PARAMS.friends: friend,
                API.PARAMS.pets: pet
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
extension EditPersonalityVC: DidSetProfilesParamDelegate {
    
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .character {
            self.characterTextIField.text = selectedString
            self.characterStringIndex = index
        } else if type == .children {
            self.childrenTextField.text = selectedString
            self.childrenStringIndex = index
        } else if type == .friends {
            self.friendsTextField.text = selectedString
            self.friendsStringIndex = index
        } else if type == .pets {
            self.petTextFIeld.text = selectedString
            self.petStringIndex = index
        }
    }
}
