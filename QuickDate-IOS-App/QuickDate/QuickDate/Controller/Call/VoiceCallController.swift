////
////  VoiceCallController.swift
////  QuickDate
////
////  Created by Ubaid Javaid on 12/23/20.
////  Copyright © 2020 Lê Việt Cường. All rights reserved.
////
//
//import UIKit
//import TwilioVideo
//import Async
//import AVFoundation
//import PushKit
//import CallKit
//import TwilioVoice
//
//class VoiceCallController:BaseVC,CallDelegate{
//
//
//    @IBOutlet var imageView: RoundImage!
//    @IBOutlet var callerName: UILabel!
//    @IBOutlet var timerLabel: UILabel!
//    @IBOutlet var micBtn: RoundButton!
//    @IBOutlet var speakerBtn: RoundButton!
//
//
//    // Configure access token manually for testing, if desired! Create one manually in the console
//    // at https://www.twilio.com/console/video/runtime/testing-tools
//    var accessToken = ""
//    var accessToken1 = ""
//
//    // Configure remote URL to fetch token from
//    let tokenUrl = "http://119.160.119.161:80/accessToken.php"
////    http://localhost/Twilio%20SDK/
//    // Automatically record audio for all `AudioTrack`s published in a Room.
//    let recordAudio = true
//
//    // Video SDK components
//    var room: TVIRoom?
////    var room: TVICall?
//    var camera: TVICameraSource?
//    var localAudioTrack: TVILocalAudioTrack!
//    var localVideoTrack: TVILocalVideoTrack!
//
//    var callKitCompletionCallback: ((Bool) -> Void)? = nil
//    var audioDevice = DefaultAudioDevice()
//    var activeCallInvites: [String: CallInvite]! = [:]
//    var activeCalls: [String: Call]! = [:]
//
//    // activeCall represents the last connected call
//    var activeCall: Call? = nil
//
//    let kPreviewPadding = CGFloat(10)
//    let kTextBottomPadding = CGFloat(4)
//    let kMaxRemoteVideos = Int(2)
//    var roomId:String? = ""
//    var callID:Int? = 0
//    var speaker = "0"
//    var mic  = "0"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        TwilioVoice.audioDevice = audioDevice
//
////        prepareLocalMedia()
//        if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
////                logMessage(messageText: message)
//                return
//            }
//        }
//
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//
//
//        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
//            builder.params = ["to": self.roomId ?? ""]
////            builder.uuid = uuid
//
//        }
//
//        let call = TwilioVoice.connect(options: connectOptions, delegate: self)
//        activeCall = call
//        activeCalls[call.uuid!.uuidString] = call
//
//    }
//
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return self.room != nil
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return self.room != nil
//    }
//
//
//    @IBAction func Speaker(_ sender: UIButton) {
//        if (self.speaker == "0"){
//            self.speaker = "1"
//            self.speakerBtn.setImage(UIImage(named: "volume"), for: .normal)
//            self.setAudioOutputSpeaker(enabled: false)
//
//        }
//        else{
//            self.speaker = "1"
//            self.speakerBtn.setImage(UIImage(named: "mute"), for: .normal)
//            self.setAudioOutputSpeaker(enabled: true)
//        }
//
//    }
//
//    func setAudioOutputSpeaker(enabled: Bool)
//    {
//        let session = AVAudioSession.sharedInstance()
//        var _: Error?
//        try? session.setCategory(AVAudioSession.Category.playAndRecord)
//        try? session.setMode(AVAudioSession.Mode.voiceChat)
//        if enabled {
//            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//
//        }
//        else {
//            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
//        }
//        try? session.setActive(true)
//    }
//
//
//    @IBAction func MicBtn(_ sender: UIButton) {
//       if self.mic == "0"{
//        self.mic = "1"
//        self.micBtn.setImage(UIImage(named: "microphone-off"), for: .normal)
//        guard let activeCall = activeCall else { return }
//        activeCall.isMuted = true
//        }
//       else{
//        self.mic = "0"
//        self.micBtn.setImage(UIImage(named: "voice"), for: .normal)
//        guard let activeCall = activeCall else { return }
//        activeCall.isMuted = false
//       }
//    }
//
//
//    @IBAction func DisconnectCall(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//     func prepareLocalMedia() {
//
//         // We will share local audio and video when we connect to the Room.
//
//         // Create an audio track.
//         if (localAudioTrack == nil) {
//             localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
//
//             if (localAudioTrack == nil) {
////                 logMessage(messageText: "Failed to create audio track")
//             }
//         }
//     }
//
//
//    private func deleteCall(callID:Int){
//        //        self.dismiss(animated: true, completion: nil)
//        let accessToken = AppInstance.instance.accessToken ?? ""
//
//        Async.background({
//            AudioCallManager.instance.deleteAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
//                if success != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            Logger.debug("userList = \(success?.status ?? nil)")
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    })
//                }else if sessionError != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(sessionError?.errors?.errorText)
//                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//
//                        }
//                    })
//                }else {
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(error?.localizedDescription)
//                            Logger.error("error = \(error?.localizedDescription ?? "")")
//                        }
//                    })
//                }
//            })
//
//        })
//    }
//
//    func callDidConnect(call: Call) {
//        NSLog("callDidConnect:")
//    }
//
//    func callDidFailToConnect(call: Call, error: Error) {
//        NSLog("Call failed to connect: \(error.localizedDescription)")
//        callDisconnected(call: call)
//    }
//
//    func callDidDisconnect(call: Call, error: Error?) {
//        if let error = error {
//            NSLog("Call failed: \(error.localizedDescription)")
//        } else {
//            NSLog("Call disconnected")
//        }
//        callDisconnected(call: call)
//
//    }
//
//
//    private func callDisconnected(call: Call) {
//        if call == activeCall {
//            activeCall = nil
//        }
//
//        activeCalls.removeValue(forKey: call.uuid!.uuidString)
//    }
//
//}
//
//import AgoraRtcKit
//import Async
//import QuickDateSDK
//
//class VoiceCallController: BaseVC {
//    @IBOutlet weak var localVideo: UIView!
//    @IBOutlet weak var remoteVideo: UIView!
//    @IBOutlet weak var controlButtons: UIView!
//    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
//    @IBOutlet weak var localVideoMutedBg: UIImageView!
//    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
//    
//    var agoraKit: AgoraRtcEngineKit!
//    
//    var recipientId:String? = ""
//    var callId:Int? = 0
//    var roomID:String? = ""
//    private var timer = Timer()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupButtons()
//        hideVideoMuted()
//        initializeAgoraEngine()
//        setupVideo()
//        setupLocalVideo()
//        joinChannel()
//        log.verbose("Room ID: = \(self.roomID!)")
//          self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    //cea80c3b9a744f69ba90a68d07ca9167
//    func initializeAgoraEngine() {
//        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId:ControlSettings.agoraCallingToken , delegate: self)
//    }
//
//    func setupVideo() {
//        agoraKit.enableVideo()  // Default mode is disableVideo
//        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
//                                                                             frameRate: .fps15,
//                                                                             bitrate: AgoraVideoBitrateStandard,
//                                                                             orientationMode: .adaptative))
//    }
//    
// 
//    func setupLocalVideo() {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = 0
//        videoCanvas.view = localVideo
//        videoCanvas.renderMode = .hidden
//        agoraKit.setupLocalVideo(videoCanvas)
//    }
//    
//    
//    func joinChannel() {
//        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
//        agoraKit.joinChannel(byToken: nil, channelId: "\(callId!)", info:nil, uid:0) {[weak self] (sid, uid, elapsed) -> Void in
//            // Join channel "demoChannel1"
//            if let weakSelf = self {
//                UIApplication.shared.isIdleTimerDisabled = true
//            }
//        }
//    }
//    
//
//    @IBAction func didClickHangUpButton(_ sender: UIButton) {
//        leaveChannel()
//        
//    }
//    
//    func leaveChannel() {
//        agoraKit.leaveChannel(nil)
//        hideControlButtons()
//        UIApplication.shared.isIdleTimerDisabled = false
//        remoteVideo.removeFromSuperview()
//        localVideo.removeFromSuperview()
//        let callIdConverted = "\(callId!)"
//        if ControlSettings.agoraCall == true && ControlSettings.twilloCall == false{
//            self.declineCall(callID: callIdConverted)
//        }else{
//            self.twilloDeclineCall(callID: callIdConverted)
//        }
//        
//    }
//    
//
//    func setupButtons() {
//        perform(#selector(hideControlButtons), with:nil, afterDelay:8)
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ViewTapped))
//        view.addGestureRecognizer(tapGestureRecognizer)
//        view.isUserInteractionEnabled = true
//    }
//    
//    @objc func hideControlButtons() {
//        controlButtons.isHidden = true
//    }
//    
//    @objc func ViewTapped() {
//        if (controlButtons.isHidden) {
//            controlButtons.isHidden = false;
//            perform(#selector(hideControlButtons), with:nil, afterDelay:8)
//        }
//    }
//    
//    func resetHideButtonsTimer() {
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
//        perform(#selector(hideControlButtons), with:nil, afterDelay:8)
//    }
//    
//
//    @IBAction func didClickMuteButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.muteLocalAudioStream(sender.isSelected)
//        resetHideButtonsTimer()
//    }
//    
//
//    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.muteLocalVideoStream(sender.isSelected)
//        localVideo.isHidden = sender.isSelected
//        localVideoMutedBg.isHidden = !sender.isSelected
//        localVideoMutedIndicator.isHidden = !sender.isSelected
//        resetHideButtonsTimer()
//    }
//    
//    func hideVideoMuted() {
//        remoteVideoMutedIndicator.isHidden = true
//        localVideoMutedBg.isHidden = true
//        localVideoMutedIndicator.isHidden = true
//    }
//    
//
//    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.switchCamera()
//        resetHideButtonsTimer()
//    }
//    private func declineCall(callID:String){
//        let userId = AppInstance.instance.userId ?? ""
//        let sessionID = AppInstance.instance.sessionId ?? ""
//        Async.background({
//            CallManager.instance.agoraCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
//                if success != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                        }
//                    })
//                }else if sessionError != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(sessionError?.errors?.errorText)
//                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                            
//                        }
//                    })
//                }else if serverError != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(serverError?.errors?.errorText)
//                            log.error("serverError = \(serverError?.errors?.errorText)")
//                        }
//                        
//                    })
//                    
//                }else {
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(error?.localizedDescription)
//                            log.error("error = \(error?.localizedDescription)")
//                        }
//                    })
//                }
//                
//            })
//            
//        })
//        
//    }
//    private func twilloDeclineCall(callID:String){
//        let userId = AppInstance.instance.userId ?? ""
//        let sessionID = AppInstance.instance.sessionId ?? ""
//        Async.background({
//            TwilloCallmanager.instance.twilloVideoCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
//                if success != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                        }
//                    })
//                }else if sessionError != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(sessionError?.errors?.errorText)
//                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                            
//                        }
//                    })
//                }else if serverError != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(serverError?.errors?.errorText)
//                            log.error("serverError = \(serverError?.errors?.errorText)")
//                        }
//                        
//                    })
//                    
//                }else {
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(error?.localizedDescription)
//                            log.error("error = \(error?.localizedDescription)")
//                        }
//                    })
//                }
//            })
//          
//        })
//        
//    }
//    @objc func update() {
//        self.checkForCallAction(callID: self.callId!)
//        
//    }
//    private func checkForCallAction(callID:Int){
//        let userId = AppInstance.instance.userId ?? ""
//        let sessionID = AppInstance.instance.sessionId ?? ""
//        if ControlSettings.agoraCall == true && ControlSettings.twilloCall == false{
//            Async.background({
//                CallManager.instance.checkForAgoraCall(user_id: userId, session_Token: sessionID, call_id: callID, call_Type: "", completionBlock: { (success, sessionError, serverError, error) in
//                    if success != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                log.debug("userList = \(success?.callStatus ?? nil)")
//                                
//                                if success?.callStatus == "declined"{ self.navigationController?.popViewController(animated: true)
//                                    self.leaveChannel()
//                                    self.timer.invalidate()
//                                    
//                                    log.verbose("Call Has Been Declined")
//                                }else if success?.callStatus == "answered"{
//                                    log.verbose("Call Has Been Answered")
//                                }else if  success?.callStatus == "no_answer"{
//                                    self.dismiss(animated: true, completion: nil)
//                                    self.leaveChannel()
//                                    self.timer.invalidate()
//                                    log.verbose("No Answer")
//                                    
//                                }
//                                
//                            }
//                        })
//                    }else if sessionError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(sessionError?.errors?.errorText)
//                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                                
//                            }
//                        })
//                    }else if serverError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(serverError?.errors?.errorText)
//                                log.error("serverError = \(serverError?.errors?.errorText)")
//                            }
//                            
//                        })
//                        
//                    }else {
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(error?.localizedDescription)
//                                log.error("error = \(error?.localizedDescription)")
//                            }
//                        })
//                    }
//                })
//            })
//        }else{
//            Async.background({
//                TwilloCallmanager.instance.checkForTwilloCall(user_id: userId, session_Token: sessionID, call_id: callID, call_Type: "video", completionBlock: { (success, sessionError, serverError, error) in
//                    if success != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                log.debug("userList = \(success?.callStatus ?? nil)")
//                                
//                                if success?.callStatus == 400{ self.navigationController?.popViewController(animated: true)
//                                    self.leaveChannel()
//                                    self.timer.invalidate()
//                                    log.verbose("Call Has Been Declined")
//                                }else if success?.callStatus == 200{
//                                    log.verbose("Call Has Been Answered")
//                                }else if  success?.callStatus == 300{
//                                  
//                                    log.verbose("calling")
//                                    
//                                }else{
//                                    self.dismiss(animated: true, completion: nil)
//                                    self.leaveChannel()
//                                    self.timer.invalidate()
//                                    log.verbose("No answer")
//                                }
//                                
//                            }
//                        })
//                    }else if sessionError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(sessionError?.errors?.errorText)
//                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                                
//                            }
//                        })
//                    }else if serverError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(serverError?.errors?.errorText)
//                                log.error("serverError = \(serverError?.errors?.errorText)")
//                            }
//                            
//                        })
//                        
//                    }else {
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(error?.localizedDescription)
//                                log.error("error = \(error?.localizedDescription)")
//                            }
//                        })
//                    }
//                })
//               
//            })
//        }
//       
//        
//    }
//}
//
//extension VoiceCallController: AgoraRtcEngineDelegate {
//
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
//        if (remoteVideo.isHidden) {
//            remoteVideo.isHidden = false
//        }
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.view = remoteVideo
//        videoCanvas.renderMode = .adaptive
//        agoraKit.setupRemoteVideo(videoCanvas)
//    }
//    
//
//    internal func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
//        self.remoteVideo.isHidden = true
//    }
//    
//
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
//        remoteVideo.isHidden = muted
//        remoteVideoMutedIndicator.isHidden = !muted
//    }
//}
