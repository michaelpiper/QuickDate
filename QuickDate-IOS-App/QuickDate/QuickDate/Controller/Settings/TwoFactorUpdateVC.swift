//
//  TwoFactorUpdateVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import DropDown
import QuickDateSDK
import GoogleMobileAds

protocol TwoFactorAuthDelegate {
    func getTwoFactorUpdateString(type:String)
}

class TwoFactorUpdateVC: BaseViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var selectText: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var twoFactorLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!

    var bannerView: GADBannerView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    var typeString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setupUI() {
        self.saveBtn.addShadow(offset: .init(width: 0, height: 2))
        self.twoFactorLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
        self.textLabel.text = NSLocalizedString("Turn on 2-step login to level-up your account security. Once turned on, you'll use both your password and a 6-digit security code send to your  phone or email to log in.", comment: "Turn on 2-step login to level-up your account security. Once turned on, you'll use both your password and a 6-digit security code send to your  phone or email to log in.")
        lblTitle.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
        saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        Logger.verbose("AppInstance.instance.userProfile?.data?.twoFactor = \(appInstance.userProfileSettings?.two_factor_verified ?? false)")
        self.viewSave.cornerRadiusV = self.viewSave.bounds.height / 2
        if appInstance.userProfileSettings?.two_factor ?? false {
            self.typeString = "Disable"
            self.selectText.text = NSLocalizedString("Disable", comment: "Disable")
        }else{
            self.typeString = "Enable"
            self.selectText.text = NSLocalizedString("Enable", comment: "Enable")
        }
        if ControlSettings.shouldShowAddMobBanner {
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    @IBAction func selectBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.popUps.twoFactorPopupVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.showProgressDialog(with: "Loading")
        //        if AppInstance.shared.userProfile["two_factor_verified"] as? String == "1"{
        if appInstance.userProfileSettings?.two_factor_verified ?? false {
            self.updateTwoFactorSendCode(twofactor:self.typeString ?? "")
        }else{
            self.sendVerificationCode()
        }
    }
    
    private func updateTwoFactorSendCode(twofactor:String){
        self.showProgressDialog(with: "Loading...")
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        let params = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.two_factor: twofactor
            ] as [String : Any]
        
        Async.background({
            ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                if success != nil {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                            self.navigationController?.popViewController(animated: true)
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
                            self.view.makeToast(error?.localizedDescription)
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
    
    private func sendVerificationCode() {
        //        let email = AppInstance.shared.userProfile["email"] as? String ?? ""
        //        let email = AppInstance.shared.userProfile["email"] as? String ?? ""
        let email = appInstance.userProfileSettings?.email ?? ""
        let userID = AppInstance.shared.userId ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        
        
        
        Async.background({
            ProfileManger.instance.updateTwoaFactor(UserId: userID, AccessToken: accessToken, email: email) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                            let appManager: AppManager = .shared
                            appManager.fetchUserProfile()
                            
                            let vc = R.storyboard.settings.updateTwoFactorSettingPopupVC()
                            vc?.modalTransitionStyle = .coverVertical
                            vc?.modalPresentationStyle = .fullScreen
                            self.present(vc!, animated: true, completion: nil)
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
}

extension TwoFactorUpdateVC: TwoFactorTypePopupDelegate {
    func selectedType(_ selected: String) {
        if selected == "Disable" {
            self.typeString = "Disable"
            self.selectText.text = NSLocalizedString("Disable", comment: "Disable")
        }else{
            self.typeString = "Enable"
            self.selectText.text = NSLocalizedString("Enable", comment: "Enable")
        }
    }
}
