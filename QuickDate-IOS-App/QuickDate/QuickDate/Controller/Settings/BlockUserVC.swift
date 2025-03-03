//
//  BlockUserVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class BlockUserVC: BaseViewController, FBInterstitialAdDelegate {
    // MARK: - Properties -
    @IBOutlet weak var blockUserLabel: UILabel!
    @IBOutlet weak var noBlockLabel: UILabel!
    @IBOutlet weak var noBlockImage: UIStackView!
    @IBOutlet var blockedUsersTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    
    private var blockUsersArray: [Blocks] = []
    var interstitial: GADInterstitialAd?
    var interstitialAd1: FBInterstitialAd?
    private let appInstance: AppInstance = .shared
    private var selectedIndex: Int?
    
    // MARK: - Life Cycle Functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        blockedUsersTableView.delegate = self
        blockedUsersTableView.dataSource = self
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
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    
    //MARK:- Methods
    private func setupUI(){
        self.blockUserLabel.text = "Blocked Users"//NSLocalizedString("BLocked Users", comment: "BLocked Users")
        self.noBlockLabel.text = NSLocalizedString("There is no Blocked User", comment: "There is no Blocked User")
//        self.blockUsersArray = appInstance.userProfileSettings?.blocks ?? []
//        self.noBlockImage.isHidden = !(self.blockUsersArray.count == 0)
        blockedUsersTableView.register(UINib(resource: R.nib.blockUserTableItem), forCellReuseIdentifier: R.reuseIdentifier.blockUserTableItem.identifier)
        if ControlSettings.shouldShowAddMobBanner {
            if ControlSettings.googleAds {
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                                       request: request) { (ad, error) in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    self.interstitial = ad
                }
            }
        }
        AppManager.shared.fetchUserProfile()
        AppManager.shared.onUpdateProfile = {
            Async.main {
                self.blockUsersArray = AppInstance.shared.userProfileSettings?.blocks ?? []
                self.noBlockImage.isHidden = !(self.blockUsersArray.count == 0)
                self.blockedUsersTableView.reloadData()
            }
        }
    }
    func CreateAd() -> GADInterstitialAd? {
        GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                               request: GADRequest()) { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
        }
        return  self.interstitial
    }
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func unBlockUser(userId: Int, index: Int) {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = userId 
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                
                                AppManager.shared.fetchUserProfile()
                                self.view.makeToast(success?.message ?? "")
                                self.blockUsersArray.remove(at: index)
                                self.blockedUsersTableView.reloadData()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                let errorText = sessionError?.errors?["error_text"] as? String
                                self.view.makeToast(errorText ?? "")
                                Logger.error("sessionError = \(errorText ?? "")")
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

extension BlockUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blockUserTableItem.identifier, for: indexPath) as! BlockUserTableItem
        let object = self.blockUsersArray[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.unblockBtn.tag = indexPath.row
        cell.bind(object.data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension BlockUserVC: UnblockUserDelegate {
    func unblockBtnPressed(_ sender: UIButton) {
        if AppInstance.shared.addCount == ControlSettings.interestialCount {
            if ControlSettings.facebookAds {
                if let ad = interstitialAd1 {
                    interstitialAd1 = FBInterstitialAd(placementID: ControlSettings.addsOfFacebookPlacementID)
                    interstitialAd1?.delegate = self
                    interstitialAd1?.load()
                } else {
                    print("Ad wasn't ready")
                }
            }else if ControlSettings.googleAds {
                interstitial?.present(fromRootViewController: self)
                interstitial = CreateAd()
                AppInstance.shared.addCount = 0
            }
        }
        appInstance.addCount = appInstance.addCount + 1
        self.selectedIndex = sender.tag
        
        let vc = R.storyboard.popUps.warningPopUpVC()
        vc?.descriptionSTR = "Do you want to unblock this user ?".localized
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

extension BlockUserVC: WarningPopupDelegate {
    func yesBtnPressed(_ sender: UIButton, type: String) {
        if let selectedIndex = self.selectedIndex {
            if let objectID = appInstance.userProfileSettings?.blocks[selectedIndex].block_userid {
                self.unBlockUser(userId: objectID, index: selectedIndex)
            }
        }
    }
    
    func noBtnPressed(_ sender: UIButton) {
        
    }
}
