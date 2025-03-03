//
//  LiveStreamViewController.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 7.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Async
import SDWebImage
import CloudKit
import QuickDateSDK
import AVFoundation

class LiveStreamViewController: UIViewController {
    
    // MARK: - Views
    
    internal var localView: UIView!
    
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var viewLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var liveLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: CommentTableViewCell.self)
        }
    }
    
    @IBOutlet weak var cameraSwitchButton: UIButton!
    @IBOutlet weak var beautifyButton: UIButton!
    @IBOutlet weak var cameraOnOffButton: UIButton!
    @IBOutlet weak var micOnOffButton: UIButton!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    
    var channelName = ""
    var postId: Int?
    
    private var isFrontCamera = true
    private var isCameraOn = false
    private var isMicOn = true
    private var isCameraBeautify = false
    
    private var commentList: [Comment] = []
    private var isFirstLoading = true
    
    var userRole: AgoraClientRole = .broadcaster
    
    private var second = 0
    private var minute = 0
    
    private var commentTimer: Timer?
    private var postTimer: Timer?
    private var secTimer: Timer?
    
    var agoraKit: AgoraRtcEngineKit?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        if self.userRole == .broadcaster {
            channelName = "QuickDate_\(today)"
        }
        configureUI()
        
        initView()
        initializeAndJoinChannel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localView.frame = self.liveView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.userRole == .broadcaster {
            setTimers()
            fetchDataFromRemote(to: .start)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimers()
        fetchDataFromRemote(to: .delete)
        agoraKit?.leaveChannel(nil)
        agoraKit?.stopPreview()
        DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
    }
    
    // MARK: - API
    
    @objc private func fetchComments() {
        fetchDataFromRemote(to: .checkComments)
    }
    
    private enum LiveAction {
        case start
        case newComment
        case checkComments
        case delete
    }
    
    private func setNetworkParameters(to action: LiveAction) -> APIParameters {
        var params: APIParameters = [
            API.PARAMS.access_token: self.accessToken
        ]
        if action == .start {
            params[API.PARAMS.stream_name] = channelName
            return params
            
        } else {
            guard let postId = postId else {
                Logger.error("getting postId"); return params
            }
            params[API.PARAMS.post_id] = "\(postId)"
            
            if action == .checkComments {
                params[API.PARAMS.page] = "live"
            } else if action == .newComment {
                guard let text = commentTextView.text,
                      !text.isEmpty else {
                          Logger.error("getting text"); return params
                      }
                params[API.PARAMS.text] = text
            }
            
            return params
        }
    }
    
    private func fetchDataFromRemote(to action: LiveAction) {
        let params = setNetworkParameters(to: action)
        let urlString =
        action == .start ? API.LIVE_STREAM_METHODS.GO_LIVE :
        action == .newComment ? API.LIVE_STREAM_METHODS.NEW_COMMENT :
        action == .checkComments ? API.LIVE_STREAM_METHODS.CHECK_COMMENTS : API.LIVE_STREAM_METHODS.DELETE
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: urlString, method: .post,
                parameters: params, successCode: .code
            ) { [weak self] response in
                
                switch response {
                case .failure(let error):
                    Async.main({
                        self?.view.makeToast(error.localizedDescription)
                    })
                    
                case .success(let json):
                    Async.main {
                        switch action {
                        case .start:
                            let postId = json[API.PARAMS.post_id] as? Int
                            Logger.info("post id: \(postId ?? 0)")
                            self?.postId = postId
                            self?.view.makeToast(json[API.PARAMS.message] as? String)
                        case .newComment:
                            Async.main({
                                self?.addNewComment(from: json)
                            })
                        case .checkComments:
                            Async.main({
                                self?.getCommentPublisher(from: json)
                            })
                        case .delete:
                            Logger.verbose("live stream is deleted successfully")
                        }
                    }
                }
            }
        })
        
    }
    
    private func addNewComment(from json: JSON) {
        let row = commentList.count
        
        guard let dict = json["data"] as? JSON else {
            Logger.error("getting comments"); return
        }
        let comment = Comment(dict: dict)
        self.commentList.append(comment)
        
        if row == 0 {
            tableView.reloadData()
        } else {
            tableView.insertRows(at: [[0, row]], with: .automatic)
        }
        view.endEditing(true)
        commentTextView.text = "Add Comment here".localized
    }
    
    private func getCommentPublisher(from json: JSON) {
        guard let dictionaryList = json["comments_array"] as? [JSON] else {
            Logger.error("getting comments"); return
        }
        
        let commentList = dictionaryList.map { Comment(dict: $0) }
        
        switch isFirstLoading {
        case true:
            self.commentList = commentList
            tableView.reloadData()
            isFirstLoading = false
        case false:
            let newList = commentList.compactMap { (comment) -> Comment? in
                let isSameUser =  self.commentList.filter { $0.id == comment.id }.first
                return isSameUser == .none ? comment : nil
            }
            let firstIndex = self.commentList.count
            let lastIndex = newList.count + firstIndex - 1
            guard lastIndex >= firstIndex else { return } // Safety check
            let indexPathList = Array(firstIndex...lastIndex).map { IndexPath(row: $0, section: 0) }
            self.commentList.append(contentsOf: newList)
            tableView.insertRows(at: indexPathList, with: .automatic)
        }
    }
    
    // MARK: - Agora -
    private func initView() {
        localView = UIView()
        self.liveView.addSubview(localView)
    }
    
    private func initializeAndJoinChannel() {

        initializeAgoraEngine()
        setUpVideo()
//        setupLocalVideo()
        
        // Join the channel with a token. Pass in your token and channel name here
        Task {
            await joinChannel()
        }
        
        /*agoraKit?.joinChannel(
            byToken: ControlSettings.agoraCallingToken,
            channelId: channelName,
            info: nil, uid: 0,
            joinSuccess: { (channel, uid, elapsed) in
                UIApplication.shared.isIdleTimerDisabled = true
            })*/
    }
    
    func joinChannel() async {
        if await !self.checkForPermissions() {
            showMessage(title: "Error", text: "Permissions were not granted")
            return
        }

        let option = AgoraRtcChannelMediaOptions()

        // Set the client role option as broadcaster or audience.
        if self.userRole == .broadcaster {
            option.clientRoleType = .broadcaster
            setupLocalVideo()
        } else {
            option.clientRoleType = .audience
        }
        // For a live streaming scenario, set the channel profile as liveBroadcasting.
        
        agoraKit?.setClientRole(self.userRole)
        option.channelProfile = .liveBroadcasting
        // Join the channel with a temp token. Pass in your token and channel name here
        let result = agoraKit?.joinChannel(
            byToken: ControlSettings.agoraCallingToken, channelId: channelName, uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in }
        )
        // Check if joining the channel was successful and set joined Bool accordingly
        if result == 0 {
            showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
        }
    }

    func checkForPermissions() async -> Bool {
        var hasPermissions = await self.avAuthorization(mediaType: .video)
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
        hasPermissions = await self.avAuthorization(mediaType: .audio)
        return hasPermissions
    }

    func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }

    func showMessage(title: String, text: String, delay: Int = 5) -> Void {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    private func initializeAgoraEngine() {
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(
            withAppId: ControlSettings.agoraAppID, delegate: self)
    }
    
    
    private func setUpVideo() {
        agoraKit?.enableVideo()
        
        agoraKit?.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(
            size: AgoraVideoDimension640x360,
            frameRate: .fps15,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative, mirrorMode: AgoraVideoMirrorMode.disabled)
        )
        // Start the local video preview
        agoraKit?.startPreview()
    }
    
    func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    // MARK: - Actions -
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraSwitchButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        isFrontCamera = !isFrontCamera
        switch isFrontCamera {
        case true:  _ = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        case false: _ = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        self.agoraKit?.switchCamera()
    }
    
    @IBAction func beautifyButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        isCameraBeautify = !isCameraBeautify
        switch isCameraBeautify {
        case true:  self.agoraKit?.setBeautyEffectOptions(true, options: .some(.init()))
        case false: self.agoraKit?.setBeautyEffectOptions(false, options: .none)
        }
    }
    
    @IBAction func cameraOnOffButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        isCameraOn = !isCameraOn
        let image: UIImage? = isCameraOn ? .videoOnIcon : .videoOffIcon
        sender.setImage(image, for: .normal)
        switch isCameraOn {
        case true:
            self.agoraKit?.enableVideo()
            localView.isHidden = false
        case false:
            self.agoraKit?.disableVideo()
            localView.isHidden = true
        }
    }
    
    @IBAction func micOnOffButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        isMicOn = !isMicOn
        let image: UIImage? = isMicOn ? .micOnIcon : .micOffIcon
        sender.setImage(image, for: .normal)
        switch isMicOn {
        case true:  self.agoraKit?.enableAudio()
        case false: self.agoraKit?.disableAudio()
        }
    }
    
    @IBAction func sendCommentButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        fetchDataFromRemote(to: .newComment)
    }
    
}

// MARK: - AgoraRtcEngineDelegate

extension LiveStreamViewController: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = liveView
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}

// MARK: - DataSource

extension LiveStreamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CommentTableViewCell
        cell.comment = commentList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextViewDelegate
extension LiveStreamViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.text == "Add Comment here".localized {
            commentTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (self.commentTextView.text == nil)
            || (self.commentTextView.text == " ")
            || (self.commentTextView.text.isEmpty == true){
            self.commentTextView.text = "Add Comment here".localized
        }
    }
}

// MARK: - Helper

extension LiveStreamViewController {
    
    private func configureUI() {
        commentTextView.text = "Add Comment here".localized
        self.userImage.sd_setImage(with: appInstance.userProfileSettings?.avatarURL, placeholderImage: .userAvatar)
        viewLabel.text = appInstance.userProfileSettings?.fullname
    }
    
    private func setTimers() {
        self.secTimer =  Timer.scheduledTimer(
            timeInterval: 1.0, target: self, selector: #selector(self.secondTimer),
            userInfo: nil, repeats: true)
        
        self.commentTimer = Timer.scheduledTimer(
            timeInterval: 2.0, target: self, selector: #selector(fetchComments),
            userInfo: nil, repeats: true)
    }
    
    private func stopTimers() {
        secTimer?.invalidate()
        commentTimer?.invalidate()
    }
    
    @objc func secondTimer() {
//        if second == 60 {
//            minute += 1
//            second = 0
//        }
        second = second + 1
        timeLabel.text = "\(timeString(time: TimeInterval(self.second)))   "//"  \(minute)\(":")\(second)"
    }
    
    func timeString(time:TimeInterval) -> String {
        _ = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
    
}
