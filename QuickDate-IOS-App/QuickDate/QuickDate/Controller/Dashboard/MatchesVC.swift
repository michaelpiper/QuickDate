//
//  MatchesVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import JGProgressHUD
import XLPagerTabStrip
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class MatchesVC: UIViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noNotificationDetaillabel: UILabel!
    @IBOutlet weak var noNotificationLabel: UILabel!
    @IBOutlet weak var noLabel: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private let appNavigator: AppNavigator = .shared
    private let appInstance: AppInstance = .shared
    private let networkManager: NetworkManager = .shared
    
    var hud : JGProgressHUD?
    var matchesList: [AppNotification] = []
    
    var offset: Int?
    
    var listMatches: [[String:Any]] = []
    var interstitial: GADInterstitialAd!
    var mediaFiles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        fetchAndAppendNotification(atFirst: true)
        
        self.tableView.addPullToRefresh {
            self.fetchAndAppendNotification(atFirst: true)
        }
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
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
                    Async.main {
                        self?.tableView.stopPullToRefresh()
                    }
                    switch response {
                    case .failure(let error):
                        Async.main({
                            self?.dismissProgressDialog {
                                self?.view.makeToast(error.localizedDescription)
                                self?.handleEmptyView(with: [])
                                self?.handleActivityIndicator(activity: .stop)
                            }
                        })
                    case .success(let dict):
                        Async.main({
                            self?.dismissProgressDialog {
                                guard let data = dict["data"] as? [JSON] else {
                                    Logger.error("getting random users data"); return
                                }
                                let notificationList = data.map { AppNotification(dict: $0) }
                                self?.offset = notificationList.last?.id
                                var list: [AppNotification] = []
                                notificationList.forEach { notification in
                                    if notification.type == .gotNewMatch {
                                        list.append(notification)
                                    }
                                }
                                self?.appendNotification(with: list, at: first)
                            }
                        })
                    }
                }
        })
    }
    
    private func appendNotification(with userList: [AppNotification], at atFirst: Bool) {
        switch atFirst {
        case true:
            offset = userList.last?.id
            matchesList = userList
            handleEmptyView(with: userList)
            handleActivityIndicator(activity: .stop)
            tableView.reloadData()
        case false:
            let firstIndex = matchesList.count
            let newList = userList.compactMap { (user) -> AppNotification? in
                let isSameUser =  matchesList.lazy.filter { $0.notifierID == user.notifierID }.first
                return isSameUser == .none ? user : nil
            }
            
            let lastIndex = newList.count + firstIndex - 1
            guard lastIndex >= firstIndex else { return } // Safety check
            let indexPathList = Array(firstIndex...lastIndex).map { IndexPath(row: $0, section: 0) }
            offset = newList.last?.id
            matchesList.append(contentsOf: newList)
            tableView.insertRows(at: indexPathList, with: .automatic)
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
        })
        return  self.interstitial
        
    }
    
}

extension MatchesVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("Matches", comment: "Matches"))
    }
}

// MARK: - Datasource and Delegate

extension MatchesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as notificationTableCell
        cell.selectionStyle = .none
        cell.notification = matchesList[indexPath.row]
        cell.notifyTypeIcon.image = UIImage(named: "ic_matches_notification")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
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
        
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1
        let user = matchesList[indexPath.row].notifierUser
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

// MARK: - Helper

extension MatchesVC {
    
    private func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
    }
    
    private func handleActivityIndicator(activity: Process) {
        let isStart = activity == .start
        activityIndicator.isHidden = !isStart
        switch activity {
        case .start: activityIndicator.startAnimating()
        case .stop:  activityIndicator.stopAnimating()
        }
    }
    
    private func handleEmptyView(with list: [AppNotification]) {
        self.noLabel.isHidden = !list.isEmpty
    }
    
    private func setupUI() {
        handleActivityIndicator(activity: .start)
        self.noNotificationLabel.text = NSLocalizedString("No Notifications Yet", comment: "No Notifications Yet")
        self.noNotificationDetaillabel.text  = NSLocalizedString("We will display once you get your first activity here ", comment: "We will display once you get your first activity here ")
        tableView.separatorStyle = .none
        tableView.register(cellType: notificationTableCell.self)
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
                })
            }
        }
    }
}
