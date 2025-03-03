//
//  ChatVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK
import SwiftEventBus

class ChatVC: BaseViewController, FBInterstitialAdDelegate {
    
    // MARK: - Views
    // @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var noMsgLabel: UILabel!
    @IBOutlet weak var noMsgImage: UIImageView!
    @IBOutlet var messagesTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var navigationView: UIView!
    //@IBOutlet weak var collectionViewOnlineUser: UICollectionView!
    
    // MARK: - Properties
    private let appNavigator: AppNavigator = .shared
    private let networkManager: NetworkManager = .shared
    private var selectedIndexPath:[IndexPath] = [] {
        didSet {
            if self.selectedIndexPath.count == 0 {
                self.isSelected = false
            }
            self.deleteView.isHidden = self.selectedIndexPath.count == 0
            self.navigationView.isHidden = self.selectedIndexPath.count != 0
        }
    }
    var isSelected = false
    var messagesList: [ChatConversationModel] = []
    var offset: Int = 0
    var interstitial: GADInterstitialAd!
    var interstitialAd1: FBInterstitialAd?
    private let flowLayout = UICollectionViewFlowLayout()
    
    private var isPageLoaded: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        isPageLoaded = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.messagesTableView.addPullToRefresh {
            self.offset = 0
            self.fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.fetchData()
        /*SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchData()
        }*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
      
    //MARK: -  Selectors -
    @IBAction func moreBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.popUps.chatPopupVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectedIndexPath.removeAll()
        self.isSelected = false
        self.messagesTableView.reloadData()
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        for (index,indexPath) in self.selectedIndexPath.enumerated() {
            let id = self.messagesList[indexPath.row].to_id
            self.deleteUserChatAPI(id: id, isLast: index == (self.selectedIndexPath.count-1))
        }
    }
    
    // TableView longPressed Click
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if !self.isSelected {
            if sender.state == .began {
                self.isSelected = true
                let objSender = sender.location(in: self.messagesTableView)
                if let indexPath = self.messagesTableView.indexPathForRow(at: objSender) {
                    print("indexpath:-------------",indexPath)
                    self.selectedIndexPath.append(indexPath)
                    self.messagesTableView.reloadData()
                }
            }
        }
    }
    
    // TableView longPressed Click
    @objc func tapGesturePressed(_ sender: UITapGestureRecognizer) {
        let objSender = sender.location(in: self.messagesTableView)
        if let indexPath = self.messagesTableView.indexPathForRow(at: objSender) {
            print("indexpath:-------------",indexPath)
            if self.isSelected {
                if self.selectedIndexPath.contains(indexPath) {
                    for (index,j) in selectedIndexPath.enumerated() {
                        if indexPath.row == j.row {
                            self.selectedIndexPath.remove(at: index)
                        }
                    }
                }else{
                    self.selectedIndexPath.append(indexPath)
                }
                self.selectedIndexPath = self.selectedIndexPath.removingDuplicates()
                self.messagesTableView.reloadData()
            }else {
                self.tableView(self.messagesTableView, didSelectRowAt: indexPath)
            }
        }
    }
    
    //MARK: -  Helper Functions -
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    private func setupUI() {
        self.noMsgImage.tintColor = .PrimaryColor
        self.chatLabel.text = NSLocalizedString("Chat", comment: "Chat")
        self.noMsgLabel.text  = NSLocalizedString("There are no messages", comment: "There are no messages")
        
        self.messagesTableView.separatorStyle = .none
        self.messagesTableView.register(UINib(resource: R.nib.chatScreenTableItem), forCellReuseIdentifier: R.reuseIdentifier.chatScreenTableItem.identifier)
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
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesturePressed(_:)))
        self.messagesTableView.addGestureRecognizer(tap2)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.messagesTableView.addGestureRecognizer(longPressRecognizer)
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
    private func fetchData() {
        if Connectivity.isConnectedToNetwork(){
            messagesList.removeAll()
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                ChatManager.instance.getConversation(AccessToken: accessToken, Limit: 20, Offset: 0, completionBlock: { (success, sessionError, error) in
                    Async.main {
                        self.messagesTableView.stopPullToRefresh()
                    }
                    if success != nil {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? [])")
                                self.messagesList = success?.data ?? []
                                self.noMsgImage.isHidden = !(self.messagesList.isEmpty)
                                self.noMsgLabel.isHidden = !(self.messagesList.isEmpty)
                                self.noMsgImage.isHidden = true
                                self.noMsgLabel.isHidden = true
                                self.messagesTableView.reloadData()
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
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
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noMsgLabel.isHidden = (messagesList.count != 0)
        noMsgImage.isHidden = (messagesList.count != 0)
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatScreenTableItem.identifier, for: indexPath) as! ChatScreenTableItem
        if messagesList.count == 0{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let object = self.messagesList[indexPath.row]
        cell.bind(object)
        cell.selectedImageView.isHidden = !(self.selectedIndexPath.contains(indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSelected {
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
            if self.messagesList.count != 0 {
                Async.main({
                    let object = self.messagesList[indexPath.row]
                    let vc = R.storyboard.chat.chatScreenVC()
                    vc?.toUserId = object.user?.id
                    vc?.usernameString = object.user?.username
                    vc?.lastSeenString =  object.user?.lastseen
                    vc?.profileImageString = object.user?.avatar
                    self.navigationController?.pushViewController(vc!, animated: true)
                })
            }
        }
    }
}

extension ChatVC: ChatsPopupDelegate {
    func btnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        for (index,i) in self.messagesList.enumerated() {
            self.deleteUserChatAPI(id: i.to_id, isLast: index == (self.messagesList.count-1))
        }
    }
    
    private func deleteUserChatAPI(id: Int, isLast: Bool) {
        selectedIndexPath.removeAll()
        self.isSelected = false
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                ChatManager.instance.deleteChatUserChat(AccessToken: accessToken, To_userId: id, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                if isLast {
                                    self.view.makeToast(success?.message ?? "")
                                    self.fetchData()
                                }
                            }
                        })
                    } else if sessionError != nil {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    } else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
