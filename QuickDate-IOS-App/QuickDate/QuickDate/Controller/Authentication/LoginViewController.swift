//
//  LoginViewController.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 6.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleSignIn
import JGProgressHUD
import FacebookCore
import QuickDateSDK
import AuthenticationServices

/// - Tag: LoginViewController
class LoginViewController: BaseViewController {
    
    // MARK: - Views
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var googleSignInView: UIView!
    @IBOutlet weak var woWonderLogInView: UIView!
    @IBOutlet weak var viewLoginButton: UIView!
    @IBOutlet weak var appleSigInView: UIView!
    
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    // Buttons
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    // TODO: There is a bug in storyboard
    // You can't change the button title on storyboard
    // find the bug and remove emptyButtonList
    @IBOutlet var emptyButtonList: [UIButton]!
    
    // MARK: - Properties
    // Dependency Injections
    internal let appInstance: AppInstance = .shared
    internal let userManager: UserManager = .instance
    internal let networkManager: NetworkManager = .shared
    internal let authErrorHandler: AuthErrorHandler = .default
    internal let appManager: AppManager = .shared
    private let defaults: Defaults = .shared
    internal let appNavigator: AppNavigator
    private let isComingFromStart: Bool
    // Others
    private var isPasswordHidden = true
    
    // MARK: - Initialiser
    init?(coder: NSCoder, navigator: AppNavigator, fromStart: Bool) {
        self.appNavigator = navigator
        self.isComingFromStart = fromStart
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConfigures()
        handleSocialLogin()
        saveDataToLocalDataBase()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Services
    
    // Save data to local database to handle thread error of RealSwift.
    // If I save in AppInstance class data is nil
    private func saveDataToLocalDataBase() {
        guard isComingFromStart else { return }
        let appManager: AppManager = .shared
        appManager.saveSettingsToLocalDataBase()
    }
    
    private func fetchSignInEntries() throws -> LoginCredentials {
        do {
            //            let email = try authErrorHandler.checkEmail(emailTextField.text)
            let password = try authErrorHandler.checkPassword(passwordTextField.text)
            return LoginCredentials(username: emailTextField.text ?? "", password: password)
        } catch {
            throw error
        }
    }
    
    // MARK: Email Login
    
    private func logUserIn(username: String, password: String) {
        
        guard Connectivity.isConnectedToNetwork() else {
            self.dismissProgressDialog {
                self.showOKAlertOverNavBar(title: "Internet Error".localized,
                                           message: nil)
            }
            return
        }
        
        let credentials = LoginCredentials(username: username, password: password)
        
        self.showProgressDialog(with: "Loading...")
        
        networkManager.fetchDataWithRequest(
            urlString: API.AUTH_CONSTANT_METHODS.LOGIN_API,
            method: .post,
            parameters: credentials.parameters) { (result: Result<JSON, Error>) in
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
                                self.handleLogin(with: json, email: username)
                            }
                        }
                    }
                }
            }
    }
    
    private func handleLogin(with json: JSON, email: String) {
        guard let message = json["message"] as? String else {
            Logger.error("getting message"); return
        }
        
        if message == "Please enter your confirmation code" {
            let userId = json["user_id"] as? Int ?? 0
            let injections = TwoFactorVCInjections(email: email, userID: userId)
            self.appNavigator.authNavigate(to: .twoFactor(injections: injections))
            
        } else {
            let responseJSON = json["data"] as? JSON
            let accessToken  = responseJSON?["access_token"] as? String
            let userID = responseJSON?["user_id"] as? Int
            Logger.verbose("Access Token = \(String(describing: accessToken))")
            Logger.verbose("userID = \(String(describing: userID))")
            self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
            self.appManager.reloadAllDataFromRemoteDatabase()
            self.setDidLogUserIn(to: true)
            self.handleGiftsAndStickers()
            //            self.appNavigator.dashboardNavigate(to: .intro)
            self.appNavigator.navigate(to: .mainTab)
            self.view.makeToast("Login Successful...".localized)
        }
    }
    
    private func signInButtonPressed() {
        do {
            let entries = try fetchSignInEntries()
            logUserIn(username: entries.username, password: entries.password)
        } catch {
            presentCustomAlertPresentableWith(error, isNavBar: true)
        }
    }
    
    private func googleButtonPressed() {
        GoogleSocialLogin.shared.googleLogin(vc: self) { [weak self] (token) in
            guard let self = self else { return }
            self.googleLogin(access_Token: token)
        }
    }
    
    // MARK: - Private & Internal Functions
    
    private func AppleButtonPressed() {
        GoogleSocialLogin.shared.googleLogin(vc: self) { [weak self] (token) in
            guard let self = self else { return }
            self.googleLogin(access_Token: token)
        }
    }
    
    internal func saveUserSession(accessToken: String, userID: Int) {
        defaults.set(userID, for: .userID)
        defaults.set(accessToken, for: .accessToken)
    }
    
    internal func setDidLogUserIn(to didLogUserIn: Bool) {
        defaults.set(didLogUserIn, for: .didLogUserIn)
    }
    
    internal func handleGiftsAndStickers() {
        self.fetchGifts()
        self.fetchStickers()
    }
    
    // MARK: - Action
    @IBAction func eyeButtonPressed(_ sender: UIButton) {
        isPasswordHidden = !isPasswordHidden
        let image: UIImage? = isPasswordHidden ? .eyeOpen : .eyeSlash
        sender.setSizeAnimation(scaleXY: 1.2, duration: 0.3)
        Async.main(after: 0.15) { [self] in
            sender.setImage(image, for: .normal)
            passwordTextField.isSecureTextEntry = isPasswordHidden
        }
        
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signInButtonPressed()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        appNavigator.authNavigate(to: .forgotPassword)
    }
    // !!!: Tag values from storyboard
    // 0-apple, 1-facebook, 2-google, 3-woWonder
    @IBAction func socialButtonPressed(_ sender: UIButton) {
        guard let social = SocialButton(rawValue: sender.tag) else {
            Logger.error("recognize button"); return
        }
        switch social {
        case .apple:    Logger.debug("pressed")
        case .facebook: facebookLogin()
        case .google:   googleButtonPressed()
        case .woWonder: appNavigator.authNavigate(to: .loginWithWoWonder)
        }
        
    }
    
    @IBAction func termsButtonButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "\(API.justURL)/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        switch isComingFromStart {
        case true:  appNavigator.authNavigate(to: .registration(comingFromStart: false))
        case false: self.navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            signInButtonPressed()
        }
        return true
    }
}
// MARK: - Helpers
extension LoginViewController {
    
    private func handleSocialLogin() {
        appleSigInView.isHidden = !ControlSettings.showAppleSignIn
        facebookLoginView.isHidden = !ControlSettings.showFacebookLogin
        googleSignInView.isHidden = !ControlSettings.showGoogleLogin
        woWonderLogInView.isHidden = !ControlSettings.showWoWonderLogin
        
        setUpSignInAppleButton()
        
    }
    func setUpSignInAppleButton() {
        
        
        appleButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
        
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController:ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            //            DispatchQueue.main.async {
            //                self.showPasswordCredentialAlert(username: username, password: password)
            //            }
            
        default:
            break
        }
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error sign in with apple")
        
    }
}

// MARK: - ThemeLoadable
extension LoginViewController: LabelThemeLoadable, ButtonThemeLoadable {
    internal func configureButtons() {
        eyeButton.setTitle("", for: .normal)
        forgotPasswordButton.setTitle("Forgot Password?".localized, for: .normal)
    }
    
    internal func configureLabels() {
        let regular11: Typography = .regularText(size: 11)
        let regular13: Typography = .regularText(size: 13)
        
        lblLoginTitle.text = "Login".localized
    }
    
    internal func configureUIViews() {
        emailTextField.setTitle(title: "Email Address".localized, isMandatory: false)
        passwordTextField.setTitle(title: "Password".localized, isMandatory: false)
        passwordTextField.isSecureTextEntry = true
        emailTextField.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)
        emailTextField.tintColor = .black
        passwordTextField.tintColor = .black
        //        emailTextField.tintColor = "EC33B1".toUIColor()
        //        passwordTextField.tintColor = "EC33B1".toUIColor()
        //
        //        let regular13 = Typography.regularText(size: 13).font
        //        emailTextField.font = regular13
        //        passwordTextField.font = regular13
        
        viewLoginButton.cornerRadiusV = viewLoginButton.frame.height / 2
        viewEmail.cornerRadiusV = viewLoginButton.frame.height / 2
        viewPassword.cornerRadiusV = viewLoginButton.frame.height / 2
        viewEmail.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewPassword.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewEmail.borderWidthV = 1
        viewPassword.borderWidthV = 1
    }
    internal func setUpConfigures() {
        configureButtons()
        configureLabels()
        configureUIViews()
        
    }
}
