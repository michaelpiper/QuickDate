//
//  LiveUserVC.swift
//  QuickDate
//
//  Created by iMac on 25/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class LiveUserVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(resource: R.nib.liverUserCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.liverUserCollectionViewCell.identifier)
        }
    }
    @IBOutlet weak var emptyStackView: UIStackView!
    
    var liveUserList: [LiveUserModel] = []
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    
    //MARK: - Life Cycle Function -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLiveUser(isPull: false)
        self.collectionView.addPullToRefresh {
            self.emptyStackView.isHidden = true
            self.getLiveUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK: - Selectors -
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLiveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let newViewController = R.storyboard.live.goLiveStreamVC() else {return}
//        newViewController.channelName = "test"
        newViewController.userRole = .broadcaster
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true)      
    }
    
    func getLiveUser(isPull: Bool = true) {
        if !isPull {
            self.showProgressDialog(with: "Loading...")//1035294283
        }
        if Connectivity.isConnectedToNetwork() {
            let param: APIParameters =  [
                "access_token": accessToken,
                "limit": "20"
            ]
            LiveUserManager.instance.fetchLiveUserAPI(params: param) { success, sessionError, error in
                self.dismissProgressDialog { [weak self] in
                    Async.main {
                        self?.collectionView.stopPullToRefresh()
                    }
                    if let error = error {
                        self?.view.makeToast(error.localizedDescription)
                        return
                    }
                    
                    if let sessionError = sessionError {
                        self?.view.makeToast(sessionError["message"] as? String)
                        return
                    }
                    
                    if let success = success {
                        print(success)
                        self?.liveUserList = success
                        self?.emptyStackView.isHidden = success.count != 0
                        self?.collectionView.reloadData()
                    }
                }
            }
        }else {
            self.view.makeToast(InterNetError)
        }
    }
}

extension LiveUserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.liverUserCollectionViewCell.identifier, for: indexPath) as! LiverUserCollectionViewCell
        let object = self.liveUserList[indexPath.row]
        cell.bind(object)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width-30)/2
        return CGSize(width: width, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*if AppInstance.shared.addCount == ControlSettings.interestialCount {
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
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1*/
        let userObject = liveUserList[indexPath.row]
//        let controller = LiveStreamViewController.instantiate(fromStoryboardNamed: .live)
//        controller.userRole = .audience
//        controller.channelName = userObject.stream_name
//        controller.postId = userObject.id
//        controller.modalPresentationStyle = .fullScreen
//        self.present(controller, animated: true)
        
        guard let newViewController = R.storyboard.live.goLiveStreamVC() else {return}
        newViewController.channelName = userObject.stream_name
        newViewController.userRole = .audience
        newViewController.postId = userObject.id
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true)
        
//        let vc = R.storyboard.main.showUserDetailsViewController()
//        vc?.otherUser = .randomUser(userObject)
//        vc?.fromProf = true
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
