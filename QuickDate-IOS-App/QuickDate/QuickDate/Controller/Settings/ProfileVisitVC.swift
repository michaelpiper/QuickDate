//
//  ProfileVisitVC.swift
//  QuickDate
//
//  Created by iMac on 26/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import XLPagerTabStrip
import GoogleMobileAds
import FBAudienceNetwork
import SwiftEventBus
import QuickDateSDK

class ProfileVisitVC: BaseViewController, FBInterstitialAdDelegate {
    
    var itemInfo = IndicatorInfo(title: "View")
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var noFavImage: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    private let appNavigator: AppNavigator = .shared
    private let networkManager: NetworkManager = .shared
    private let appInstance: AppInstance = .shared
    
    var visitList: [UserProfileSettings] = []
    var offset: Int?
    var isProfileNavgation: Bool = false
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchListVisitUsers()
        SwiftEventBus.onMainThread(self, name: "fetch") { (notification) in
        }
        SwiftEventBus.unregister(self, name: "fetch")
        
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
    
    //MARK: - Actions -
    @IBAction func backButtonAction(_ sender: UIButton) {
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
    
    private func fetchListVisitUsers() {
        guard appInstance.isConnectedToNetwork(in: self.view) else { return }
        let accessToken = appInstance.accessToken ?? ""
        var params: APIParameters = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.limit: "30",
        ]
        if let offset = offset {
            params[API.PARAMS.offset] = "\(offset)"
        }
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.LIST_VISITS_API,
                method: .post, parameters: params,
                successCode: .code) { [weak self] response in
                    Async.main {
                        self?.handleActivityIndicator(activity: .stop)
                    }
                    switch response {
                    case .failure(let error):
                        Async.main({
                            self?.view.makeToast(error.localizedDescription)
                            self?.handleEmptyView(with: [])
                            self?.handleActivityIndicator(activity: .stop)
                        })
                    case .success(let dict):
                        Async.main({
                            guard let data = dict["data"] as? [JSON] else {
                                Logger.error("getting random users data"); return
                            }
                            let list = data.map({UserProfileSettings(dict: $0)})
                            self?.offset = Int(list.last?.id ?? "")
                            //                            self?.appendNotification(with: list, at: first)
                            self?.visitList = list
                            self?.handleEmptyView(with: list)
                            self?.collectionView.reloadData()
                        })
                    }
                }
        })
    }
    
    // MARK: - Helpers
    
    private func handleEmptyView(with list: [UserProfileSettings]) {
        self.emptyView.isHidden = !list.isEmpty
    }
    
    private func handleActivityIndicator(activity: Process) {
        let isStart = activity == .start
        activityIndicator.isHidden = !isStart
        switch activity {
        case .start: activityIndicator.startAnimating()
        case .stop:  activityIndicator.stopAnimating()
        }
    }
    
    private func setupUI() {
        collectionView.register(UINib(resource: R.nib.listVisitCollectionItem), forCellWithReuseIdentifier: R.reuseIdentifier.listVisitCollectionItem.identifier)
        if ControlSettings.shouldShowAddMobBanner {
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
}

extension ProfileVisitVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visitList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.listVisitCollectionItem.identifier, for: indexPath) as! ListVisitCollectionItem
        let object = self.visitList[indexPath.row]
        cell.bind(object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width)/2
        return CGSize(width: width, height: 170)
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

        let vc = R.storyboard.main.showUserDetailsViewController()
        let userObject = self.visitList[indexPath.row]
        vc?.otherUser = .randomUser(userObject)
        vc?.fromProf = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
