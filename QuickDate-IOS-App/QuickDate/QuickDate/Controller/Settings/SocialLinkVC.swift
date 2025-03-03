//
//  SocialLinkVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Toast
import Async
import QuickDateSDK

class SocialLinkVC: BaseViewController {
    
    @IBOutlet weak var socialLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var facebookText: UITextField!
    @IBOutlet var twitterText: UITextField!
    @IBOutlet var googleText: UITextField!
    @IBOutlet var instaText: UITextField!
    @IBOutlet var linkedInText: UITextField!
    @IBOutlet var websiteText: UITextField!
    
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var googleView: UIView!
    @IBOutlet var instaView: UIView!
    @IBOutlet var linkedInView: UIView!
    @IBOutlet var websiteView: UIView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    
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
        facebookText.delegate = self
        twitterText.delegate = self
        googleText.delegate = self
        instaText.delegate = self
        linkedInText.delegate = self
        websiteText.delegate = self
        
        facebookText.tintColor = .PrimaryColor
        twitterText.tintColor = .PrimaryColor
        googleText.tintColor = .PrimaryColor
        instaText.tintColor = .PrimaryColor
        linkedInText.tintColor = .PrimaryColor
        websiteText.tintColor = .PrimaryColor
        
        facebookView.borderWidthV = 1
        twitterView.borderWidthV = 1
        googleView.borderWidthV = 1
        instaView.borderWidthV = 1
        linkedInView.borderWidthV = 1
        websiteView.borderWidthV = 1
        
        facebookView.borderColorV = .clear
        twitterView.borderColorV = .clear
        googleView.borderColorV = .clear
        instaView.borderColorV = .clear
        linkedInView.borderColorV = .clear
        websiteView.borderColorV = .clear
    }
    
    private func setupUI() {
        self.socialLabel.text = NSLocalizedString("Social Links", comment: "Social Links")
        self.facebookText.placeholder = NSLocalizedString("Facebook", comment: "Facebook")
        self.twitterText.placeholder = NSLocalizedString("Twitter", comment: "Twitter")
        self.googleText.placeholder = NSLocalizedString("Google Plus", comment: "Google Plus")
        self.instaText.placeholder = NSLocalizedString("Instagram", comment: "Instagram")
        self.linkedInText.placeholder = NSLocalizedString("LinkedIn", comment: "LinkedIn")
        self.websiteText.placeholder = NSLocalizedString("Website", comment: "Website")
        self.saveButton.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        self.facebookText.text = appInstance.userProfileSettings?.facebook
        self.twitterText.text = appInstance.userProfileSettings?.twitter
        self.googleText.text = appInstance.userProfileSettings?.google
        self.instaText.text = appInstance.userProfileSettings?.instagram
        self.linkedInText.text = appInstance.userProfileSettings?.linkedin
        self.websiteText.text = appInstance.userProfileSettings?.website
    }
    
    private func updateSocialLinks() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let facebook = self.facebookText.text ?? ""
            let twitter = self.twitterText.text ?? ""
            let google = self.googleText.text ?? ""
            let instagram = self.instaText.text ?? ""
            let linkdin = self.linkedInText.text ?? ""
            let website = self.websiteText.text ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.facebook: facebook,
                API.PARAMS.twitter: twitter,
                API.PARAMS.google: google,
                API.PARAMS.instagram: instagram,
                API.PARAMS.linkedin: linkdin,
                API.PARAMS.website: website
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
                                Logger.verbose("UPDATED")
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
    
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        updateSocialLinks()
    }
}

extension SocialLinkVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == facebookText {
            facebookView.borderColorV = .PrimaryColor
        } else if textField == twitterText {
            twitterView.borderColorV = .PrimaryColor
        } else if textField == googleText {
            googleView.borderColorV = .PrimaryColor
        } else if textField == instaText {
            instaView.borderColorV = .PrimaryColor
        } else if textField == linkedInText {
            linkedInView.borderColorV = .PrimaryColor
        } else if textField == websiteText {
            websiteView.borderColorV = .PrimaryColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == facebookText {
            facebookView.borderColorV = .clear
        } else if textField == twitterText {
            twitterView.borderColorV = .clear
        } else if textField == googleText {
            googleView.borderColorV = .clear
        } else if textField == instaText {
            instaView.borderColorV = .clear
        } else if textField == linkedInText {
            linkedInView.borderColorV = .clear
        } else if textField == websiteText {
            websiteView.borderColorV = .clear
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
