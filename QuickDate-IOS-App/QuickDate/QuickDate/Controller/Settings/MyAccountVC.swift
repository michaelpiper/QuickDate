//
//  MyAccountVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class MyAccountVC: BaseViewController {
    
    @IBOutlet weak var myAccountLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var countryText: UITextField!
    
    @IBOutlet var usernameView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var countryView: UIView!
    
    // MARK: - Properties
    
    private let appInstance: AppInstance = .shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        configView()
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK:- Methods
    func configView() {
        userNameText.delegate = self
        emailText.delegate = self
        phoneText.delegate = self
        countryText.delegate = self
        
        userNameText.tintColor = .PrimaryColor
        emailText.tintColor = .PrimaryColor
        phoneText.tintColor = .PrimaryColor
        countryText.tintColor = .PrimaryColor
        
        usernameView.borderWidthV = 1
        emailView.borderWidthV = 1
        phoneView.borderWidthV = 1
        countryView.borderWidthV = 1
        
        usernameView.borderColorV = .clear
        emailView.borderColorV = .clear
        phoneView.borderColorV = .clear
        countryView.borderColorV = .clear
        
    }
    
    private func setupUI(){
        self.myAccountLabel.text = NSLocalizedString("My Account", comment: "My Account")
        self.userNameText.placeholder = NSLocalizedString("Username", comment: "Username")
        self.emailText.placeholder = NSLocalizedString("Email", comment: "Email")
        self.phoneText.placeholder = NSLocalizedString("Phone Number", comment: "Phone Number")
        self.countryText.placeholder = NSLocalizedString("Country", comment: "Country")
        saveButton.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        
        self.userNameText.text = appInstance.userProfileSettings?.username
        self.emailText.text = appInstance.userProfileSettings?.email
        self.phoneText.text = appInstance.userProfileSettings?.phone_number
        self.countryText.text = appInstance.userProfileSettings?.country
    }
   
    private func updateUserAccount() {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let username = self.userNameText.text ?? ""
            let email = self.emailText.text ?? ""
            let phoneNo = self.phoneText.text ?? ""
            let country = self.countryText.text ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.username: username,
                API.PARAMS.email: email,
                API.PARAMS.phone_number: phoneNo,
                API.PARAMS.country: country
                ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.debug("UPDATED")
//                                AppInstance.shared.fetchUserProfile(view: self.view, completion: {
//                                     Logger.debug("UPDATED")
//                                })
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
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
                }
            })            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        updateUserAccount()

    }
}

extension MyAccountVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameText {
            usernameView.borderColorV = .PrimaryColor
        } else if textField == emailText {
            emailView.borderColorV = .PrimaryColor
        } else if textField == phoneText {
            phoneView.borderColorV = .PrimaryColor
        } else if textField == countryText {
            countryView.borderColorV = .PrimaryColor
        }
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmpty = textField.text?.trimmingCharacters(in: .whitespaces).count == 0
        if textField == userNameText {
            usernameView.borderColorV = .clear//isEmpty ? .clear : .PrimaryColor
        } else if textField == emailText {
            emailView.borderColorV = .clear//isEmpty ? .clear : .PrimaryColor
        } else if textField == phoneText {
            phoneView.borderColorV = .clear//isEmpty ? .clear : .PrimaryColor
        } else if textField == countryText {
            countryView.borderColorV = .clear//isEmpty ? .clear : .PrimaryColor
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
