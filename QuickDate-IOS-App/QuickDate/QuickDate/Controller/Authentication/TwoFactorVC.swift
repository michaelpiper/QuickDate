//
//  TwoFactorVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

/// Use only for injections of TwoFactorVC
struct TwoFactorVCInjections {
    let email: String
    let userID: Int
}

/// - Tag: TwoFactorVC
class TwoFactorVC: BaseViewController {
    // MARK: - Views
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var constrintNewPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var constrintNewPasswordTop: NSLayoutConstraint!
    
    // MARK: - Properties
    private let appManager: AppManager = .shared
    private let defaults: Defaults = .shared
    private let appNavigator: AppNavigator = .shared
    private let appInstance: AppInstance = .shared
    private let userManager: UserManager = .instance
    private let networkManager: NetworkManager = .shared
    private let authErrorHandler: AuthErrorHandler = .default
    
    // FIXME: turn these variables
    var code: Int = 0
    var userID: Int = 0
    var password: String = ""
    var email: String = ""
    var isForgotpassword: Bool = false
    var error = ""
    var is_check = "0"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isForgotpassword {
            self.constrintNewPasswordHeight.constant = 0
            self.constrintNewPasswordTop.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Services
    
    private func verifyTwoFactor(){
        
        guard Connectivity.isConnectedToNetwork() else {
            self.dismissProgressDialog {
                self.showOKAlertOverNavBar(title: "Internet Error".localized,
                                           message: nil)
            }
            return
        }
        self.showProgressDialog(with: "Loading...")
        
        guard let code = verifyCodeTextField.text,
              code.isEmpty == false else {
                  self.view.makeToast("Please enter Code".localized); return
              }
        
        let params: APIParameters = [
            API.PARAMS.user_id: "\(userID)",
            API.PARAMS.code: code
        ]
        
        
        networkManager.fetchDataWithRequest(
            urlString: API.AUTH_CONSTANT_METHODS.VERIFY_TWO_FACTOR_API,
            method: .post,
            parameters: params, successCode: .code) { (result: Result<JSON, Error>) in
                Async.background {
                    switch result {
                    case .failure(let error):
                        Async.main {
                            self.dismissProgressDialog {
                                Logger.verbose("error = \(error.localizedDescription)")
                                self.presentCustomAlertPresentableWith(error, isNavBar: true)
                            }
                        }
                    case .success(let json):
                        Async.main {
                            self.dismissProgressDialog {
                                let responseJSON = json["data"] as? JSON
                                let accessToken  = responseJSON?["access_token"] as? String
                                let userID = responseJSON?["user_id"] as? Int
                                Logger.verbose("Access Token = \(String(describing: accessToken))")
                                Logger.verbose("userID = \(String(describing: userID))")
                                self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
                                self.appManager.reloadAllDataFromRemoteDatabase()
                                self.setDidLogUserIn(to: true)
                                self.handleGiftsAndStickers()
                                self.appNavigator.dashboardNavigate(to: .intro)
                                self.view.makeToast("Login Successful...".localized)
                                
                            }
                        }
                    }
                }
            }
        
    }
    
    private func forgotPasswordApi(){
        
        guard Connectivity.isConnectedToNetwork() else {
            self.dismissProgressDialog {
                self.showOKAlertOverNavBar(title: "Internet Error".localized,
                                           message: nil)
            }
            return
        }
        self.showProgressDialog(with: "Loading...")
        
        guard let code = verifyCodeTextField.text,
              code.isEmpty == false else {
                  self.view.makeToast("Please enter Code".localized); return
              }
                         
        guard let newPassword = newPasswordTextField.text,
              code.isEmpty == false else {
                  self.view.makeToast("Please enter NewPassword".localized); return
              }
        
        let params: APIParameters = [
            API.PARAMS.email: "\(email)",
            API.PARAMS.email_code: code,
            API.PARAMS.password: newPassword
        ]
        
        networkManager.fetchDataWithRequest(
            urlString: API.AUTH_CONSTANT_METHODS.REPLACE_PASSWORD_API,
            method: .post,
            parameters: params, successCode: .code) { (result: Result<JSON, Error>) in
                Async.background {
                    switch result {
                    case .failure(let error):
                        Async.main {
                            self.dismissProgressDialog {
                                Logger.verbose("error = \(error.localizedDescription)")
                                self.presentCustomAlertPresentableWith(error, isNavBar: true)
                            }
                        }
                    case .success(let json):
                        Async.main {
                            self.dismissProgressDialog {
                                self.appNavigator.start(from: .authentication)//dashboardNavigate(to: .intro)
                            }
                        }
                    }
                }
            }
        
    }
    
    private func activateAccount(){
        if appDelegate.isInternetConnected{
            self.showProgressDialog(with: "Loading")
            ActivatedAccountManager.sharedInstance.activateAccount(code: Int(self.verifyCodeTextField.text!) ?? 0, email: self.email) { (success, authError, error) in
                if (success != nil){
                    self.dismissProgressDialog {
                        let data = success?.data
                        let accessToken  = data?["access_token"] as? String
                        let userID = data?["user_id"] as? Int
                        
                        self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
                        self.appManager.fetchUserProfile()
                        self.setDidLogUserIn(to: true)
                        self.handleGiftsAndStickers()
                        self.appNavigator.dashboardNavigate(to: .intro)
                        self.view.makeToast("Login Successful...".localized)
                        
                    }
                    self.view.makeToast(success?.message)
                }
                else if (authError != nil){
                    self.dismissProgressDialog {
                        self.view.makeToast(authError?.errors.errorText)
                    }
                }
                else if (error != nil){
                    self.dismissProgressDialog {
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
        else{
            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
            securityAlertVC?.titleText  = "Internet Error"
            securityAlertVC?.messageText = InterNetError ?? ""
            self.present(securityAlertVC!, animated: true, completion: nil)
            Logger.error("internetError - \(InterNetError)")
        }
    }
    
    private func resendEmail() {
        guard Connectivity.isConnectedToNetwork() else {
            self.dismissProgressDialog {
                self.showOKAlertOverNavBar(
                    title: "Internet Error".localized, message: nil)
            }
            return
        }
        
        ResendEmailManager.sharedInstance.resendEmail(email: self.email) { (success,authError, error) in
            if (success != nil){
                self.view.makeToast(success?.message ?? "")
            }
            else if (authError != nil){
                self.view.makeToast(authError?.errorText)
            }
            else if (error != nil){
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Functions
    
    private  func handleGiftsAndStickers() {
        self.fetchGifts()
        self.fetchStickers()
    }
    
    private func saveUserSession(accessToken: String, userID: Int) {
        defaults.set(userID, for: .userID)
        defaults.set(accessToken, for: .accessToken)
    }
    
    private func setDidLogUserIn(to didLogUserIn: Bool) {
        
        defaults.set(didLogUserIn, for: .didLogUserIn)
    }
    
    // MARK: - Actions
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        if !isForgotpassword {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func verifyPressed(_ sender: UIButton) {
        guard verifyCodeTextField.hasText else {
            self.view.makeToast("Please enter Code"); return
        }
        if isForgotpassword {
            self.forgotPasswordApi()
        } else {
            if is_check == "1" {
                self.activateAccount()
            } else {
                self.verifyTwoFactor()
                
            }
        }
    }
    
    @IBAction func ResendEmail(_ sender: UIButton) {
        self.resendEmail()
    }
}

// MARK: - Helper

extension TwoFactorVC {
    
    private func setupUI(){
        self.verifyBtn.setTitleColor(.Button_StartColor, for: .normal)
        self.firstLabel.text = NSLocalizedString("To log in, you need to verify  your identity.", comment: "To log in, you need to verify  your identity.")
        self.secondLabel.text = NSLocalizedString("We have sent you the confirmation code to your email address.", comment: "We have sent you the confirmation code to your email address.")
        self.verifyCodeTextField.placeholder =  NSLocalizedString("Add code number", comment: "Add code number")
        self.verifyBtn.setTitle(NSLocalizedString("VERIFY", comment: "VERIFY"), for: .normal)
    }
}
