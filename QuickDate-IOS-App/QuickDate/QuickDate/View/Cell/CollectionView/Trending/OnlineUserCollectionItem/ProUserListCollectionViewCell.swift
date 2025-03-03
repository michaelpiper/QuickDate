//
//  ProUserListCollectionViewCell.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 31.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds
import GoogleUtilities

class ProUserListCollectionViewCell: UICollectionViewCell, FBInterstitialAdDelegate {
    
    // MARK: - Views
    var interstitialAd1: FBInterstitialAd?
    var interstitial: GADInterstitialAd!
    
    private let flowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: AddStoryCollectionCell.self)
            collectionView.register(cellType: OnlineUserCollectionItem.self)
            collectionView.collectionViewLayout = flowLayout
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let isProUser =  AppInstance.shared.userProfileSettings?.is_pro ?? false
    private let appNavigator: AppNavigator = .shared
    
    var userList: [UserProfileSettings]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var controller: TrendingVC?
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Services
    
//    func bind(object:[[String:Any]]){
//        self.object = object
//        self.collectionView.reloadData()
//
//    }
    
    private func createAd() -> GADInterstitialAd {
        
        GADInterstitialAd.load(withAdUnitID: ControlSettings.googleInterstitialAdsUnitId,
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

// MARK: - DataSource

extension ProUserListCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isProUser =  appInstance.userProfileSettings?.is_pro ?? false
        let userListCount = userList?.count ?? 0
        return isProUser ? userListCount : userListCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isProUser && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as AddStoryCollectionCell
            let urlString = appInstance.userProfileSettings?.avatar ?? ""
            let url = URL(string: urlString)
            cell.imageURL = url
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as OnlineUserCollectionItem
        let object = isProUser ? userList?[indexPath.row] : userList?[indexPath.row - 1]
        cell.user = object
        return cell
    }
}

// MARK: - Delegate
extension ProUserListCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if AppInstance.shared.addCount == ControlSettings.interestialCount {
            // TODO: handle to show ads
//            if ControlSettings.facebookAds {
//                if let ad = interstitial {
//                    interstitialAd1 = FBInterstitialAd(placementID: ControlSettings.fbplacementID)
//                    interstitialAd1?.delegate = self
//                    interstitialAd1?.load()
//                } else {
//                    print("Ad wasn't ready")
//                }
//            } else if ControlSettings.googleAds {
//                guard let controller = controller else {
//                    Logger.error("getting controller"); return
//                }
//
//                interstitial.present(fromRootViewController: controller)
//                interstitial = createAd()
//                AppInstance.shared.addCount = 0
//            }
        }
        
        appInstance.addCount = appInstance.addCount + 1
        
        if !isProUser && indexPath.row == 0 {
            self.appNavigator.creditNavigate(to: .upgradeAccount(self))
            
        } else {
            let index: Int = isProUser ? indexPath.row : indexPath.row - 1
            
            guard let randomUser = userList?[index] else {
                Logger.error("getting random user"); return
            }
            
            appNavigator.dashboardNavigate(to: .userDetail(
                user: .randomUser(randomUser), delegate: .none))
        }
    }
}

// MARK: - FlowLayout

extension ProUserListCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 100.0)
    }
}

// MARK: - Helpers
extension ProUserListCollectionViewCell {
    
    private func setupUI() {
        if ControlSettings.shouldShowAddMobBanner && ControlSettings.googleAds {
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                                   request: request,
                                   completionHandler: { (ad, error) in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = ad
            })
            
        }
    }
}

extension ProUserListCollectionViewCell: NibReusable {}
