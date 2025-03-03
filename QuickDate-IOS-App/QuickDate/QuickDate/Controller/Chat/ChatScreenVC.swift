//
//  ChatScreenVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import DropDown
import FittedSheets
import IQKeyboardManagerSwift
import SwiftEventBus
import QuickDateSDK
import Alamofire
import Braintree
import Razorpay

class ChatScreenVC: BaseViewController {
    
    @IBOutlet weak var copyView: UIView!
    @IBOutlet weak var lblCopyCount: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var receiverNameLabel: UILabel!
    @IBOutlet var lastSeenLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var giftButton: UIButton!
    @IBOutlet var stickerButton: UIButton!
    @IBOutlet var imageView: UIView!
    @IBOutlet var giftView: UIView!
    @IBOutlet var stickerView: UIView!
    @IBOutlet var messageTextfield: EmojiTextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var bottomContant: NSLayoutConstraint!
    
    // MARK: - Properties
    private let networkManager: NetworkManager = .shared
    private let userSettings = AppInstance.shared.userProfileSettings
    private let appNavigator: AppNavigator = .shared
    
    var chatList: [ChatModel] = []
    var toUserId:String? = ""
    var usernameString:String? = ""
    var lastSeenString:String? = ""
    var lastSeen:String? = ""
    var profileImageString:String? = ""
    private var messageCount:Int? = 0
    private var scrollStatus:Bool? = true
    private let imagePickerController = UIImagePickerController()
    private var selectedIndexPath:[IndexPath] = [] {
        didSet {
            if self.selectedIndexPath.count == 0 {
                self.isSelected = false
            }
            self.copyView.isHidden = self.selectedIndexPath.count == 0
            self.navigationView.isHidden = self.selectedIndexPath.count != 0
            self.lblCopyCount.text = "\(self.selectedIndexPath.count)"
        }
    }
    private var userProfile: UserProfileSettings?
    var isSelected = false
    var a = 0
    
    var selectedAmount = 0
    var selectedCredit = 0
    var selectedMemberShip = 1
    var selectedPaymentType = ""
    var razorpayObj: RazorpayCheckout? = nil
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    var RAZOR_KEY_ID = "rzp_test_ruzI7R7AkonOIi"
    var selectedPaymentMethod: PaymentName = .flutterWave
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.topNavigationView.addShadow(offset: .init(width: 0, height: 2), color: .gray, radius: 2.0, opacity: 0.5)
        self.viewChat.addShadow()
        Logger.verbose("To USerId = \(self.toUserId ?? "")")
        IQKeyboardManager.shared.enable = false
        RAZOR_KEY_ID = AppInstance.shared.adminAllSettings?.data?.razorpayKeyId ?? "rzp_test_ruzI7R7AkonOIi"
        razorpayObj = RazorpayCheckout.initWithKey(RAZOR_KEY_ID, andDelegate: self)
        razorpayObj?.setExternalWalletSelectionDelegate(self)
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide(_:)))
        
        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide(_:)))
        
        //We make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        SwiftEventBus.unregister(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        hideNavigation(hide: true)
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchData()
        }
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            Logger.verbose("Internet dis connected!")
        }
        hideTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserProfile()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Actions -
    @objc func dismissMyKeyboard() {
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
    
    @objc func textFieldClick(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        isEmoji = false
        self.messageTextfield.becomeFirstResponder()
    }
    
    @objc func keyboardWillShowOrHide(_ notification: NSNotification) {
        // Get required info out of the notification
        if let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            if notification.name == UIResponder.keyboardWillShowNotification {
                animatedKeyBoard(scrollToBottom: true)
                self.bottomContant.constant = endRect.size.height + 10
            }else {
                self.bottomContant.constant = 24
            }
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
                self.view.updateConstraints()
            }, completion: nil)
        }
    }
    
    @IBAction func copyBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        var array = ""
        for (index,j) in selectedIndexPath.enumerated() {
            let msg = chatList[j.row]
            if array == "" {
                array = msg.text + "\n"
            }else {
                array+=msg.text
                if index != selectedIndexPath.count - 1 {
                    array+="\n"
                }
            }
        }
        self.view.makeToast("Copied Messages Successfully!....")
        print("Copied Array: ----", array)
    }
    
    @IBAction func callPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.call.callVC()
        vc?.toUSerId = self.toUserId ?? ""
        vc?.username = self.usernameString ?? ""
        vc?.callingType = "voiceCall"
        vc?.delegate = self
        vc?.profileImageString = self.profileImageString ?? ""
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func goToUserProfile(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let userProfile = userProfile else {
            Logger.error("getting userProfile"); return
        }
        appNavigator.dashboardNavigate(to: .userDetail(user: .userProfile(userProfile), delegate: .none))
    }
    
    @IBAction func videoPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.call.callVC()
        vc?.toUSerId = self.toUserId ?? ""
        vc?.username = self.usernameString ?? ""
        vc?.callingType = "videoCall"
        vc?.profileImageString = self.profileImageString ?? ""
        vc?.delegate = self
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    // TableView longPressed Click
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.isSelected = true
            let objSender = sender.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: objSender) {
                print("indexpath:-------------",indexPath)
                self.selectedIndexPath.append(indexPath)
                self.tableView.reloadData()
            }
        }
    }
    
    // TableView longPressed Click
    @objc func tapGesturePressed(_ sender: UITapGestureRecognizer) {
        if self.isSelected {
            let objSender = sender.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: objSender) {
                print("indexpath:-------------",indexPath)
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
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.popUps.userMoreOptionPopupVC()
        vc?.index = 1001
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.messageTextfield.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.makeToast("Please write somthing....")
            return
        }
        self.sendMessage()
        self.messageTextfield.text = ""
        self.imageView.isHidden = false
        self.giftView.isHidden = false
    }
    
    @IBAction func imageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sendMedia()
    }
    
    @IBAction func stickerButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isEmoji = true
        self.messageTextfield.becomeFirstResponder()
        /*let vc = R.storyboard.chat.stickersViewController()
         let controller = SheetViewController(controller:vc!)
         controller.hasBlurBackground = true
         vc?.stickerDelegate = self
         vc?.checkStatus = false
         self.present(controller, animated: false, completion: nil)*/
    }
    
    @IBAction func giftButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let viewController = R.storyboard.chat.stickersViewController() {
            viewController.giftDelegate = self
            viewController.stickerDelegate = self
            viewController.delegate = self
            //            viewController.checkStatus = true
            let panVC: PanModalPresentable.LayoutType = viewController
            presentPanModal(panVC)
        }
    }
    
    @IBAction func emoButtonAction(_ sender: UIButton) {
        
    }
}

//MARK: - Helper Functions -
extension ChatScreenVC {
    private func setupUI() {
        self.copyView.isHidden = self.selectedIndexPath.count == 0
        self.navigationView.isHidden = self.selectedIndexPath.count != 0
        self.lblCopyCount.text = "\(self.selectedIndexPath.count)"
        self.messageTextfield.placeholder = NSLocalizedString("Write your message", comment: "Write your message")
        self.receiverNameLabel.text = self.usernameString ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(self.lastSeenString ?? "") ?? 0)
        self.lastSeenLabel.text = "Last seen " + Date().timeAgo(from: date)
        self.messageTextfield.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.sendBtn.circleView()
        self.viewChat.circleView()
        self.tableView.register(UINib(resource: R.nib.chatStickerSenderCell), forCellReuseIdentifier: R.reuseIdentifier.chatStickerSenderCell.identifier)
        self.tableView.register(UINib(resource: R.nib.chatStickerReceiverCell), forCellReuseIdentifier: R.reuseIdentifier.chatStickerReceiverCell.identifier)
        self.tableView.register(UINib(resource: R.nib.chatSenderTableItem), forCellReuseIdentifier: R.reuseIdentifier.chatSenderTableItem.identifier)
        self.tableView.register(UINib(resource: R.nib.chatReceiverTableItem), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverTableItem.identifier)
        self.tableView.register(UINib(resource: R.nib.senderImageTableItem), forCellReuseIdentifier: R.reuseIdentifier.senderImageTableItem.identifier)
        self.tableView.register(UINib(resource: R.nib.receiverImageTableItem), forCellReuseIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier)
        imageViewProfile.circleView()
        let url = URL(string: profileImageString ?? "")
        self.imageViewProfile.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        
        self.videoBtn.isHidden = true
        self.audioBtn.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textFieldClick(_:)))
        self.messageTextfield.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesturePressed(_:)))
        self.tableView.addGestureRecognizer(tap2)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    fileprivate func animatedKeyBoard(scrollToBottom: Bool) {
        UIView.animate(withDuration: 0, delay: 0,options: UIView.AnimationOptions.curveEaseOut) {
            if scrollToBottom {
                self.view.layoutIfNeeded()
            }
        } completion: { (completed) in
            if scrollToBottom {
                if !self.chatList.isEmpty {
                    let indexPath = IndexPath(item: self.chatList.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    private func fetchUserProfile() {
        let accessToken = AppInstance.shared.accessToken ?? ""
        guard let toUserId = toUserId else {
            Logger.error("getting toUserId"); return
        }
        
        let params: APIParameters = [
            API.PARAMS.user_id: "\(toUserId)",
            API.PARAMS.access_token: accessToken,
            API.PARAMS.fetch: "data,media"
        ]
        
        Async.background {
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.PROFILE_API,
                method: .post,
                parameters: params,
                successCode: .code) { [weak self] response in
                    switch response {
                    case .failure(let error): Logger.error(error)
                        
                    case .success(let json):
                        Async.main {
                            guard let data = json["data"] as? JSON else {
                                Logger.error("getting data"); return
                            }
                            let userProfile = UserProfileSettings(dict: data)
                            self?.userProfile = userProfile
                            let current_is_pro = AppInstance.shared.userProfileSettings?.is_pro ?? false
                            let isPro = userProfile.is_pro
                            if /*isPro &&*/ current_is_pro  {
                                self?.videoBtn.isHidden = false
                                self?.audioBtn.isHidden = false
                            } else {
                                self?.videoBtn.isHidden = true
                                self?.audioBtn.isHidden = true
                            }
                        }
                    }
                }
        }
    }
    
    private func fetchData() {
        if Connectivity.isConnectedToNetwork() {
//            chatList.removeAll()
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            Async.background {
                ChatManager.instance.getChatConversation(AccessToken: accessToken, To_userId: toID, Limit: 100, Offset: 0 ) { (success, sessionError, error) in
                    if success != nil{
                        Async.main {
                            self.dismissProgressDialog {
                                self.chatList = success?.data ?? []
                                self.tableView.reloadData()
                                if self.scrollStatus! {
                                    if self.chatList.count == 0 {
                                        Logger.verbose("Will not scroll more")
                                    }else{
                                        self.scrollStatus = false
                                        self.messageCount = self.chatList.count
                                        let indexPath = NSIndexPath(item: ((self.chatList.count) - 1), section: 0)
                                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                    }
                                }else{
                                    if self.chatList.count > self.messageCount!{
                                        self.messageCount = self.chatList.count
                                        let indexPath = NSIndexPath(item: ((self.chatList.count) - 1), section: 0)
                                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                    }else{
                                        Logger.verbose("Will not scroll more")
                                    }
                                    Logger.verbose("Will not scroll more")
                                }
                            }
                        }
                    }else if sessionError != nil{
                        Async.main {
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message  ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        }
                    }else {
                        Async.main {
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    }
                }
            }
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    private func sendMedia() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.delegate = self
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else {
                self.view.makeToast("Camera not Supported!.....")
            }
        }
        let gallery = UIAlertAction(title:NSLocalizedString("Gallery", comment: "Gallery") , style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func sendMessage() {
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageTextfield.text ?? ""
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background {
            ChatManager.instance.sendMessage(AccessToken: accessToken, To_userId: toID, Message: messageText, Hash_Id: messageHashId ) { (success, sessionError, error) in
                if success != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            
                            Logger.debug("userList = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
                            
                        }
                    }
                }else if sessionError != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
                        }
                    }
                }else {
                    Async.main {
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
        }
    }
    
    private func clearChat(){
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            Async.background {
                ChatManager.instance.deleteChatUserChat(AccessToken: accessToken, To_userId: toID ) { (success, sessionError, error) in
                    if success != nil{
                        Async.main {
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else if sessionError != nil{
                        Async.main {
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        }
                    }else {
                        Async.main {
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    }
                }
            }
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    private func blockUser(){
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            Async.background {
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID ) { (success, sessionError, error) in
                    if success != nil{
                        Async.main {
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else if sessionError != nil{
                        Async.main {
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        }
                    }else {
                        Async.main {
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    }
                }
            }
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "h:mm a"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "\(dateString)"
    }
}

// MARK: - TableView

extension ChatScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.chatList.isEmpty {
            return UITableView.automaticDimension
        }else{
            let object = self.chatList[indexPath.row]
            let messageType = object.message_type
            switch messageType {
            case "media":
                return 200
            case "sticker":
                return 150
            default:
                return UITableView.automaticDimension
            }
            //            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = chatList[indexPath.row]
        let messageType = object.message_type
        let from = object.from
        if messageType == "text" {
            if from == AppInstance.shared.userId {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverTableItem.identifier) as? ChatReceiverTableItem
                cell?.selectionStyle = .none
                cell?.bind(object)
                cell?.backgroundColor = (self.selectedIndexPath.contains(indexPath) ? .systemBlue.withAlphaComponent(0.25) : .clear)
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderTableItem.identifier) as? ChatSenderTableItem
                cell?.selectionStyle = .none
                cell?.bind(object)
                cell?.backgroundColor = (self.selectedIndexPath.contains(indexPath) ? .systemBlue.withAlphaComponent(0.25) : .clear)
                return cell!
            }
        } else {
            if from == AppInstance.shared.userId {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier) as? ReceiverImageTableItem
                cell?.delegate = self
                cell?.showBtn.tag = indexPath.row
                cell?.selectionStyle = .none
                cell?.bind(object)
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.senderImageTableItem.identifier) as? SenderImageTableItem
                cell?.showBtn.tag = indexPath.row
                cell?.delegate = self
                cell?.selectionStyle = .none
                cell?.bind(object)
                return cell!
            }
        }
    }
}

extension ChatScreenVC: ChatImageShowDelegate {
    func showImageBtn(_ sender: UIButton, imageView: UIImageView) {
        self.view.endEditing(true)
        let object = self.chatList[sender.tag]
//        if object.message_type == "media" {
            let vc = R.storyboard.chat.imagePreviewVC()
            vc?.object = object
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true, completion: nil)
//        }
    }
}

// MARK: - ImagePicker
extension  ChatScreenVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let convertedImageData = image.jpegData(compressionQuality: 0.2)
        self.sendMedia(ImageData: convertedImageData!)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func sendMedia(ImageData:Data){
        let mediaHashId = Int(arc4random_uniform(UInt32(100000)))
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background {
            ChatManager.instance.sendMedia(AccessToken: accessToken, To_userId: toID, Hash_Id: mediaHashId, MediaData: ImageData ) { (success, sessionError, error) in
                if success != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                        }
                    }
                }else if sessionError != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
                        }
                    }
                }else {
                    Async.main {
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - StickerDelegate
extension ChatScreenVC: StickerDelegate{
    func selectSticker(with stickerId: Int) {
        sendSticker(stickerID: stickerId)
    }
    private func sendSticker(stickerID:Int) {
        let stickerHashId = Int(arc4random_uniform(UInt32(100000)))
        let stickerId = stickerID
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background {
            ChatManager.instance.sendSticker(AccessToken: accessToken, To_userId: toID, StickerId: stickerId, Hash_Id: stickerHashId ) { (success, sessionError, error) in
                if success != nil {
                    Async.main {
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                            self.fetchData()
                        }
                    }
                }else if sessionError != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
                        }
                    }
                }else {
                    Async.main {
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
            
        }
    }
    
}

// MARK: - GiftDelegate

extension ChatScreenVC: GiftDelegate{
    
    func selectGift(with giftId: Int) {
        sendGift(giftID: giftId)
    }
    private func sendGift(giftID:Int){
        let giftHashId = Int(arc4random_uniform(UInt32(100000)))
        _ = giftID
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background {
            ChatManager.instance.sendGift(AccessToken: accessToken, To_userId: toID, GiftId: giftID, Hash_Id: giftHashId ) { (success, sessionError, error) in
                if success != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                        }
                    }
                }else if sessionError != nil{
                    Async.main {
                        self.dismissProgressDialog {
                            
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    }
                }else {
                    Async.main {
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
        }
    }
}

//MARK: - TextField Delegate Methods -
extension ChatScreenVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let isEmpty = textField.text?.trimmingCharacters(in: .whitespaces).count == 0
        self.giftView.isHidden = !isEmpty
        self.imageView.isHidden = !isEmpty
    }
}

// MARK: - ReceiveCallDelegate
//extension ChatScreenVC:ReceiveCallDelegate{
//    func receiveCall(status: Bool, profileImage: String, CallId: Int, AccessToken: String, RoomId: String, username: String, isVoice: Bool) {
//        if isVoice{
//            let vc = R.storyboard.call.voiceCallVC()
////            vc?.accessToken = AccessToken
//            vc?.roomID = RoomId
//            vc?.callID = CallId
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }else{
//            let vc = R.storyboard.call.tempVCalling()
//            vc?.accessToken = AccessToken
//            vc?.roomId = RoomId
//            vc?.modalPresentationStyle = .fullScreen
//            self.present(vc!, animated: true, completion: nil)
//        }
//
//    }
//
//
//}

var isEmoji = false

class EmojiTextField: UITextField {
    
    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if isEmoji {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }else {
                return mode
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(inputModeDidChange),
                                               name: UITextInputMode.currentInputModeDidChangeNotification,
                                               object: nil)
    }
    
    @objc func inputModeDidChange(_ notification: Notification) {
        guard isFirstResponder else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadInputViews()
        }
    }
}

// MARK: - More Option Delegate Methods -
extension ChatScreenVC: UserOptionPopupDelegate {
    func shareBtn(_ sender: UIButton) {
    }
    
    func reportBtn(_ sender: UIButton) {
        //CLear Chat
        self.view.endEditing(true)
        self.clearChat()
    }
    
    func blockBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.blockUser()
    }
}

extension ChatScreenVC: GetPremiumStickerDelegate {
    func getBtnAction(_ sender: UIButton) {
        self.goToUpgradeAccount()
    }
    
    func buyCreditsBtnAction(_ sender: UIButton) {
        self.goToCreditPage()
    }
    
    func goToCreditPage() {
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func goToUpgradeAccount() {
        let vc = R.storyboard.credit.upgradeAccountVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

//MARK: - Upgrade Account Delegate -
extension ChatScreenVC: UpgradeAccountDelegate {
    func selectedMemberShipType(_ price: Int, type: Int) {
        self.selectedAmount = price
        self.selectedMemberShip = type
        self.selectedPaymentType = "go_pro"
        if let viewController = R.storyboard.credit.paymentOpetionViewController() {
            viewController.delegate = self
            let panVC: PanModalPresentable.LayoutType = viewController
            presentPanModal(panVC)
        }
    }
}

//MARK: - Buy Credit Delegate -
extension ChatScreenVC: BuyCreditDelegate {
    func selectedCreditType(_ index: Int, Amount: Int) {
        self.selectedAmount = Amount
        self.selectedCredit = ((index == 0) ? 1000 : (index == 1) ? 5000 : 10000)
        self.selectedPaymentType = "credit"
        if let viewController = R.storyboard.credit.paymentOpetionViewController() {
            viewController.delegate = self
            let panVC: PanModalPresentable.LayoutType = viewController
            presentPanModal(panVC)
        }
    }
}

//MARK: - Payment Options Delegate -
extension ChatScreenVC: PaymentOptionDelegate {
    func selectedPaymentMethod(vc: PaymentOpetionViewController, _ type: PaymentName) {
        self.selectedPaymentMethod = type
        switch type {
        case .paypal:
            self.startPaypalCheckouts()
            break
        case .creditCard:
            let viewController = PaymentCardVC.instantiate(fromStoryboardNamed: .credit)
            viewController.amount = self.selectedAmount
            viewController.paymentType = .creditCard
            if selectedPaymentType == "go_pro" {
                viewController.memberShipType = self.selectedMemberShip
            }else {
                viewController.credits = self.selectedCredit
            }
            viewController.payType = self.selectedPaymentType
            viewController.delegate = self
            self.navigationController?
                .pushViewController(viewController, animated: true)
            break
        case .bank:
            let viewController = BankTransferVC.instantiate(fromStoryboardNamed: .credit)
            viewController.amount = self.selectedAmount
            viewController.credits = self.selectedCredit
            viewController.payType = self.selectedPaymentType
            self.navigationController?
                .pushViewController(viewController, animated: true)
            break
        case .razorPay:
            self.view.makeToast("Please wait.....")
            self.openRazorpayCheckout()
            break
        case .securionPay:
            break
        case .authorizeNet:
            let viewController = PaymentCardVC.instantiate(fromStoryboardNamed: .credit)
            viewController.amount = self.selectedAmount
            viewController.paymentType = .authorizeNet
            viewController.payType = self.selectedPaymentType
            viewController.delegate = self
            self.navigationController?
                .pushViewController(viewController, animated: true)
            break
        case .iyziPay:
            self.openIyziPayment()
            break
        case .cashfree:
            let popupVC = R.storyboard.popUps.cashfreePopupVC()
            popupVC?.delegate = self
            self.present(popupVC!, animated: true)
            break
        case .paystack:
            let popupVC = R.storyboard.popUps.payStackEmailPopupVC()
            popupVC?.delegate = self
            self.present(popupVC!, animated: true)
            break
        case .aamarPay:
            self.openAamarPayAPI()
            break
        case .flutterWave:
            let popupVC = R.storyboard.popUps.payStackEmailPopupVC()
            popupVC?.delegate = self
            self.present(popupVC!, animated: true)
            break
        case .coinbase:
            self.openCoinBasePayment()
            break
        case .ngenius:
            self.openNgeniusPayment()
            break
        }
    }
}

//MARK: - Paypal -
extension ChatScreenVC {
    func startPaypalCheckouts() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: NSLocalizedString("Loading...", comment: "Loading..."))
            self.braintreeClient = BTAPIClient(authorization: ControlSettings.paypalAuthorizationToken)!
            let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient!)
            let request = BTPayPalCheckoutRequest(amount: "\(self.selectedAmount)")
            request.currencyCode = "USD"
            payPalDriver.tokenizePayPalAccount(with: request) { tokenizedPayPalAccount, error in
                if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                    self.dismissProgressDialog {
                        print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                    }
                } else if let error = error {
                    self.dismissProgressDialog {
                        self.view.makeToast(error.localizedDescription)
                        Logger.verbose("error = \(error.localizedDescription)")
                    }
                } else {
                    self.dismissProgressDialog {
                        self.view.makeToast(error?.localizedDescription ?? "")
                        Logger.verbose("error = \(error?.localizedDescription ?? "")")
                    }
                }
            }
        } else {
            self.view.makeToast(InterNetError)
        }
    }
}

//MARK: - Ngenius -
extension ChatScreenVC: NgeniusPayWebViewDelegate {
    func ngeniusView(_ isSuccess: Bool, referanceID: String, credit: String) {
        //        self.view.makeToast("Payment Complete SuccessFully!.....", position: .center)
        print(referanceID)
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "credit": credit,
            "ref": referanceID
        ]
        PaymentManager.instance.fetchNgeniusSuccessPaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error, position: .center)
                    return
                }else {
                    if let url = Success?["message"] as? String {
                        self.view.makeToast(url, position: .center)
                        self.fetchProfile()
                    }
                }
            }
        }
    }
    
    
    func fetchProfile() {
        AppManager.shared.fetchUserProfile()
    }
    
    func openNgeniusPayment() {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "price": self.selectedAmount
        ]
        PaymentManager.instance.fetchNgeniusPaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .ngenius
                        vc.iyzipayJS = url
                        vc.ngeniusDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Coinbase -
extension ChatScreenVC {
    func openCoinBasePayment() {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "price": self.selectedAmount
        ]
        PaymentManager.instance.fetchCoinbasePaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .coinbase
                        vc.iyzipayJS = url
                        //                        vc.aamarPayDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - FlutteWave -
extension ChatScreenVC {
    func openFlutteWavePaymentMethodAPI(email: String) {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "type": self.selectedPaymentType,
            "email": email,
            "amount": self.selectedAmount
        ]
        PaymentManager.instance.fetchFlutteWavePaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .flutterWave
                        vc.iyzipayJS = url
                        vc.aamarPayDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Aamar Pay -
extension ChatScreenVC: AamarPayWebViewDelegate {
    func aamarPayView(_ isSuccess: Bool, referanceID: String) {
        self.view.makeToast("Payment Complete SuccessFully!.....", position: .center)
        self.fetchProfile()
    }
    
    func openAamarPayAPI() {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "type": self.selectedPaymentType,
            "email": AppInstance.shared.userProfileSettings?.email ?? "",
            "name": AppInstance.shared.userProfileSettings?.fullname ?? "",
            "phone": "98989898898",
            "price": self.selectedAmount
        ]
        PaymentManager.instance.fetchAamarPaymentAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .aamarPay
                        vc.iyzipayJS = url
                        vc.aamarPayDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - PayStack -
extension ChatScreenVC: PayStackEmailPopupVCDelegate, PaystackWebViewDelegate {
    func webView(_ isSuccess: Bool, referanceID: String) {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "reference": referanceID,
            "pay_type": self.selectedPaymentType,
            "price": self.selectedAmount,
            "membershipType": self.selectedMemberShip,
            "amount": self.selectedAmount
        ]
        
        PayStackPaymentGatewayManager.instance.payStackPaymentSuccessAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error, position: .center)
                    return
                }else {
                    print(Success ?? [:])
                    self.fetchProfile()
                }
            }
        }
    }
    
    func handlePayStackPayNowButtonTap(email: String) {
        if self.selectedPaymentMethod == .flutterWave {
            self.openFlutteWavePaymentMethodAPI(email: email)
        }else {
            self.openPayStackPaymentMethodsAPI(email: email)
        }
    }
    
    func openPayStackPaymentMethodsAPI(email: String) {
        self.showProgressDialog(with: "Please Wait....")
        let params: JSON = [
            "access_token": AppInstance.shared.accessToken ?? "",
            "type": self.selectedPaymentType,
            "email": email,
            "price": self.selectedAmount
        ]
        PayStackPaymentGatewayManager.instance.payStackInitializeAPI(params: params) { Success, error in
            self.dismissProgressDialog {
                if let error = error {
                    self.view.makeToast(error)
                    return
                }else {
                    if let url = Success?["url"] as? String {
                        guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                        vc.paymentType = .paystack
                        vc.iyzipayJS = url
                        vc.paystackDelegate = self
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Card Payment Delegate -
extension ChatScreenVC: PaymentCardViewDelegate {
    func cardView(_ isSuccess: Bool) {
        if isSuccess {
            self.fetchProfile()
        }
    }
}

//MARK: - Iyzi Pay -
extension ChatScreenVC {
    func openIyziPayment() {
        self.showProgressDialog(with: "Loading...")
        let params: JSON = [
            API.PARAMS.access_token: AppInstance.shared.accessToken ?? "",
            API.PARAMS.price: self.selectedAmount
        ]
        
        PaymentManager.instance.iyzipayCreateSession(params: params) { stHtmlText, error in
            self.dismissProgressDialog {
                guard error == nil else {
                    self.view.makeToast(error)
                    return
                }
                if let text = stHtmlText {
                    guard let vc = R.storyboard.credit.iyziPayViewController() else { return }
                    vc.paymentType = .iyziPay
                    vc.iyzipayJS = text
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// MARK: - Razorpay Setup -
extension ChatScreenVC: RazorpayProtocol, ExternalWalletSelectionProtocol, RazorpayPaymentCompletionProtocol {
    private func openRazorpayCheckout() {
        let options = [
            "amount" : self.selectedAmount * 100,
            "currency" : "INR",
            "description" : "Booking For: \(description)",
            "image" : UIImage(named: "Logo") ?? UIImage(),
            "name" : "Add To Balance",
            "prefill" :
                ["email" : "", "contact": ""],
            "theme" : ["color" : "#FF007E"]
        ] as [String : Any]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.razorpayObj?.open(options, displayController:  appDelegate.window?.rootViewController ?? self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = true
        }
    }
    
    func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
        
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        self.view.makeToast("error: \(code) \(str)")
        (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        if let accessToken = AppInstance.shared.accessToken {
            PaymentManager.instance.razorPaySuccess(AccessToken: accessToken, payment_id: payment_id, merchant_amount: "\(self.selectedAmount)") { json, error in
                guard error == nil else {
                    self.view.makeToast(error)
                    (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
                    return
                }
                self.fetchProfile()
                self.view.makeToast(NSLocalizedString("The RazorPay transaction was complete.", comment: "The RazorPay transaction was complete"))
                (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
            }
        } else {
            self.view.makeToast("Something went wrong, please try again")
            (self.tabBarController as? MainTabBarViewController)?.customTabBarView.isHidden = false
        }
    }
}

//MARK: - CashFree -
extension ChatScreenVC: CashfreePopupVCDelegate {
    func handleCashfreePayNowButtonTap(name: String, email: String, phone: String) {
        //        self.initializeCashfreeWalletApi(name: name, email: email, phone: phone, amount: self.amount)
        createCashfreeOrderID(name: "Ravij", email: "ravijasoliya@yopmail.com", phone: "9898987878")
    }
    
    func createCashfreeOrderID(name: String, email: String, phone: String) {
        let urlString = "https://sandbox.cashfree.com/pg/orders"
        
        let detailsParam: JSON = [
            "customer_id": "4544587ftyffg",
            "customer_name": "Ravij",
            "customer_phone": "9898987878",
            "customer_email": "ravijasoliya@yopmail.com"
        ]
        
        let params: JSON = [
            "customer_details": detailsParam,
            "order_amount": 50,
            "order_currency": "INR"
        ]
        
        let header: HTTPHeaders = [
            "Content-Type":"application/json",
            "x-api-version":"2022-09-01",
            "x-client-id":"128533c99484c7e3061ceac5935821",
            "x-client-secret":"12eb1d28deb9af29f9e684157aeec4ea96f5b94d"
        ]
        
        AF.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { response in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                print(res)
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
            }
        }
    }
}
