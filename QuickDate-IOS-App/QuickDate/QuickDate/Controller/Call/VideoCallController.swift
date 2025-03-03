//
//  VideoCallController.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/23/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import TwilioVideo

//struct PlatformUtils {
//    static let isSimulator: Bool = {
//        var isSim = false
//        #if arch(i386) || arch(x86_64)
//        isSim = true
//        #endif
//        return isSim
//    }()
//}
//
//struct TokenUtils {
//    static func fetchToken(url : String) throws -> String {
//        var token: String = "TWILIO_ACCESS_TOKEN"
//        let requestURL: URL = URL(string: url)!
//        do {
//            let data = try Data(contentsOf: requestURL)
//            if let tokenReponse = String.init(data: data, encoding: String.Encoding.utf8) {
//                token = tokenReponse
//            }
//        } catch let error as NSError {
//            print ("Invalid token url, error = \(error)")
//            throw error
//        }
//        return token
//    }
//}
//class Settings: NSObject {
//
//    let supportedAudioCodecs: [TVIAudioCodec] = [TVIIsacCodec(),
//                                                 TVIOpusCodec(),
//                                                 TVIPcmaCodec(),
//                                                 TVIPcmuCodec(),
//                                                 TVIG722Codec()]
//
//    let supportedVideoCodecs: [TVIVideoCodec] = [TVIVp8Codec(),
//                                                 TVIVp8Codec(simulcast: true),
//                                                 TVIH264Codec(),
//                                                 TVIVp9Codec()]
//
//    var audioCodec: TVIAudioCodec?
//    var videoCodec: TVIVideoCodec?
//
//    var maxAudioBitrate = UInt()
//    var maxVideoBitrate = UInt()
//
//    func getEncodingParameters() -> TVIEncodingParameters?  {
//        if maxAudioBitrate == 0 && maxVideoBitrate == 0 {
//            return nil;
//        } else {
//            return TVIEncodingParameters(audioBitrate: maxAudioBitrate,
//                                         videoBitrate: maxVideoBitrate)
//        }
//    }
//
//    private override init() {
//        // Can't initialize a singleton
//    }
//
//    // MARK: Shared Instance
//    static let shared = Settings()
//}

class VideoCallController: UIViewController {

    
    func setAudioOutputSpeaker(enabled: Bool)
    {
        let session = AVAudioSession.sharedInstance()
        var _: Error?
        try? session.setCategory(AVAudioSession.Category.playAndRecord)
        try? session.setMode(AVAudioSession.Mode.voiceChat)
        if enabled {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        
        }
        else {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
        try? session.setActive(true)
    }
    
    // Configure access token manually for testing, if desired! Create one manually in the console
//    // at https://www.twilio.com/console/video/runtime/testing-tools
//    var accessToken = ""
//    
//    // Configure remote URL to fetch token from
//    var tokenUrl = "http://localhost:8000"
//    
//    // Video SDK components
//    var room: TVIRoom?
//    var audioDevice: TVIDefaultAudioDevice = TVIDefaultAudioDevice()
//    var camera: TVICameraCapturer?
//    var localVideoTrack: TVILocalVideoTrack?
//    var localAudioTrack: TVILocalAudioTrack?
//    var remoteParticipant: TVIRemoteParticipant?
//    var remoteView: TVIVideoView?
//    
//    // MARK:- UI Element Outlets and handles
//    
//    // `VideoView` created from a storyboard
//    @IBOutlet weak var previewView: TVIVideoView!
//    
//    @IBOutlet weak var connectButton: UIButton!
//    @IBOutlet weak var disconnectButton: UIButton!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var roomTextField: UITextField!
//    @IBOutlet weak var roomLine: UIView!
//    @IBOutlet weak var roomLabel: UILabel!
//    @IBOutlet weak var micButton: UIButton!
//    var roomId:String? = ""
//    var callid:Int? =  0
//    
//    @IBOutlet weak var roomNameLabel: UILabel!
//    // MARK:- UIViewController
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.connectButton.isHidden = true
//        self.roomTextField.isHidden = true
//        self.self.roomTextField.text = roomId
//        Logger.verbose("AccessToken = \(accessToken)")
//        Logger.verbose("AccessToken = \(roomId ?? "")")
//        self.title = "QuickStart"
//        self.messageLabel.adjustsFontSizeToFitWidth = true;
//        self.messageLabel.minimumScaleFactor = 0.75;
//        
//        if PlatformUtils.isSimulator {
//            self.previewView.removeFromSuperview()
//        } else {
//            // Preview our local camera track in the local video preview view.
//            self.startPreview()
//        }
//        
//        // Disconnect and mic button will be displayed when the Client is connected to a Room.
//        self.disconnectButton.isHidden = true
//        self.micButton.isHidden = true
//        
//        self.roomTextField.autocapitalizationType = .none
//        self.roomTextField.delegate = self
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        self.view.addGestureRecognizer(tap)
//        
//        if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
//                logMessage(messageText: message)
//                return
//            }
//        }
//        
//        self.prepareLocalMedia()
//        
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//        let connectOptions = TVIConnectOptions.init(token: accessToken) { (builder) in
//            
//            // Use the local media that we prepared earlier.
//            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [TVILocalAudioTrack]()
//            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [TVILocalVideoTrack]()
//            
//            // Use the preferred audio codec
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//                builder.preferredAudioCodecs = [preferredAudioCodec]
//            }
//            
//            // Use the preferred video codec
//            if let preferredVideoCodec = Settings.shared.videoCodec {
//                builder.preferredVideoCodecs = [preferredVideoCodec]
//            }
//            
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
//            
//            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
//            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
//            builder.roomName = self.roomId ?? ""
//            
//            
//        }
//        
//        // Connect to the Room using the options we provided.
//        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//        
//        logMessage(messageText: "Attempting to connect to room \(String(describing: self.roomTextField.text))")
//        
//        self.showRoomUI(inRoom: true)
//        
//        self.dismissKeyboard()
//        
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//
//    }
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return self.room != nil
//    }
//    
//    func setupRemoteVideoView()
//    {
//        // Creating `TVIVideoView` programmatically
//        self.remoteView = TVIVideoView.init(frame: CGRect.zero, delegate:self as! TVIVideoViewDelegate)
//        
//        self.view.insertSubview(self.remoteView!, at: 0)
//        
//        // `TVIVideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
//        // scaleAspectFit is the default mode when you create `TVIVideoView` programmatically.
//        self.remoteView!.contentMode = .scaleToFill;
//        
//        let centerX = NSLayoutConstraint(item: self.remoteView!,
//                                         attribute: NSLayoutConstraint.Attribute.centerX,
//                                         relatedBy: NSLayoutConstraint.Relation.equal,
//                                         toItem: self.view,
//                                         attribute: NSLayoutConstraint.Attribute.centerX,
//                                         multiplier: 1,
//                                         constant: 0);
//        self.view.addConstraint(centerX)
//        let centerY = NSLayoutConstraint(item: self.remoteView!,
//                                         attribute: NSLayoutConstraint.Attribute.centerY,
//                                         relatedBy: NSLayoutConstraint.Relation.equal,
//                                         toItem: self.view,
//                                         attribute: NSLayoutConstraint.Attribute.centerY,
//                                         multiplier: 1,
//                                         constant: 0);
//        self.view.addConstraint(centerY)
//        let width = NSLayoutConstraint(item: self.remoteView!,
//                                       attribute: NSLayoutConstraint.Attribute.width,
//                                       relatedBy: NSLayoutConstraint.Relation.equal,
//                                       toItem: self.view,
//                                       attribute: NSLayoutConstraint.Attribute.width,
//                                       multiplier: 1,
//                                       constant: 0);
//        self.view.addConstraint(width)
//        let height = NSLayoutConstraint(item: self.remoteView!,
//                                        attribute: NSLayoutConstraint.Attribute.height,
//                                        relatedBy: NSLayoutConstraint.Relation.equal,
//                                        toItem: self.view,
//                                        attribute: NSLayoutConstraint.Attribute.height,
//                                        multiplier: 1,
//                                        constant: 0);
//        
//        self.view.addConstraint(height)
//    }
//    
//    // MARK:- IBActions
//    @IBAction func connect(sender: AnyObject) {
//        // Configure access token either from server or manually.
//        // If the default wasn't changed, try fetching from server.
//        if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
//                logMessage(messageText: message)
//                return
//            }
//        }
//        
//        self.prepareLocalMedia()
//        
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//        let connectOptions = TVIConnectOptions.init(token: accessToken) { (builder) in
//            
//            // Use the local media that we prepared earlier.
//            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [TVILocalAudioTrack]()
//            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [TVILocalVideoTrack]()
//            
//            // Use the preferred audio codec
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//                builder.preferredAudioCodecs = [preferredAudioCodec]
//            }
//            
//            // Use the preferred video codec
//            if let preferredVideoCodec = Settings.shared.videoCodec {
//                builder.preferredVideoCodecs = [preferredVideoCodec]
//            }
//            
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
//            
//            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
//            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
//            builder.roomName = self.roomId ?? ""
//            
//            
//        }
//        
//        // Connect to the Room using the options we provided.
//        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//        
//        logMessage(messageText: "Attempting to connect to room \(String(describing: self.roomTextField.text))")
//        
//        self.showRoomUI(inRoom: true)
//        self.dismissKeyboard()
//    }
//    
//    @IBAction func disconnect(sender: AnyObject) {
//        self.room!.disconnect()
//        logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
//        self.deleteCall(callID: self.callid ?? 0)
//    }
//    
//    @IBAction func toggleMic(sender: AnyObject) {
//        if (self.localAudioTrack != nil) {
//            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
//            
//            // Update the button title
//            if (self.localAudioTrack?.isEnabled == true) {
//                self.micButton.setTitle("Mute", for: .normal)
//            } else {
//                self.micButton.setTitle("Unmute", for: .normal)
//            }
//        }
//    }
//    
//    // MARK:- Private
//    func startPreview() {
//        if PlatformUtils.isSimulator {
//            return
//        }
//        
//        // Preview our local camera track in the local video preview view.
//        camera = TVICameraCapturer(source: .frontCamera, delegate: self)
//        localVideoTrack = TVILocalVideoTrack.init(capturer: camera!, enabled: true, constraints: nil, name: "Camera")
//        if (localVideoTrack == nil) {
//            logMessage(messageText: "Failed to create video track")
//        } else {
//            // Add renderer to video track for local preview
//            localVideoTrack!.addRenderer(self.previewView)
//            
//            // logMessage(messageText: "Video track created")
//            
//            logMessage(messageText: "Press button to start video call")
//            
//            // We will flip camera on tap.
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.flipCamera))
//            self.previewView.addGestureRecognizer(tap)
//        }
//    }
//    
//    @objc func flipCamera() {
//        
//        if (self.camera?.source == .frontCamera) {
//            self.camera?.selectSource(.backCameraWide)
//        } else {
//            self.camera?.selectSource(.frontCamera)
//        }
//    }
//    
//    func prepareLocalMedia() {
//        
//        // We will share local audio and video when we connect to the Room.
//        
//        // Create an audio track.
//        if (localAudioTrack == nil) {
//            localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
//            
//            if (localAudioTrack == nil) {
//                logMessage(messageText: "Failed to create audio track")
//            }
//        }
//        
//        // Create a video track which captures from the camera.
//        if (localVideoTrack == nil) {
//            self.startPreview()
//        }
//    }
//    
//    // Update our UI based upon if we are in a Room or not
//    func showRoomUI(inRoom: Bool) {
//        self.connectButton.isHidden = inRoom
//        self.roomTextField.isHidden = inRoom
//        self.roomLine.isHidden = inRoom
//        self.roomLabel.isHidden = inRoom
//        self.micButton.isHidden = !inRoom
//        self.disconnectButton.isHidden = !inRoom
//        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
//        UIApplication.shared.isIdleTimerDisabled = inRoom
//        
//        // Show / hide the automatic home indicator on modern iPhones.
//        if #available(iOS 11.0, *) {
//            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
//        }
//    }
//    
//    @objc override func dismissKeyboard() {
//        if (self.roomTextField.isFirstResponder) {
//            self.roomTextField.resignFirstResponder()
//        }
//    }
//    
//    func cleanupRemoteParticipant() {
//        if ((self.remoteParticipant) != nil) {
//            if ((self.remoteParticipant?.videoTracks.count)! > 0) {
//                let remoteVideoTrack = self.remoteParticipant?.remoteVideoTracks[0].remoteTrack
//                remoteVideoTrack?.removeRenderer(self.remoteView!)
//                self.remoteView?.removeFromSuperview()
//                self.remoteView = nil
//            }
//        }
//        self.remoteParticipant = nil
//    }
//    
//    func logMessage(messageText: String) {
//        NSLog(messageText)
//        messageLabel.text = messageText
//    }
//    
//    private func deleteCall(callID:Int){
//        //        self.dismiss(animated: true, completion: nil)
//        let accessToken = AppInstance.instance.accessToken ?? ""
//      
//            Async.background({
//                VideoCallManager.instance.deleteVideoCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
//                    if success != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                Logger.debug("userList = \(success?.status ?? nil)")
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        })
//                    }else if sessionError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(sessionError?.errors?.errorText)
//                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                                
//                            }
//                        })
//                    }else {
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(error?.localizedDescription)
//                                Logger.error("error = \(error?.localizedDescription ?? "")")
//                            }
//                        })
//                    }
//                })
//            })
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
