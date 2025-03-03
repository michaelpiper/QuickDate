//
//  LoginTableItem.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit
import Async
import FBSDKLoginKit
import GoogleSignIn

class LoginTableItem: UITableViewCell {
    @IBOutlet weak var googleIcon: UIImageView!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var forgetPassBtn: UIButton!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var FBSDKButton: FBButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var registeringLabel: UILabel!
    @IBOutlet weak var loginWoWonderBtn: UIButton!
    
    var vc : LoginVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func loginWithWoWonderPressed(_ sender: UIButton) {
        
//        let vc = R.storyboard.authentication.loginWithWoWonderVC()
//        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func forgetPasswordPressed(_ sender: UIButton) {
        let vc = R.storyboard.authentication.forgetPasswordVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func registerPressed(_ sender: UIButton) {
        let vc = R.storyboard.authentication.registerVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func facebookPressed(_ sender: UIButton) {
        self.vc?.facebookLogin()
    }
    
    @IBAction func googlePressed(_ sender: UIButton) {
        if let vc = self.vc {
            vc.onClickGoogleLogin()
        }
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
//        self.vc?.loginPressed(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "")
    }
}

// MARK: - Helpers

extension LoginTableItem {
    
    private func setupUI(){
        self.backView.backgroundColor = .Main_StartColor
        self.backView.alpha = 0.55
        self.usernameTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        signUpBtn.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), for: .normal)
        forgetPassBtn.setTitle(NSLocalizedString("Forgot Password?", comment: "Forgot Password?"), for: .normal)
        FBSDKButton.setTitle(NSLocalizedString("Continue with Facebook", comment: "Continue with Facebook"), for: .normal)
        googleBtn.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), for: .normal)
        loginWoWonderBtn.setTitle(NSLocalizedString("Login with WoWonder", comment: "Login with WoWonder"), for: .normal)
        
        self.registeringLabel.text = NSLocalizedString("BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE", comment: "BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE")
        self.haveAccountLabel.text = NSLocalizedString("DON'T HAVE AN ACCOUNT?", comment: "DON'T HAVE AN ACCOUNT?")
        registerBtn.setTitle(NSLocalizedString("REGISTER", comment: "REGISTER"), for: .normal)
        
        self.googleBtn.isHidden = false
        self.signUpBtn.cornerRadiusV = self.signUpBtn.frame.height / 2
//        if ControlSettings.showSocialLogin{
//            self.googleIcon.isHidden = false
//            self.facebookIcon.isHidden = false
//            self.googleBtn.isHidden = false
//            self.loginWoWonderBtn.isHidden = false
//            self.FBSDKButton.isHidden = false
//        }else{
//            self.googleIcon.isHidden = true
//            self.facebookIcon.isHidden = true
//            self.loginWoWonderBtn.isHidden = true
//             self.googleBtn.isHidden = true
//            self.FBSDKButton.isHidden = true
//        }
        
        facebookIcon.isHidden = !ControlSettings.showFacebookLogin
        FBSDKButton.isHidden = !ControlSettings.showFacebookLogin
        googleIcon.isHidden = !ControlSettings.showGoogleLogin
        googleBtn.isHidden = !ControlSettings.showGoogleLogin
        loginWoWonderBtn.isHidden = !ControlSettings.showWoWonderLogin
        
    }
    
}
