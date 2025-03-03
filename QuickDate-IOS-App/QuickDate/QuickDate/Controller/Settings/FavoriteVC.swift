//
//  FavoriteVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class FavoriteVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
//    @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteUser = [UserProfileSettings]()
    var mediaFiles = [String]()
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.fetchFavoriteData()
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
//        let startColor = Theme.primaryStartColor.colour
//        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    private func setupUI(){
        collectionView.register(UINib(resource: R.nib.favoriteCollectionItem), forCellWithReuseIdentifier: R.reuseIdentifier.favoriteCollectionItem.identifier)
        self.favoriteLabel.text = NSLocalizedString("Favorite", comment: "Favorite")
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
    private func fetchFavoriteData() {
        if Connectivity.isConnectedToNetwork(){
            self.favoriteUser.removeAll()
            let accessToken = AppInstance.shared.accessToken ?? ""
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            Async.background({
                FavoriteManager.instance.fetchFavorite(AccessToken: accessToken, limit: 50, offset: 0) { (success, sessionError, error) in
                    Async.main {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                    if success != nil {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? [])")
                                if (success?.data.isEmpty)!{
                                    self.emptyView.isHidden = false
                                }else{
                                    self.favoriteUser = success?.data ?? []
                                    self.collectionView.reloadData()
                                    self.emptyView.isHidden = true
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                            }
                            
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                            }
                        })
                    }
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}
extension FavoriteVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoriteUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.favoriteCollectionItem.identifier, for: indexPath) as? FavoriteCollectionItem
        let  object = self.favoriteUser[indexPath.row]
        cell?.delegate = self
        cell?.bind(object, index: indexPath.row)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1
        let userObject = favoriteUser[indexPath.row]
        let vc = R.storyboard.main.showUserDetailsViewController()
        vc?.otherUser = .randomUser(userObject)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40)/2
        return CGSize(width: width, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension FavoriteVC: FavoriteDelegate {
    func pressedUnFavoriteBtn(_ sender: UIButton, id: Int, index: Int) {
        self.unFavorite(uid: id, index: index)
    }
    
    private func unFavorite(uid:Int, index: Int) {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                FavoriteManager.instance.deleteFavorite(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.favoriteUser.remove(at: index)
                                self.collectionView.reloadData()
                                self.view.makeToast(success?.message ?? "")
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
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
