//
//  RegisterTableItem.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

import Async
import GoogleSignIn
import FBSDKLoginKit

class RegisterTableItem: UITableViewCell {
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var googleIcon: UIImageView!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var genderTextField: CustomTextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var signiNBTN: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var registeringLabel: UILabel!
    var vc:RegisterVC?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    private func setupUI(){
        self.backView.backgroundColor = .Main_StartColor
              self.backView.alpha = 0.55
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.emailTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "Username")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        self.confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "Confirm Password")
//        self.genderBtn.setTitle(NSLocalizedString("Gender", comment: "Gender"), for: .normal)
        self.createAccountBtn.setTitle(NSLocalizedString("CREATE AN ACCOUNT", comment: "CREATE AN ACCOUNT"), for: .normal)
        self.facebookBtn.setTitle(NSLocalizedString("Continue with Facebook", comment: "Continue with Facebook"), for: .normal)
        self.googleBtn.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), for: .normal)
       
        self.registeringLabel.text = NSLocalizedString("BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE", comment: "BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE")
        self.haveAccountLabel.text = NSLocalizedString("DON'T HAVE AN ACCOUNT?", comment: "DON'T HAVE AN ACCOUNT?")
        signiNBTN.setTitle(NSLocalizedString("SIGN IN", comment: "SIGN IN"), for: .normal)
        
//        self.navigationController?.navigationBar.transparentNavigationBar()
//        if ControlSettings.showSocialLogin{
//            self.googleIcon.isHidden = false
//            self.facebookIcon.isHidden = false
//             self.googleBtn.isHidden = false
//            self.facebookBtn.isHidden = false
//        }else{
//            self.googleIcon.isHidden = true
//            self.facebookIcon.isHidden = true
//             self.googleBtn.isHidden = true
//            self.facebookBtn.isHidden = true
//        }
        
        facebookIcon.isHidden = !ControlSettings.showFacebookLogin
        facebookBtn.isHidden = !ControlSettings.showFacebookLogin
        googleIcon.isHidden = !ControlSettings.showGoogleLogin
        googleBtn.isHidden = !ControlSettings.showGoogleLogin
    }
    
    @IBAction func googlePressed(_ sender: UIButton) {
        if let vc = self.vc {
            vc.onClickGoogleLogin()
        }
    }
    
    @IBAction func facebookPressed(_ sender: UIButton) {
        
        self.vc?.facebookLogin()
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        self.vc?.registerPressed(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", email: self.emailTextField.text ?? "", username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", confirmPass: self.confirmPasswordTextField.text ?? "", gender: self.vc?.gender ?? "")
    }
    @IBAction func signInPressed(_ sender: UIButton) {
        guard let isFromStart = vc?.isFromStart else {
            Logger.error("is from start"); return
        }
        switch isFromStart {
        case true:  let vc = AppNavigator.shared.authNavigate(to: .login(comingFromStart: false))
        case false: self.vc?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func genderPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Gender", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let male = UIAlertAction(title: "MALE", style: .default) { (action) in
            self.vc?.gender = "Male"
            self.genderTextField.text = "male"
        }
        let female = UIAlertAction(title: "FEMALE", style: .default) { (action) in
            self.vc?.gender = "female"
            self.genderTextField.text = "Female"
        }

        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: nil)
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.vc?.present(alert, animated: true, completion: nil)
    }
    
}
