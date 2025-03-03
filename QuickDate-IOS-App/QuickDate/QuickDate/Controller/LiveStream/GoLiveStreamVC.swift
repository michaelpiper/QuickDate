//
//  GoLiveStreamVC.swift
//  QuickDate
//
//  Created by iMac on 11/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Async
import SDWebImage
import CloudKit
import QuickDateSDK
import AVFoundation

class KeyCenter: NSObject {
    static let AppId: String = AppInstance.shared.adminAllSettings?.data?.agora_app_id ?? ""
    static let Certificate: String? = AppInstance.shared.adminAllSettings?.data?.agora_app_certificate ?? ""
}


class GoLiveStreamVC: UIViewController {
        
    @IBOutlet weak var audienceView: UIView!
    @IBOutlet weak var broadcasterView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: CommentTableViewCell.self)
        }
    }
    @IBOutlet weak var audienceImage: UIImageView!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var cameraSwitchButton: UIButton!
    @IBOutlet weak var beautifyButton: UIButton!
    @IBOutlet weak var cameraOnOffButton: UIButton!
    @IBOutlet weak var micOnOffButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var optionsView: UIView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    
    var postId: Int?
    
    private var isFrontCamera = true
    private var isCameraOn = false
    private var isMicOn = true
    private var isCameraBeautify = false
    
    private var commentList: [Comment] = []
    private var isFirstLoading = true
        
    private var second = 0
    private var minute = 0
    
    private var commentTimer: Timer?
    private var postTimer: Timer?
    private var secTimer: Timer?
    
    //MARK: - Agora Variables -
    var remoteUid: UInt?
    var agoraKit: AgoraRtcEngineKit!
    var userRole: AgoraClientRole = .broadcaster
    var isJoined: Bool = false
    var isUltraLowLatencyOn: Bool = false
    var channelName: String?
//    private var cameraPreviewView: UIView!
    
    private enum LiveAction {
        case start
        case newComment
        case checkComments
        case delete
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        if self.userRole == .broadcaster {
            channelName = "QuickDate_\(today)"
        }
        self.audienceView.isHidden = self.userRole == .broadcaster
        self.broadcasterView.isHidden = self.userRole == .audience
        self.optionsView.isHidden = self.userRole == .audience
        
        configureUI()
        // layout render view
//        self.cameraPreviewView = cameraPreviewView
        
        // set up agora instance when view loaded
        let config = AgoraRtcEngineConfig()
        config.appId = KeyCenter.AppId
        config.channelProfile = .liveBroadcasting
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        // Configuring Privatization Parameters
        Util.configPrivatization(agoraKit: agoraKit)
        agoraKit.setLogFile(LogUtils.sdkLogPath())
        
        // get channel name from configs
        guard let channelName = channelName else {return}
        
        // if inital role is broadcaster, do not show audience options
        /*clientRoleToggleView.isHidden = role == .broadcaster
        ultraLowLatencyToggleView.isHidden = role == .broadcaster*/
        
        // make this room live broadcasting room
        updateClientRole(userRole)
        
        // enable video module and set up video encoding configs
        agoraKit.enableVideo()
        
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        // start joining channel
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. If app certificate is turned on at dashboard, token is needed
        // when joining channel. The channel name and uid used to calculate
        // the token has to match the ones used for channel join
        let option = AgoraRtcChannelMediaOptions()
        option.publishCameraTrack = userRole == .broadcaster
        option.publishMicrophoneTrack = userRole == .broadcaster
        option.clientRoleType = userRole
        AgoraNetworkManager.shared.generateToken(channelName: channelName) { token in
            let result = self.agoraKit.joinChannel(byToken: token, channelId: channelName, uid: 0, mediaOptions: option)
            if result != 0 {
                self.showAlert(title: "Error", message: "joinChannel call failed: \(result), please check your params")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.userRole == .broadcaster {
            setTimers()
            fetchDataFromRemote(to: .start)
        }
    }
    
    @objc func secondTimer() {
//        if second == 60 {
//            minute += 1
//            second = 0
//        }
        second = second + 1
        timeLabel.text = "\(timeString(time: TimeInterval(self.second)))   "//"  \(minute)\(":")\(second)"
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) {
            if sender.tag == 1001 {
                self.stopTimers()
                self.fetchDataFromRemote(to: .delete)
            }
            self.agoraKit?.leaveChannel(nil)
            self.agoraKit?.stopPreview()
            DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}            
        }
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
            self.cameraPreviewView.isHidden = false
        case false:
            self.agoraKit?.disableVideo()
            self.cameraPreviewView.isHidden = true
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
        if self.commentTextView.text == "Add Comment here" {
            self.view.makeToast("Write a Somthings......")
            return
        }
        fetchDataFromRemote(to: .newComment)
    }
    
    @objc private func fetchComments() {
        fetchDataFromRemote(to: .checkComments)
    }
}

//MARK: - Helper Functions -
extension GoLiveStreamVC {
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
    
    func timeString(time:TimeInterval) -> String {
        _ = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
}

//MARK: - API Services -
extension GoLiveStreamVC {
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
}

// MARK: - DataSource

extension GoLiveStreamVC: UITableViewDelegate, UITableViewDataSource {
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
extension GoLiveStreamVC: UITextViewDelegate {
    
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

//MARK: - Agora Helper Functions -
extension GoLiveStreamVC {
    fileprivate func updateClientRole(_ role:AgoraClientRole) {
        self.userRole = role
        if(role == .broadcaster) {
            becomeBroadcaster()
        } else {
            becomeAudience()
        }
        let option = AgoraRtcChannelMediaOptions()
        option.publishCameraTrack = role == .broadcaster
        option.publishMicrophoneTrack = role == .broadcaster
        agoraKit.updateChannel(with: option)
    }
    
    /// make myself a broadcaster
    func becomeBroadcaster() {
        guard let resolution = GlobalSettings.shared.getSetting(key: "resolution")?.selectedOption().value as? CGSize,
        let fps = GlobalSettings.shared.getSetting(key: "fps")?.selectedOption().value as? AgoraVideoFrameRate,
        let orientation = GlobalSettings.shared.getSetting(key: "orientation")?.selectedOption().value as? AgoraVideoOutputOrientationMode else {
            LogUtils.log(message: "invalid video configurations, failed to become broadcaster", level: .error)
            return
        }
        agoraKit.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(size: resolution,
                                           frameRate: fps,
                                           bitrate: AgoraVideoBitrateStandard,
                                           orientationMode: orientation,
                                           mirrorMode: .auto)
        )
        
        // set up local video to render your local camera preview
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        // the view to be binded
        videoCanvas.view = localVideoCanvas()
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
        // you have to call startPreview to see local video
        agoraKit.startPreview()
        agoraKit.enableAudio()
        
        agoraKit.setClientRole(.broadcaster, options: nil)
    }
    
    /// make myself an audience
    func becomeAudience() {
        // unbind view
        agoraKit.setupLocalVideo(nil)
        // You have to provide client role options if set to audience
        let options = AgoraClientRoleOptions()
        options.audienceLatencyLevel = isUltraLowLatencyOn ? .ultraLowLatency : .lowLatency
        agoraKit.setClientRole(.audience, options: options)
    }
    
    func localVideoCanvas() -> UIView {
        return cameraPreviewView
    }
    
    func remoteVideoCanvas() -> UIView {
        return cameraPreviewView
    }
}


/// agora rtc engine delegate events
extension GoLiveStreamVC: AgoraRtcEngineDelegate {
    /// callback when warning occured for agora sdk, warning can usually be ignored, still it's nice to check out
    /// what is happening
    /// Warning code description can be found at:
    /// en: https://api-ref.agora.io/en/voice-sdk/ios/3.x/Constants/AgoraWarningCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// @param warningCode warning code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        LogUtils.log(message: "warning: \(warningCode.description)", level: .warning)
    }
    
    /// callback when error occured for agora sdk, you are recommended to display the error descriptions on demand
    /// to let user know something wrong is happening
    /// Error code description can be found at:
    /// en: https://api-ref.agora.io/en/voice-sdk/macos/3.x/Constants/AgoraErrorCode.html#content
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// @param errorCode error code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        LogUtils.log(message: "error: \(errorCode)", level: .error)
        self.showAlert(title: "Error", message: "Error \(errorCode.description) occur")
    }
    
    /// callback when the local user joins a specified channel.
    /// @param channel
    /// @param uid uid of local user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        isJoined = true
        LogUtils.log(message: "Join \(channel) with uid \(uid) elapsed \(elapsed)ms", level: .info)
    }
    
    /// callback when a remote user is joinning the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {

        LogUtils.log(message: "remote user join: \(uid) \(elapsed)ms", level: .info)
        
        //record remote uid
        remoteUid = uid
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        let videoCanvas = AgoraRtcVideoCanvas()
        // the view to be binded
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideoCanvas()
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    /// callback when a remote user is leaving the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param reason reason why this user left, note this event may be triggered when the remote user
    /// become an audience in live broadcasting profile
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        LogUtils.log(message: "remote user left: \(uid) reason \(reason)", level: .info)
        //clear remote uid
        if(remoteUid == uid) {
            remoteUid = nil
        }
        
        // to unlink your view from sdk, so that your view reference will be released
        // note the video will stay at its last frame, to completely remove it
        // you will need to remove the EAGL sublayer from your binded view
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        // the view to be binded
        videoCanvas.view = nil
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    /// Reports the statistics of the current call. The SDK triggers this callback once every two seconds after the user joins the channel.
    /// @param stats stats struct
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
//        foregroundVideo.statsInfo?.updateChannelStats(stats)
    }
    
    /// Reports the statistics of the uploading local audio streams once every two seconds.
    /// @param stats stats struct
    func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioStats stats: AgoraRtcLocalAudioStats) {
//        foregroundVideo.statsInfo?.updateLocalAudioStats(stats)
    }
    
    /// Reports the statistics of the video stream from each remote user/host.
    /// @param stats stats struct
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
//        backgroundVideo.statsInfo?.updateVideoStats(stats)
    }
    
    /// Reports the statistics of the audio stream from each remote user/host.
    /// @param stats stats struct for current call statistics
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
//        backgroundVideo.statsInfo?.updateAudioStats(stats)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, videoRenderingTracingResultOfUid uid: UInt, currentEvent: AgoraMediaTraceEvent, tracingInfo: AgoraVideoRenderingTracingInfo) {
//        backgroundVideo.statsInfo?.updateFirstFrameInfo(tracingInfo)
    }
}
