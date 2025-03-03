//
//  RegisterViewController.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 8.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleSignIn
import QuickDateSDK
import AuthenticationServices
class RegisterViewController: BaseViewController {
    
    typealias UpdatingValues = (genderCode: String, birthday: String)
    
    // MARK: - Views
    /* !!!: Views index list is below be careful if you wanna change any UI
     0-FirstName, 1-LastName, 2-Email, 3-Username, 4-Password,
     5-Confirm Password, 6-Gender, 7-Birthday
     */
    
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var googleSignInView: UIView!
    @IBOutlet weak var woWonderLogInView: UIView!
    @IBOutlet weak var appleSigInView: UIView!
    @IBOutlet weak var backView: UIView!
                                
    @IBOutlet weak var viewRegisterButton: UIView!
    @IBOutlet var viewTextFieldCollection: [UIView]!
    
    @IBOutlet weak var txtDOB: FloatingTextField!
    @IBOutlet weak var txtGender: FloatingTextField!
    // TextFields
    @IBOutlet var textFieldList: [FloatingTextField]!
    // Buttons
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var eyeConfirmPasswordButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    // TODO: There is a bug in storyboard
    // You can't change the button title on storyboard
    // find the bug and remove emptyButtonList
    @IBOutlet var emptyButtonList: [UIButton]!
    
    // MARK: - Properties
    // Dependency Injections
    internal let appNavigator: AppNavigator
    internal let authErrorHandler: AuthErrorHandler = .default
    internal let appInstance: AppInstance = .shared
    internal let userManager: UserManager = .instance
    internal let appManager: AppManager = .shared
    internal let defaults: Defaults = .shared
    
    private let profileManager: ProfileManger = .instance
    // Others
    private let isComingFromStart: Bool
    private var isPasswordHidden = true
    
    private var genderCode: String?
    private var birthDay: Date?
    
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
        appManager.saveSettingsToLocalDataBase()
    }
    
    private func fetchRegisteringEntries() throws -> RegisterCredentials {
        do {
           // let name = try authErrorHandler.checkName(textFieldList[safe: 0]?.text)
           // let lastName = try authErrorHandler.checkLastName(textFieldList[safe: 1]?.text)
            let username = try authErrorHandler.checkUserName(textFieldList[safe: 2]?.text)
            let email = try authErrorHandler.checkEmail(textFieldList[safe: 3]?.text)
            let password = try authErrorHandler.checkMatchingPassword(first: textFieldList[safe: 4]?.text,
                                                                      second: textFieldList[safe: 5]?.text)
            
            return RegisterCredentials(firstName: "", lastName: "", email: email,
                                       username: username, password: password)
            
        } catch {
            throw error
        }
    }
    
    private func getUserValues() throws -> UpdatingValues {
        do {
            let genderCode = try authErrorHandler.checkGender(genderCode)
            let birthDay = try authErrorHandler.checkBirthday(with: self.birthDay)
            return (genderCode, birthDay)
        } catch {
            throw error
        }
    }
    
    private func saveUserGenderAndBirthday(with values: UpdatingValues) {
        Async.background({
            let params: APIParameters = [
                API.PARAMS.gender: values.genderCode,
                API.PARAMS.birthday: values.birthday
            ]
            self.profileManager.updateAccount(with: params) { (result: Result<String, Error>) in
                switch result {
                    
                case .failure(let error):
                    Logger.error(error)
                    
                case .success(let text):
                    Logger.debug(text)
                }
            }
        })
    }
    
    private func registerUser(with credentials: RegisterCredentials) {
        
        self.showProgressDialog(with: "Loading...")
        
        Async.background({
            let userManager: UserManager = .instance
            
            userManager.registerUser(with: credentials) { (success, sessionError, error) in
                
                // 1. Check Error
                if let error = error {
                    Async.main({
                        self.dismissProgressDialog {
                            self.showOKAlertOverNavBar(title: "Security".localized,
                                                       message: error.localizedDescription)
                        }
                    })
                    
                // 2.Check Session error
                } else if let sessionError = sessionError {
                    Async.main{
                        self.dismissProgressDialog {
                            let errors = sessionError["errors"] as? [String: Any]
                            let errorText = errors?["error_text"] as? String
                            self.showOKAlertOverNavBar(title: "Security".localized,
                                                       message: errorText)
                        }
                    }
                } else if let success = success {
                    Async.main { [self] in
                        
                        dismissProgressDialog {
                            let data = success["data"] as? [String: Any]
                            let accessToken  = data?["access_token"] as? String
                            let userID = data?["user_id"] as? Int
                            
                            Logger.verbose("Access Token = \(accessToken ?? "")")
                            Logger.verbose("userID = \(userID  ?? 0)")
                            
                            self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
                            self.appManager.reloadAllDataFromRemoteDatabase()
                            self.setDidLogUserIn(to: true)
                            self.handleGiftsAndStickers()
                            self.appNavigator.navigate(to: .mainTab)//dashboardNavigate(to: .intro)
                            self.view.makeToast("Created an Account Successfully...".localized)
                            
                        }
                    }
                }
            }
        })
    }
    
    private func googleButtonPressed() {
        GoogleSocialLogin.shared.googleLogin(vc: self) { [weak self] (token) in
            guard let self = self else { return }
            self.googleLogin(access_Token: token)
        }
    }
        
    // MARK: - Private & Internal Functions
    
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
    
    private func showBirthDayPicker() {
        let alertController = UIAlertController(title: "Birthday\n\n\n\n\n\n\n\n",
                                                message: nil, preferredStyle: .alert)
        let datePicker = createDatePicker()
        datePicker.frame = CGRect(x: 0, y: 25, width: 270, height: 200)
        if let birthDay = birthDay { // show selected birthday
            datePicker.date = birthDay
        }
        alertController.view.addSubview(datePicker)
        let selectAction = UIAlertAction(title: "Ok".localized, style: .default, handler: { _ in
            self.fetchBirthday(datePicker.date)
        })
        alertController.addAction(selectAction)
        alertController.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    private func fetchBirthday(_ date: Date) {
        self.birthDay = date
        let day = date.getFormattedDate(format: "dd-MM-yyyy")
        txtDOB.text = day
    }
    
    // MARK: - Actions
    
    @IBAction func eyeButtonPressed(_ sender: UIButton) {
        isPasswordHidden = !isPasswordHidden
        let image: UIImage? = isPasswordHidden ? .eyeOpen : .eyeSlash
        sender.setSizeAnimation(scaleXY: 1.2, duration: 0.3)
        Async.main(after: 0.15) { [self] in
//            sender.setImage(image, for: .normal)
            self.eyeButton.setImage(image, for: .normal)
            self.eyeConfirmPasswordButton.setImage(image, for: .normal)
            textFieldList[safe: 4]?.isSecureTextEntry = isPasswordHidden
            textFieldList[safe: 5]?.isSecureTextEntry = isPasswordHidden
        }
    }
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .selectGender(self))
    }
    
    @IBAction func birthdayButtonPressed(_ sender: UIButton) {
        showBirthDayPicker()
    }
    
    @IBAction func createAnAccountButtonPressed(_ sender: UIButton) {
        do {
            let credentials = try fetchRegisteringEntries()
            let userValues = try getUserValues()
            registerUser(with: credentials)
            saveUserGenderAndBirthday(with: userValues)
        } catch {
            presentCustomAlertPresentableWith(error, isNavBar: true)
        }
    }
    // !!!: Tag values are coming from storyboard
    // Tags: 0-apple, 1-facebook, 2-google, 3-woWonder
    @IBAction func socialButtonButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func termsButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.settings.helpVC()
        vc?.checkString = "terms"
        vc?.isPresent = true
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        /*if let url = URL(string: "\(API.justURL)/terms") {
            UIApplication.shared.open(url)
        }*/
    }
    
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        switch isComingFromStart {
        case true:  appNavigator.authNavigate(to: .login(comingFromStart: false))
        case false: self.navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - UITextFieldDelegate


extension RegisterViewController: UITextFieldDelegate {
    
    private func fetchIndexNumber(_ textField: UITextField) -> Int {
        guard let selectedIndex = textFieldList.firstIndex(of: textField as! FloatingTextField) else {
            Logger.error("getting textField index"); return 0
        }
        return selectedIndex
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let selectedIndex = fetchIndexNumber(textField)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let index = fetchIndexNumber(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = fetchIndexNumber(textField)
        if index < 5 {
            textFieldList[index + 1].becomeFirstResponder()
        } else {
            textFieldList[index].resignFirstResponder()
            appNavigator.popUpNavigate(to: .selectGender(self))
        }
        return true
    }
}

// MARK: - GenderDelegate

extension RegisterViewController: SelectGenderPopUpViewControllerDelegate {
    func setGender(to gender: GenderOfUser?) {
        guard let gender = gender else {
            Logger.error("getting gender"); return
        }
        genderCode = gender.code
        txtGender.text = gender.name.capitalized.localized
        if birthDay == nil {
            showBirthDayPicker()
        }
    }
}

// MARK: - Helper

extension RegisterViewController {
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = Theme.primaryBackgroundColor.colour
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return datePicker
    }
    
    // handle texts of labels and placeholders of textFields
    private func createLocalizedText(at index: Int) -> String {
        switch index {
        case 0:  return "Full Name".localized
        case 1:  return "Last Name".localized
        case 2:  return "Username".localized
        case 3:  return "Email Address".localized
        case 4:  return "Password".localized
        case 5:  return "Confirm Password".localized
        case 6:  return "Gender".localized
        case 7:  return "Birthday".localized
        default: return ""
        }
    }
    
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
        authorizationController.performRequests()
    }
}

extension RegisterViewController:ASAuthorizationControllerDelegate{
   
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.authorizationCode
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let authorizationCode = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
            print("authorizationCode: \(authorizationCode)")
            self.appleLogin(access_Token: authorizationCode)
            //self.appleLogin(access_Token: authorizationCode)
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error sign in with apple")
    }
}
// MARK: - ThemeLoadable
extension RegisterViewController: LabelThemeLoadable, ButtonThemeLoadable {
    internal func configureButtons() {
        eyeButton.setTitle("", for: .normal)
//        createAccountButton.setTheme(background: .secondaryBackgroundColor,
//                                     tint: .primaryEndColor,
//                                     title: "Create a New Account".localized,
//                                     font: .regularText(size: 11))
        
      
        viewRegisterButton.cornerRadiusV = viewRegisterButton.frame.height / 2
        
        for view in viewTextFieldCollection {
            view.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
            view.borderWidthV = 1
            view.cornerRadiusV = view.frame.height / 2
        }
        
        
        emptyButtonList.forEach {$0.setTitle("", for: .normal)}
    }
    
    internal func configureLabels() {
        let regular11: Typography = .regularText(size: 11)
        let regular13: Typography = .regularText(size: 13)
        let regular14: Typography = .regularText(size: 14)
    }
    
    internal func configureUIViews() {
        txtDOB.setTitle(title: "Birthday", isMandatory: false)
        txtGender.setTitle(title: "Gender", isMandatory: false)

        textFieldList.enumerated().forEach { (index, textField) in
            textField.tintColor = .black
            textField.setTitle(title: createLocalizedText(at: index), isMandatory: false)
        }
        
    }
    
    internal func setUpConfigures() {
        configureButtons()
        configureLabels()
        configureUIViews()
//        self.backView.backgroundColor = Theme.primaryEndColor.colour
    }
}
