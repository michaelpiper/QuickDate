//
//  DeleteAccountVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class DeleteAccountVC: BaseViewController {

    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var removeAccountButton: UIButton!
    @IBOutlet var checkboxButton: UIButton!
    
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK: - Methods
    func setupUI() {
        self.deleteAccountLabel.text = NSLocalizedString("Delete Account", comment: "Delete Account")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        let str = NSLocalizedString("Yes, I want to delete ", comment: "Yes, I want to delete ") + "\(AppInstance.shared.userProfileSettings?.username ?? "")" + NSLocalizedString(" permanently from QuickDate Account.", comment: " permanently from QuickDate Account.")
        self.bottonLabel.text = str
        self.removeAccountButton.setTitle(NSLocalizedString("REMOVE ACCOUNT", comment: "REMOVE ACCOUNT"), for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.isCheck.toggle()
        sender.setImage(UIImage(named: self.isCheck ? "icn_select" : "icn_unselect"), for: .normal)
    }
    
    @IBAction func removeAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isCheck {
            if self.passwordTextField.text!.isEmpty{
                self.view.makeToast("Please enter password")
            }else{
                self.deleteAccount()
            }
        }else{
            self.view.makeToast("Please verify you want to delete the your account parmanently")
        }
    }
    
    private func deleteAccount(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let password = self.passwordTextField.text ?? ""
            Async.background({
                UserManager.instance.deleteAccount(AccessToken: accessToken, Password: password, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                UserDefaults.standard.removeObject(forKey: Local.USER_SESSION.User_Session)
                                let vc = R.storyboard.authentication.main()
                                self.appDelegate.window?.rootViewController = vc
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?["error_text"] as? String ?? "")
                                Logger.error("sessionError = \(sessionError?.errors?["error_text"] as? String ?? "")")
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
                    
                })
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
