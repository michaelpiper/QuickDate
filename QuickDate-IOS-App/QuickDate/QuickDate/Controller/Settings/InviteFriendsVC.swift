//
//  InviteFriendsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class InviteFriendsVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
//    @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var inviteFriendLabel: UILabel!
    
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    private func setupUI(){
        self.inviteFriendLabel.text = NSLocalizedString("Invite Friends", comment: "Invite Friends")
        tableView.register(UINib(resource:R.nib.inviteFriendsTableItem), forCellReuseIdentifier: R.reuseIdentifier.inviteFriendsTableItem.identifier)
                           tableView.register(UINib(resource:R.nib.inviteFriendsSecondTableItem), forCellReuseIdentifier: R.reuseIdentifier.inviteFriendsSecondTableItem.identifier)
        if ControlSettings.shouldShowAddMobBanner{
            
            if ControlSettings.googleAds{
                
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                                       request: request,
                                       completionHandler: { (ad, error) in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    self.interstitial = ad
                }
                )
            }
        }
    }
    func CreateAd() -> GADInterstitialAd {
        
        GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                               request: GADRequest(),
                               completionHandler: { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
        }
        )
        return  self.interstitial
        
    }
    
    // MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension InviteFriendsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inviteFriendsTableItem.identifier, for: indexPath) as! InviteFriendsTableItem
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inviteFriendsSecondTableItem.identifier, for: indexPath) as! InviteFriendsSecondTableItem
            cell.configView(row: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppInstance.shared.addCount == ControlSettings.interestialCount {
            if ControlSettings.facebookAds {
                if let ad = interstitial {
                    interstitialAd1 = FBInterstitialAd(placementID: ControlSettings.addsOfFacebookPlacementID)
                    interstitialAd1?.delegate = self
                    interstitialAd1?.load()
                } else {
                    print("Ad wasn't ready")
                }
            }else if ControlSettings.googleAds{
                interstitial.present(fromRootViewController: self)
                interstitial = CreateAd()
                AppInstance.shared.addCount = 0
            }
        }
        let appInstance: AppInstance = .shared
        appInstance.addCount = appInstance.addCount + 1
        if indexPath.row == 1 {
            UIPasteboard.general.string = "\(API.baseURL)@\(appInstance.userProfileSettings?.username ?? "")"
            self.view.makeToast("copy to clipboard ")
        } else if indexPath.row == 2 {
            guard let vc = R.storyboard.settings.phoneContactsVC() else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            self.share(stringURL: "\(API.baseURL)@\(appInstance.userProfileSettings?.username ?? "")")
        }
    }
    
    private func share(stringURL:String){
        let someText:String = stringURL
        let objectsToShare:URL = URL(string: stringURL)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTencentWeibo]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
