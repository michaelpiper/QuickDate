//
//  ListFriendsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class ListFriendsVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    var mediaFiles = [String]()
    var FriendList: [UserProfileSettings] = []
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchFriendLists()
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
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    private func setupUI(){
        self.friendsLabel.text = NSLocalizedString("Friends", comment: "Friends")
        self.noFavLabel.text = NSLocalizedString("You have No Friends", comment: "You have No Friends")
        collectionView.register(UINib(resource: R.nib.listFriendCollectionItem), forCellWithReuseIdentifier: R.reuseIdentifier.listFriendCollectionItem.identifier)
        if ControlSettings.shouldShowAddMobBanner{
            if ControlSettings.googleAds {
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
    
    private func handleGradientColors() {
//        let startColor = Theme.primaryStartColor.colour
//        let endColor = Theme.primaryEndColor.colour
        //        createMainViewGradientLayer(to: upperPrimaryView,
        //                                    startColor: startColor,
        //                                    endColor: endColor)
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
    
    private func fetchFriendLists() {
        self.handleActivityIndicator(to: .start)
        if Connectivity.isConnectedToNetwork() {
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                FriendManager.instance.getListFriends(AccessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                    Async.main {
                        self.handleActivityIndicator(to: .stop)
                    }
                    if let success = success {
                        Async.main({
                            self.dismissProgressDialog {
                                self.FriendList = success.data
                                if self.FriendList.isEmpty {
                                    self.emptyView.isHidden = false
                                }else{
                                    self.emptyView.isHidden = true
                                    self.collectionView.reloadData()
                                }
                                Logger.debug("userList = \(success.message ?? "")")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.handleActivityIndicator(to: .stop)
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.handleActivityIndicator(to: .stop)
                            }
                        })
                    }
                }
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.handleActivityIndicator(to: .stop)
        }
    }
    
    private func handleActivityIndicator(to process: Process) {
        self.activityIndicator.isHidden = process == .stop
        switch process {
        case .start: self.activityIndicator.startAnimating()
        case .stop:  self.activityIndicator.stopAnimating()
        }
    }
    
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.listFriendCollectionItem.identifier, for: indexPath) as! ListFriendCollectionItem
        let object = self.FriendList[indexPath.row]
        cell.delegate = self
        cell.bind(object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40)/2
        return CGSize(width: width, height: 215)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppInstance.shared.addCount == ControlSettings.interestialCount {
            if ControlSettings.facebookAds {
                if interstitialAd1 != nil {
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
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1
        self.mediaFiles.removeAll()
        let vc = R.storyboard.main.showUserDetailsViewController()
        self.mediaFiles.removeAll()
        let userObject = FriendList[indexPath.row]
        vc?.otherUser = .randomUser(userObject)
        vc?.fromProf = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ListFriendsVC: ListFriendDelegate {
    func btnPressed(_ sender: UIButton, id: Int) {
        self.friendUnFriend(uid: id)
    }
    
    private func friendUnFriend(uid: Int) {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let uid1 = String(uid)
            Async.background({
                AddFriendRequestManager.instance.AddRequest(AccessToken: accessToken, uid:uid1) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
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
