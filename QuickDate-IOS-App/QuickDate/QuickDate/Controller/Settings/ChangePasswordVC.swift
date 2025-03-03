//
//  ChangePasswordVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

import Toast
import Async
import QuickDateSDK

class ChangePasswordVC: BaseViewController {
    
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var forgetLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var currentPwdText: UITextField!
    @IBOutlet var newPwdText: UITextField!
    @IBOutlet var repeatNewPwdText: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    //MARK: - Methods
    func setupUI() {
        self.changePasswordLabel.text = NSLocalizedString("Change Password", comment: "Change Password")
        self.currentPwdText.placeholder = NSLocalizedString("Current Password", comment: "Current Password")
        self.newPwdText.placeholder = NSLocalizedString("New Password", comment: "New Password")
        self.repeatNewPwdText.placeholder = NSLocalizedString("Repeat Password", comment: "Repeat Password")
        self.forgetLabel.text = NSLocalizedString("If you forgot your password, you can reset it from here.", comment: "If you forgot your password, you can reset it from here.")
    }
    
    private func updatePassword() {
        if (self.currentPwdText.text?.trimmingCharacters(in: .whitespaces).count == 0) {
            Logger.verbose(NSLocalizedString("Please enter Current Password.", comment: "Please enter Current Password."))
            self.view.makeToast(NSLocalizedString("Please enter Current Password.", comment: "Please enter Current Password."))
        }else if (newPwdText.text?.trimmingCharacters(in: .whitespaces).count == 0) {
            Logger.verbose(NSLocalizedString("Please enter New Password..", comment: "Please enter New Password."))
            self.view.makeToast(NSLocalizedString("Please enter New Password.", comment: "Please enter New Password."))
        }else  if (repeatNewPwdText.text?.trimmingCharacters(in: .whitespaces).count == 0) {
            Logger.verbose("Please enter Repeat Password.")
            self.view.makeToast(NSLocalizedString("Please enter Repeat Password.", comment: "Please enter Repeat Password."))
        }else if (newPwdText.text) != (repeatNewPwdText.text) {
            Logger.verbose("Password do not match.")
            self.view.makeToast(NSLocalizedString("Please enter Repeat Password.", comment: "Password do not match."))
        }else{
            if Connectivity.isConnectedToNetwork() {
                self.showProgressDialog(with: "Loading...")
                let accessToken = AppInstance.shared.accessToken ?? ""
                let currentPassword = currentPwdText.text ?? ""
                let newPassword = newPwdText.text ?? ""
                let repeatPassword = self.repeatNewPwdText.text ?? ""
                
                Async.background({
                    ProfileManger.instance.changePassoword(AccessToken: accessToken, currentPwd: currentPassword, newPwd: newPassword, repeatNewPwd: repeatPassword, completionBlock: { (success, sessionError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    Logger.debug("success = \(success?.message ?? "")")
                                    self.view.makeToast(success?.data ?? "")
                                    let appManager: AppManager = .shared
                                    appManager.fetchUserProfile()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    Logger.error("sessionError = \(sessionError?.errors?["error_text"] as? String ?? "")")
                                    self.view.makeToast(sessionError?.errors?["error_text"] as? String ?? "")
                                }
                            })
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    Logger.error("error = \(error?.localizedDescription ?? "")")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                            })
                        }
                    })
                    
                })
            }else{
                Logger.error("internetErrro = \(InterNetError)")
                self.view.makeToast(InterNetError)
            }
        }
    }
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.updatePassword()
    }
}
