//
//  LoginWithWoWonderVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

/// - Tag: LoginWithWoWonderVC
class LoginWithWoWonderVC: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Properties
    // Property Injections
    private let defaults: Defaults = .shared
    private let appManager: AppManager = .shared
    private let appNavigator: AppNavigator = .shared
    // Others
    var error = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Services
    
    private func loginAuthentication() {
        self.showProgressDialog(with: "Loading...")
        let username = self.userNameField.text ?? ""
        let password = self.passwordField.text ?? ""
        
        Async.background({
            UserManager.instance.loginWithWoWonder(userName: username, password: password) { (success, sessionError, error) in
                if success != nil {
                    self.dismissProgressDialog {
                        Logger.verbose("Login Succesfull =\(String(describing: success?.accessToken))")
                        self.woWonderSignIn(userID: success?.userID ?? "", accessToken: success?.accessToken ?? "")
                    }
                }
                else if sessionError != nil {
                    self.dismissProgressDialog {
                        self.error = sessionError?.errors.errorText ?? ""
                        Logger.verbose(sessionError?.errors.errorText ?? "")
                        self.view.makeToast(sessionError?.errors.errorText ?? "")
                    }
                }
                else if error != nil{
                    self.dismissProgressDialog {
                        print("error - \(String(describing: error?.localizedDescription))")
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        })
    }
    private func woWonderSignIn (userID:String, accessToken:String) {
        self.showProgressDialog(with: "Loading...")
//        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
        
        Async.background({
            let woWonderManager: WoWProfileManager = .instance
            
            woWonderManager.WoWonderUserData(userId: userID,
                                             access_token: accessToken) { (success, sessionError, error) in
                // 1. Error
                if let error = error {
                    
                    self.dismissProgressDialog {
                        print("error - \(error.localizedDescription)")
                        self.view.makeToast(error.localizedDescription)
                    }
                // 2. SessionError
                } else if let sessionError = sessionError {
                    
                    self.dismissProgressDialog {
                        self.error = sessionError.errors?.errorText ?? ""
                        Logger.verbose(sessionError.errors?.errorText ?? "")
                        self.view.makeToast(sessionError.errors?.errorText ?? "")
                    }
                // 3. Success
                } else if let success = success {
                    
                    self.dismissProgressDialog {
                        Logger.verbose("Login Succesfull =\(String(describing: success.accessToken))")
                        Logger.verbose("Success = \(success.accessToken ?? "")")
                        
                        self.saveUserSession(accessToken: accessToken, userID: Int(userID) ?? 0)
                        self.appManager.fetchUserProfile()
                        self.setDidLogUserIn(to: true)
                        self.handleGiftsAndStickers()
                        self.appNavigator.dashboardNavigate(to: .intro)
                        self.view.makeToast("Login Successful...".localized)
                        
                    }
                    
                }
            }
        })
    }
    
    private func signInPressed() {
        if self.userNameField.text?.isEmpty == true {
            self.view.makeToast("Error, Required Username")
        }
        else if self.passwordField.text?.isEmpty == true {
            
            self.view.makeToast("Error, Required Password")
            
        }
        else {
            self.loginAuthentication()
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signInPressed()
    }
    
    // MARK: - Helper
    
    private func setupUI() {
        backButton.setTheme(title: "Back".localized, font: .regularText(size: 15))
        self.userNameField.placeholder = "Username".localized
        self.passwordField.placeholder = "Password".localized
        self.signInButton.setTheme(title: "Sign In", font: .semiBoldTitle(size: 15))
    }
}

extension LoginWithWoWonderVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField {
            userNameField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            signInPressed()
        }
        return true
    }
}

