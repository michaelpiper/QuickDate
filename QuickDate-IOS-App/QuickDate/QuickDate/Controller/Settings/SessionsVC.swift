//
//  SessionsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

import Async
import SwiftEventBus
import GoogleMobileAds
import FBAudienceNetwork

class SessionsVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sessionLabel: UILabel!
    private  var refreshControl = UIRefreshControl()
    var sessionArray = [SessionData]()
    var interstitial: GADInterstitialAd!
    private var fetchSatus:Bool? = true
    var selectedIndexpath: IndexPath = []
    var selectedSession: SessionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    func setupUI(){
        self.sessionLabel.text = NSLocalizedString("Session", comment: "Session")
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.title = "Manage Sessions"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register(UINib(resource:R.nib.sessionTableItem), forCellReuseIdentifier: R.reuseIdentifier.sessionTableItem.identifier)
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func refresh(sender:AnyObject) {
        fetchSatus = true
        self.sessionArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
    private func fetchData(){
        if fetchSatus!{
            fetchSatus = false
            self.showProgressDialog(with: "Loading...")
        }else{
            Logger.verbose("will not show Hud more...")
        }
        
        self.sessionArray.removeAll()
        self.tableView.reloadData()
        let accessToken = AppInstance.shared.accessToken ?? ""
        Async.background({
            SessionManager.instance.getSession(AccessToken: accessToken) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if (success?.data?.count == 0) {
                                self.refreshControl.endRefreshing()
                            }else {
                                self.sessionArray = success?.data ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
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
        
    }
    
}
extension SessionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


extension SessionsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.sessionTableItem.identifier) as! SessionTableItem
        cell.delegate = self
        let object = self.sessionArray[indexPath.row]
        cell.bind(object, index: indexPath)
        return cell
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
    }
   
}

extension SessionsVC: SessionDelegate, WarningPopupDelegate {
    func removedBtnPressed(_ sender: UIButton, indexPath: IndexPath) {
        self.view.endEditing(true)
        self.selectedIndexpath = indexPath        
        let vc = R.storyboard.popUps.warningPopUpVC()
        vc?.descriptionSTR = "Do you want to log out from this device?".localized
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func yesBtnPressed(_ sender: UIButton, type: String) {
        self.deleteSession(indexPath: self.selectedIndexpath)
    }
    
    func noBtnPressed(_ sender: UIButton) {
        
    }
    
    private func deleteSession(indexPath: IndexPath) {
        let id = self.sessionArray[indexPath.row].id
        let accessToken = AppInstance.shared.accessToken ?? ""
        Async.background({
            SessionManager.instance.deleteSession(AccessToken: accessToken, id: id ?? 0) { (success, sessionError, error) in
                if success != nil {
                    Async.main({
                        self.sessionArray.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.view.makeToast(sessionError?.message ?? "")
                        Logger.error("sessionError = \(sessionError?.message ?? "")")
                    })
                }else {
                    Async.main({
                        self.view.makeToast(error?.localizedDescription ?? "")
                        Logger.error("error = \(error?.localizedDescription ?? "")")
                    })
                }
            }
        })
    }
}
