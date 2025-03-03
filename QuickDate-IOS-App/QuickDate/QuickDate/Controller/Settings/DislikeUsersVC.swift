//
//  DislikeUsersVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class  DislikeUsersVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var peopleIDislikeLabel: UILabel!
    var dislikeUsers: [UserProfileSettings] = []
    var mediaFiles = [String]()
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchDislikeUsers()
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
        self.emptyView.tintColor = UIColor().hexStringToUIColor(hex: "FF007F")
        self.peopleIDislikeLabel.text = NSLocalizedString("People i Disliked", comment: "People i Disliked")
        self.noFavLabel.text = NSLocalizedString("There is no Disliked User", comment: "There is no Disliked User")
        collectionView.register(UINib(resource: R.nib.peopleIDislikeCollectionItem), forCellWithReuseIdentifier: R.reuseIdentifier.peopleIDislikeCollectionItem.identifier)
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
    
    //MARK: - Methods
    private func fetchDislikeUsers() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                LikeDislikeMananger.instance.getDislikePeople(AccessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                    Async.main {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                    if success != nil {
                        Async.main({
                            self.dismissProgressDialog {
                                self.dislikeUsers = success?.data ?? []
                                if self.dislikeUsers.isEmpty {
                                    self.emptyView.isHidden = false
                                    self.noFavLabel.isHidden = false
                                }else{
                                    self.emptyView.isHidden = true
                                    self.noFavLabel.isHidden = true
                                    self.collectionView.reloadData()
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
        }
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension DislikeUsersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dislikeUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.peopleIDislikeCollectionItem.identifier, for: indexPath) as! PeopleIDislikeCollectionItem
        let object = self.dislikeUsers[indexPath.row]
        cell.delegate = self
        cell.bind(object, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40)/2
        return CGSize(width: width, height: 200)
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
                if let _ = interstitial {
                    interstitialAd1 = FBInterstitialAd(placementID: ControlSettings.addsOfFacebookPlacementID)
                    interstitialAd1?.delegate = self
                    interstitialAd1?.load()
                } else {
                    print("Ad wasn't ready")
                }
            }else if ControlSettings.googleAds{
                if let _ = interstitial {
                    interstitial.present(fromRootViewController: self)
                    interstitial = CreateAd()
                    AppInstance.shared.addCount = 0
                }
            }
        }
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1
        let userObject = dislikeUsers[indexPath.row]
        let vc = R.storyboard.main.showUserDetailsViewController()
        vc?.otherUser = .randomUser(userObject)
        vc?.fromProf = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension DislikeUsersVC: PeopleDisLikeDelegate {
    func pressedDisLikedBtn(_ sender: UIButton, id: Int, index: Int) {
        self.deleteLikeUser(id: id, index: index)
    }
        
    private func deleteLikeUser(id: Int, index: Int) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                LikeDislikeMananger.instance.deleteDislike(AccessToken: accessToken, id: id) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.dislikeUsers.remove(at: index)
                                self.collectionView.reloadData()
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
