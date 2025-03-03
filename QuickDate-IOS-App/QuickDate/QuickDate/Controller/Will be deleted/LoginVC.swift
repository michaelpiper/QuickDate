
import UIKit
import Async
import FBSDKLoginKit
import GoogleSignIn
import QuickDateSDK

/// - Tag: LoginVC
class LoginVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    // Dependency Injections
    private let appNavigator: AppNavigator
    private let appManager: AppManager = .shared
    private let isFromStart: Bool
    
    // MARK: - Initialiser
    init?(coder: NSCoder, navigator: AppNavigator, fromStart: Bool) {
        self.appNavigator = navigator
        self.isFromStart = fromStart
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        Logger.verbose("Device Id = \(self.deviceID ?? "")")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - Private Functions
    
    private func setupUI(){
        tableView.register(UINib(resource:R.nib.loginTableItem), forCellReuseIdentifier: R.reuseIdentifier.loginTableItem.identifier)
        self.tableView.separatorStyle = .none
    }
    
    private func setDidLogUserIn(to didLogUserIn: Bool) {
        let defaults: Defaults = .shared
        defaults.set(didLogUserIn, for: .didLogUserIn)
    }
    
  
    func facebookLogin() {
        if Connectivity.isConnectedToNetwork(){
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
                if (error == nil){
                    self.showProgressDialog(with: "Loading...")
                    let fbloginresult : LoginManagerLoginResult = result!
                    if (result?.isCancelled)!{
                        self.dismissProgressDialog{
                            Logger.verbose("result.isCancelled = \(result?.isCancelled ?? false)")
                        }
                        return
                    }
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((AccessToken.current) != nil){
                                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        let dict = result as! [String : AnyObject]
                                        Logger.debug("result = \(dict)")
                                        guard (dict["first_name"] as? String) != nil else {return}
                                        guard (dict["last_name"] as? String) != nil else {return}
                                        guard (dict["email"] as? String) != nil else {return}
                                        let accessToken = AccessToken.current?.tokenString
                                        Logger.verbose("FaceBookaccessToken = \(accessToken)")
                                        self.dismissProgressDialog {
                                            Logger.verbose("FaceBookaccessToken = \(accessToken)")
                                        }
                                        let FBAccessToken = accessToken ?? ""
                                        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
                                        
                                        Async.background({
                                            UserManager.instance.socialLogin(accessToken: FBAccessToken, Provider: "facebook", DeviceId:  deviceID, googleApiKey: "") { (success, sessionError, error) in
                                                if success != nil{
                                                    Async.main{
                                                        self.dismissProgressDialog{
                                                            let message = success?["message"] as? String
                                                            let code = success?["code"] as? Int
                                                            let data = success?["data"] as? [String:Any]
                                                            Logger.verbose("Success = \(message ??  "")")
                                                            let accessToken  = data?["access_token"] as? String
                                                            let userID = data?["user_id"] as? Int
                                                            Logger.verbose("Access Token = \(accessToken ?? "")")
                                                            Logger.verbose("userID = \(userID  ?? 0)")
                                                            let User_Session = [Local.USER_SESSION.Access_token:accessToken ?? "",Local.USER_SESSION.User_id:userID ?? 0] as [String : Any]
                                                            UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
//                                                            AppInstance.shared.getUserSession()
                                                            
                                                            self.appManager.fetchUserProfile()
                                                            self.setDidLogUserIn(to: true)
                                                            
                                                            let vc = R.storyboard.authentication.introViewController()
                                                            vc?.modalPresentationStyle  =  .fullScreen
                                                            self.fetchGifts()
                                                            self.fetchStickers()
                                                            self.present(vc!, animated: true, completion: nil)
                                                            self.view.makeToast("Login Successfull!!")
                                                            
//                                                            AppInstance.shared.fetchUserProfile(view: self.view, completion: {
//
//                                                                self.setDidLogUserIn(to: true)
//
//                                                                let vc = R.storyboard.authentication.introViewController()
//                                                                vc?.modalPresentationStyle  =  .fullScreen
//                                                                self.fetchGifts()
//                                                                self.fetchStickers()
//                                                                self.present(vc!, animated: true, completion: nil)
//                                                                self.view.makeToast("Login Successfull!!")
//                                                            })
                                                        }
                                                    }
                                                }else if sessionError != nil{
                                                    Async.main{
                                                        self.dismissProgressDialog {
                                                            let errors = sessionError?["errors"] as? [String:Any]
                                                            let errorText = errors?["error_text"] as? String
                                                            Logger.verbose("session Error = \(errorText ?? "")")
                                                            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                                                            securityAlertVC?.titleText  = "Security"
                                                            securityAlertVC?.messageText = errorText ?? ""
                                                            self.present(securityAlertVC!, animated: true, completion: nil)
                                                            
                                                        }
                                                    }
                                                }else {
                                                    Async.main({
                                                        self.dismissProgressDialog {
                                                            Logger.verbose("error = \(error?.localizedDescription ?? "")")
                                                            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                                                            securityAlertVC?.titleText  = "Security"
                                                            securityAlertVC?.messageText = error?.localizedDescription ?? ""
                                                            self.present(securityAlertVC!, animated: true, completion: nil)
                                                        }
                                                    })
                                                }
                                            }
                                        })
                                        Logger.verbose("FBSDKAccessToken.current() = \(AccessToken.current?.tokenString ?? "")")
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  = "Internet Error"
                securityAlertVC?.messageText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                Logger.error("internetError - \(InterNetError)")
            }
        }
    }
    // MARK: - Done
    
    func onClickGoogleLogin() {
        GoogleSocialLogin.shared.googleLogin(vc: self) { [weak self] (token) in
            guard let self = self else { return }
            self.googleLogin(access_Token: token)
        }
    }
    
    func googleLogin(access_Token:String){
        self.showProgressDialog(with: NSLocalizedString("Loading...", comment: "Loading..."))
        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                UserManager.instance.socialLogin(accessToken: access_Token, Provider: "google", DeviceId: deviceID, googleApiKey: ControlSettings.googleApiKey, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main{
                            self.dismissProgressDialog{
                                let message = success?["message"] as? String
                                let code = success?["code"] as? Int
                                let data = success?["data"] as? [String:Any]
                                Logger.verbose("Success = \(message ??  "")")
                                let accessToken  = data?["access_token"] as? String
                                let userID = data?["user_id"] as? Int
                                Logger.verbose("Access Token = \(accessToken ?? "")")
                                Logger.verbose("userID = \(userID  ?? 0)")
                                let User_Session = [Local.USER_SESSION.Access_token:accessToken ?? "",Local.USER_SESSION.User_id:userID ?? 0] as [String : Any]
                                UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
//                                AppInstance.shared.getUserSession()
                                
                                self.appManager.fetchUserProfile()
                                self.setDidLogUserIn(to: true)
                                
                                let appNavigator: AppNavigator = .shared
                                appNavigator.navigate(to: .mainTab)
                                
                                /*let vc = R.storyboard.authentication.introViewController()
                                self.navigationController?.pushViewController(vc!, animated: true)*/
                                self.view.makeToast(NSLocalizedString("Login Successfull!!", comment: "Login Successfull!!"))
                                
//                                AppInstance.shared.fetchUserProfile(view: self.view, completion: {
//
//                                    self.setDidLogUserIn(to: true)
//
//                                    let vc = R.storyboard.authentication.introViewController()
//                                    self.navigationController?.pushViewController(vc!, animated: true)
//                                    self.view.makeToast(NSLocalizedString("Login Successfull!!", comment: "Login Successfull!!"))
//                                })
                            }
                        }
                    }else if sessionError != nil{
                        Async.main{
                            self.dismissProgressDialog {
                                let errors = sessionError?["errors"] as? [String:Any]
                                let errorText = errors?["error_text"] as? String
                                Logger.verbose("session Error = \(errorText ?? "")")
                                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                securityAlertVC?.messageText = errorText ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                                
                            }
                        }
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.verbose("error = \(error?.localizedDescription)")
                                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                securityAlertVC?.messageText = error?.localizedDescription ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                            }
                        })
                    }
                })
            })
            
            
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.messageText = InterNetError ?? ""
                self.present(securityAlertVC!, animated: true, completion: nil)
                Logger.error("internetError - \(InterNetError)")
            }
        }
    }
}

// MARK: - Done
extension LoginVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.loginTableItem.identifier) as? LoginTableItem
        cell?.vc = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
