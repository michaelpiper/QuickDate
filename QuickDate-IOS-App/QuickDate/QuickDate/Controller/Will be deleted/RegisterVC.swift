

import UIKit
import Async
import GoogleSignIn
import FBSDKLoginKit
import QuickDateSDK

/// - Tag: RegisterVC
class RegisterVC: BaseViewController {
    var gender:String? = ""
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    // Dependency Injections
    private let appNavigator: AppNavigator
    let isFromStart: Bool
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    private func setupUI(){
        tableView.register(UINib(resource: R.nib.registerTableItem), forCellReuseIdentifier: R.reuseIdentifier.registerTableItem.identifier)
        self.tableView.separatorStyle = .none
    }
    func registerPressed(firstName:String,lastName:String,email:String,username:String,password:String,confirmPass:String,gender:String){
        if appDelegate.isInternetConnected{
            if (firstName.isEmpty){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Please enter first name.", comment: "Please enter first name.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (lastName.isEmpty){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Please enter last name.", comment: "Please enter last name.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (username.isEmpty){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Please enter username.", comment: "Please enter username.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (email.isEmpty){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Please enter email.", comment: "Please enter email.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (password.isEmpty){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Please enter password.", comment: "Please enter password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (confirmPass.isEmpty){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Please enter confirm password.", comment: "Please enter confirm password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (password != confirmPass){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Password do not match.", comment: "Password do not match.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if !((email.isEmail)){
                
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.messageText = NSLocalizedString("Email is badly formatted.", comment: "Email is badly formatted.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }
            else{
                let alert = UIAlertController(title: "", message:NSLocalizedString("By registering you agree to our terms of service", comment: "By registering you agree to our terms of service") , preferredStyle: .alert)
                let okay = UIAlertAction(title: NSLocalizedString("OKAY", comment: "OKAY"), style: .default) { (action) in
                    self.registerPressedfunc(firstName: firstName, lastname: lastName, email: email, username: username, password: password, confrimPass: confirmPass, gender: gender)
                }
                let termsOfService = UIAlertAction(title:NSLocalizedString("TERMS OF SERVICE", comment: "TERMS OF SERVICE") , style: .default) { (action) in
                    let url = URL(string: "\(API.justURL)/terms")!
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                            print("Open url : \(success)")
                        })
                    }
                }
                let privacy = UIAlertAction(title: "PRIVACY", style: .default) { (action) in
                    let url = URL(string: "\(API.baseURL)/privacy")!
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                            print("Open url : \(success)")
                        })
                    }
                }
                alert.addAction(termsOfService)
                alert.addAction(privacy)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                securityAlertVC?.titleText = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.messageText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                Logger.error("internetError - \(InterNetError)")
            }
        }
    }
    
    func onClickGoogleLogin() {
        GoogleSocialLogin.shared.googleLogin(vc: self) { [weak self] (token) in
            guard let self = self else { return }
            self.googleLogin(access_Token: token)
        }
    }
    
    private func registerPressedfunc(firstName:String, lastname:String,email:String,username:String,password:String,confrimPass:String,gender:String){
        self.showProgressDialog(with: "Loading...")
        let firstName = firstName
        let lastName = lastname
        let username = username
        let email = email
        let password = password
        
        let credentials = RegisterCredentials(firstName: firstName, lastName: lastName, email: email,
                                              username: username, password: password)
        
        Async.background({
            UserManager.instance.registerUser(with: credentials, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main{
                        self.dismissProgressDialog{
                            let message = success?["message"] as? String
                            let code = success?["code"] as? Int
                            let data = success?["data"] as? [String:Any]
                            let accessToken  = data?["access_token"] as? String
                            let userID = data?["user_id"] as? Int
                            Logger.verbose("Access Token = \(accessToken ?? "")")
                            Logger.verbose("userID = \(userID  ?? 0)")
                            let User_Session = [Local.USER_SESSION.Access_token:accessToken ?? "",Local.USER_SESSION.User_id:userID ?? 0] as [String : Any]
                            UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
//                            AppInstance.shared.getUserSession()
//                            AppInstance.shared.fetchUserProfile(view: self.view, completion: {
//                                UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
//                                let vc = R.storyboard.authentication.introViewController()
//                                vc?.modalPresentationStyle  =  .fullScreen
//                                self.fetchGifts()
//                                self.fetchStickers()
//                                self.present(vc!, animated: true, completion: nil)
//                                self.view.makeToast("Login Successfull!!")
//                            })
                          
//                            UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
//                            // let vc = R.storyboard.authentication.introViewController()
//                            let vc = R.storyboard.authentication.twoFactorVC()
//                            vc?.email = email
//                            vc?.is_check = "1"
//                            self.navigationController?.pushViewController(vc!, animated: true)
//                            self.view.makeToast("SignUP Successfull!!")                       }
                        
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
                            securityAlertVC?.messageText = errorText
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
            })
        })
    }
     func facebookLogin(){
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
//                                                            AppInstance.shared.fetchUserProfile(view: self.view, completion: {
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
                                                            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                                            securityAlertVC?.messageText = errorText
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
//                                AppInstance.shared.fetchUserProfile(view: self.view, completion: {
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
                                securityAlertVC?.messageText = errorText
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

extension RegisterVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.registerTableItem.identifier) as? RegisterTableItem
        cell?.vc = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
