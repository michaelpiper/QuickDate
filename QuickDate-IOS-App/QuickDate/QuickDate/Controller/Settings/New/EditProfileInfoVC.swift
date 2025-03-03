//
//  EditProfileInfoVC.swift
//  QuickDate
//
//  Created by iMac on 28/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class EditProfileInfoVC: BaseViewController {
    
    // MARK: - Properties -
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var relationshipTextField: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var workStatusTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var locationTextView: UIView!
    @IBOutlet weak var relationshipTextView: UIView!
    @IBOutlet weak var educationTextView: UIView!
    @IBOutlet weak var workStatusTextView: UIView!
    @IBOutlet weak var languageTextView: UIView!
    @IBOutlet weak var birthdayTextView: UIView!
    @IBOutlet weak var lastNameTextView: UIView!
    @IBOutlet weak var firstNameTextView: UIView!
    
    private let appInstance: AppInstance = .shared
    private let appNavigator: AppNavigator = .shared
    var relationStripStringIndex:String? = ""
    var workStatusStringIndex:String? = ""
    var educationStringIndex:String? = ""
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configView()
        self.showDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: - Selectors -
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*@IBAction func locationButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let vc = R.storyboard.settings.mapController() else {return}
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }*/
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .language))
        case 1: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .relationship))
        case 2: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .workStatus))
        case 3: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .education))
        default: break
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        updateProfile()
    }
    
    @objc func donedatePicker() {
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
}

extension EditProfileInfoVC {
    //MARK:- Methods
    func configView() {
        birthdayTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        locationTextField.delegate = self
        
        birthdayTextField.tintColor = .PrimaryColor
        locationTextField.tintColor = .PrimaryColor
        lastNameTextField.tintColor = .PrimaryColor
        firstNameTextField.tintColor = .PrimaryColor
        
        birthdayTextView.borderWidthV = 1
        lastNameTextView.borderWidthV = 1
        firstNameTextView.borderWidthV = 1
        locationTextView.borderWidthV = 1
        
        locationTextView.borderColorV = .clear
        birthdayTextView.borderColorV = .clear
        lastNameTextView.borderColorV = .clear
        firstNameTextView.borderColorV = .clear
    }
    
    private func setupUI() {
        self.firstNameTextField.placeholder = "First name".localized
        self.lastNameTextField.placeholder = "Last name".localized
        self.birthdayTextField.placeholder = "Birthday".localized
        self.locationTextField.placeholder = "Location".localized
        self.languageTextField.placeholder = "Language".localized
        self.relationshipTextField.placeholder = "Relationship".localized
        self.workStatusTextField.placeholder = "Work status".localized
        self.educationTextField.placeholder = "Education".localized
        
        let userSettings =  appInstance.userProfileSettings
        self.firstNameTextField.text = userSettings?.first_name
        self.lastNameTextField.text = userSettings?.last_name
        self.birthdayTextField.text = userSettings?.birthday
        self.locationTextField.text = userSettings?.location
        self.languageTextField.text = userSettings?.profile.preferredLanguage.text
        
        if let relationship = userSettings?.profile.relationShip.text {
            self.relationshipTextField.text = relationship.htmlAttributedString ?? ""
        }
        
        if let workStatus = userSettings?.profile.workStatus.text {
            self.workStatusTextField.text = workStatus.htmlAttributedString ?? ""
        }
        
        if let education = userSettings?.profile.education.text {
            self.educationTextField.text = education.htmlAttributedString ?? ""
        }
        self.relationStripStringIndex = userSettings?.profile.relationShip.type
        self.workStatusStringIndex = userSettings?.profile.workStatus.type
        self.educationStringIndex = userSettings?.profile.education.type
    }
    
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        // ToolBar
        
        //done button & cancel button
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        birthdayTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        birthdayTextField.inputView = datePicker
        
    }
    
    
}

//MARK: - API Services -
extension EditProfileInfoVC {
    private func updateProfile() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let firstname = self.firstNameTextField.text ?? ""
            let lastname = self.lastNameTextField.text ?? ""
            let birthdayString = self.birthdayTextField.text ?? ""
            let location = self.locationTextField.text ?? ""
            let language = self.languageTextField.text ??  ""
            let relationshipStatus = self.relationStripStringIndex ?? ""
            let workStatus = self.workStatusStringIndex ?? ""
            let education = self.educationStringIndex ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.first_name: firstname,
                API.PARAMS.last_name: lastname,
                API.PARAMS.birthday: birthdayString,
                API.PARAMS.location: location,
                API.PARAMS.language: language.lowercased(),
                API.PARAMS.relationship: relationshipStatus,
                API.PARAMS.work_status: workStatus,
                API.PARAMS.education: education
                ] as [String : Any]

            print(params)
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
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
}

extension EditProfileInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthdayTextField {
            birthdayTextView.borderColorV = .PrimaryColor
        } else if textField == lastNameTextField {
            lastNameTextView.borderColorV = .PrimaryColor
        } else if textField == firstNameTextField {
            firstNameTextView.borderColorV = .PrimaryColor
        } else if textField == locationTextField {
            locationTextView.borderColorV = .PrimaryColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == birthdayTextField {
            birthdayTextView.borderColorV = .clear
        } else if textField == lastNameTextField {
            lastNameTextView.borderColorV = .clear
        } else if textField == firstNameTextField {
            firstNameTextView.borderColorV = .clear
        } else if textField == locationTextField {
            locationTextView.borderColorV = .clear
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension EditProfileInfoVC: getAddressDelegate {
    func getAddress(address: String) {
        self.locationTextField.text = address
    }
}

extension EditProfileInfoVC: DidSetProfilesParamDelegate {
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .language {
            self.languageTextField.text = selectedString
        } else if type == .relationship {
            self.relationshipTextField.text = selectedString
            self.relationStripStringIndex = index
        } else if type == .workStatus {
            self.workStatusTextField.text = selectedString
            self.workStatusStringIndex = index
        } else if type == .education {
            self.educationTextField.text = selectedString
            self.educationStringIndex = index
        }
    }
}
