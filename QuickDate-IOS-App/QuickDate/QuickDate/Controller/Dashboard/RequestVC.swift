//
//  RequestVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import XLPagerTabStrip
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class RequestVC: BaseViewController, FBInterstitialAdDelegate {
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var noLabel: UIStackView!
    @IBOutlet weak var noNotificationDetaillabel: UILabel!
    @IBOutlet weak var noNotificationLabel: UILabel!
    
    private let appNavigator: AppNavigator = .shared
    private let networkManager: NetworkManager = .shared
    private let appInstance: AppInstance = .shared
    
    var offset: Int?
    var requestList: [AppNotification] = []
    
    var itemInfo = IndicatorInfo(title: "View")
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAndAppendNotification(atFirst: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // MARK: - Services
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    private func fetchAndAppendNotification(atFirst first: Bool) {
        
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
                urlString: API.COMMON_CONSTANT_METHODS.GET_NOTIFICATIONS_API,
                method: .post, parameters: params,
                successCode: .code) { [weak self] response in
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
                            let notificationList = data.map { AppNotification(dict: $0) }
                            self?.offset = notificationList.last?.id
                            var list: [AppNotification] = []
                            notificationList.forEach { notification in
                                if notification.type == .friendRequest || notification.type == .friendAccept  {
                                    list.append(notification)
                                }
                            }
                            self?.appendNotification(with: list, at: first)
                        })
                    }
                }
        })
        
    }
    
    private func appendNotification(with userList: [AppNotification], at atFirst: Bool) {
        switch atFirst {
        case true:
            offset = userList.last?.id
            requestList = userList
            handleEmptyView(with: userList)
            tableVIew.reloadData()
            handleActivityIndicator(activity: .stop)
        case false:
            let firstIndex = requestList.count
            let newList = userList.compactMap { (user) -> AppNotification? in
                let isSameUser =  requestList.filter { $0.notifierID == user.notifierID }.first
                return isSameUser == .none ? user : nil
            }
            let lastIndex = newList.count + firstIndex - 1
            guard lastIndex >= firstIndex else { return } // Safety check
            let indexPathList = Array(firstIndex...lastIndex).map { IndexPath(row: $0, section: 0) }
            offset = newList.last?.id
            requestList.append(contentsOf: newList)
            tableVIew.insertRows(at: indexPathList, with: .automatic)
        }
    }
    
    // MARK: - Helpers
    private func handleEmptyView(with list: [AppNotification]) {
        self.noLabel.isHidden = !list.isEmpty
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
        handleActivityIndicator(activity: .start)
        self.noNotificationLabel.text = NSLocalizedString("No Notifications Yet", comment: "No Notifications Yet")
        self.noNotificationDetaillabel.text  = NSLocalizedString("We will display once you get your first activity here ", comment: "We will display once you get your first activity here ")
        
        tableVIew.separatorStyle = .none
        tableVIew.register(cellType: notificationTableCell.self)
        tableVIew.register(cellType: FriendRequestTableItem.self)
        
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
}

extension RequestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.requestList[indexPath.row]
        if object.type == .friendRequest {
            let cell = tableView.dequeueReusableCell(for: indexPath) as FriendRequestTableItem
            cell.selectionStyle = .none
            cell.indexPath = indexPath.row
            cell.notification = requestList[indexPath.row]
            cell.notifyTypeIcon.image = UIImage(named: "ic_requests_notification")
            cell.vc = self
            cell.baseVC = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as notificationTableCell
            cell.selectionStyle = .none
            cell.notification = requestList[indexPath.row]
            cell.notifyTypeIcon.image = UIImage(named: "ic_requests_notification")
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        let user = requestList[indexPath.row].notifierUser
        appNavigator.dashboardNavigate(to: .userDetail(user: .notifier(user), delegate: .none))
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            fetchAndAppendNotification(atFirst: false)
        }
    }
    
}
extension RequestVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("Request", comment: "Request"))
    }
}
