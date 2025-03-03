//
//  HotOrNotListCollectionViewCell.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 31.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds

class HotOrNotListCollectionViewCell: UICollectionViewCell, FBInterstitialAdDelegate {
    
    // MARK: - Views
    
    var interstitialAd1: FBInterstitialAd?
    var interstitial: GADInterstitialAd?
    var viewController: TrendingVC?
    
    private let flowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: HotOrNotCollectionItem.self)
            collectionView.collectionViewLayout = flowLayout
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    // MARK: - Properties
    
    var userList: [UserProfileSettings]? {
        didSet {
            if userList?.count != 0 {
                self.collectionView.reloadData()
            }
        }
    }
    
    var controller: TrendingVC?
    
    private let appInstance: AppInstance = .shared
    private let appNavigator: AppNavigator = .shared
    
    private var displayingIndex = 0
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.reloadData()
    }
    
    // MARK: - Services
    
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")

            if interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: controller)
            }
    }
    
    private func setupUI() {
        if ControlSettings.shouldShowAddMobBanner {
            if ControlSettings.googleAds {
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID: ControlSettings.googleInterstitialAdsUnitId,
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
    private func CreateAd() -> GADInterstitialAd {
        
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
        return  self.interstitial ?? GADInterstitialAd()
        
    }
}

// MARK: - DataSource

extension HotOrNotListCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HotOrNotCollectionItem
        cell.delegate = self
        cell.viewController = viewController
        cell.user = userList?[indexPath.row]
        cell.indexPath = indexPath
        return cell
    }
}

// MARK: - Delegate
extension HotOrNotListCollectionViewCell: UICollectionViewDelegate {
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
            } else if ControlSettings.googleAds {
                guard let controller = controller else {
                    Logger.error("getting controller"); return
                }
                interstitial?.present(fromRootViewController: controller)
                interstitial = CreateAd()
                AppInstance.shared.addCount = 0
            }
        }
        appInstance.addCount = appInstance.addCount + 1
        
        guard let user = userList?[indexPath.row] else {
            Logger.error("getting user"); return
        }
        appNavigator.dashboardNavigate(to: .userDetail(user: .randomUser(user), delegate: .none))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        displayingIndex = indexPath.row
    }
}

// MARK: - FlowLayout

extension HotOrNotListCollectionViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
}

// MARK: - HotOrNotCollectionItemDelegate

extension HotOrNotListCollectionViewCell: HotOrNotCollectionItemDelegate {
    func deleteCell(at indexPath: IndexPath) {
        //collectionView.deleteItems(at: [indexPath])
        userList?.remove(at: indexPath.row)
    }
}

extension HotOrNotListCollectionViewCell: NibReusable {}
