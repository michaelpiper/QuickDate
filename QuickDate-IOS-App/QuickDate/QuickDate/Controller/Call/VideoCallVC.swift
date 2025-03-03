//
//
//import UIKit
//import TwilioVideo
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
//            print("Invalid token url, error = \(error)")
//            throw error
//        }
//        return token
//    }
//}
//
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
//
//
//class VideoCallVC: UIViewController {
//
//    // MARK:- View Controller Members
//
//    // Configure access token manually for testing, if desired! Create one manually in the console
//    // at https://www.twilio.com/console/video/runtime/testing-tools
//    var accessToken = ""
//
//    // Configure remote URL to fetch token from
//    var tokenUrl = "https://www.vivlio.cy"
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
//    // `VideoView` created from a storyboard
//    @IBOutlet weak var previewView: TVIVideoView!
//    @IBOutlet weak var disconnectButton: UIButton!
//    //    @IBOutlet weak var messageLabel: UILabel!
//    var messageLabel = UILabel()
//    //    @IBOutlet weak var roomLabel: UILabel!
//    @IBOutlet weak var micButton: UIButton!
//    var roomId:String? = ""
//    //There three must be hide when call connected
//    @IBOutlet weak var remoteImage: UIImageView!
//    //end comment
//    //@IBOutlet weak var roomNameLabel: UILabel!
//    // MARK:- UIViewController
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Logger.verbose("AccessToken = \(accessToken)")
//        Logger.verbose("AccessToken = \(roomId ?? "")")
//        if PlatformUtils.isSimulator {
//            self.previewView.removeFromSuperview()
//        } else {
//            // Preview our local camera track in the local video preview view.
//            self.startPreview()
//        }
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.connectVideoCall()
//    }
//
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
//        self.remoteView!.contentMode = .scaleAspectFill;
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
//    fileprivate func connectVideoCall() {
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
//        }
//
//        // Connect to the Room using the options we provided.
//        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//        self.showRoomUI(inRoom: true)
//        self.dismissKeyboard()
//    }
//
//    @IBAction func disconnect(sender: AnyObject) {
//        guard let dis = self.room else {
//            self.navigationController?.popToRootViewController(animated: true)
//            return
//        }
//        dis.disconnect()
//        logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
//
//        self.navigationController?.popToRootViewController(animated: true)
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
//
//    @IBAction func flipCamera(_ sender: UIButton) {
//        if (self.camera?.source == .frontCamera) {
//            self.camera?.selectSource(.backCameraWide)
//        } else {
//            self.camera?.selectSource(.frontCamera)
//        }
//    }
//
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
//            self.previewView.contentMode = .scaleAspectFill
//            localVideoTrack!.addRenderer(self.previewView)
//
//            // logMessage(messageText: "Video track created")
//
//            logMessage(messageText: "Press button to start video call")
//
//            // We will flip camera on tap.
////            let tap = UITapGestureRecognizer(target: self, action: #selector(self.flipCamera))
////            self.previewView.addGestureRecognizer(tap)
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
//
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
//}
//
//// MARK:- RoomDelegate
//// MARK: TVIRoomDelegate
//extension VideoCallVC : TVIRoomDelegate {
//
//    func didConnect(to room: TVIRoom) {
//
//        // At the moment, this example only supports rendering one Participant at a time.
//
//        //logMessage(messageText: "Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
//
//        logMessage(messageText: "Connecting...")
////        self.remoteImage.alpha = 0
//        //Please wait until (user name) accept your request.
//
//        if (room.remoteParticipants.count > 0) {
//            self.remoteParticipant = room.remoteParticipants[0]
//            self.remoteParticipant?.delegate = self
//        }
//    }
//
//    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
//        logMessage(messageText: "Disconncted from room \(room.name), error = \(String(describing: error))")
//
//        print("Disconncted from room \(room.name), error = \(String(describing: error))")
//
//        UserDefaults.standard.set(nil , forKey: "voip")
//
//        self.navigationController?.popToRootViewController(animated: true)
//
//        self.cleanupRemoteParticipant()
//        self.room = nil
//
//        self.showRoomUI(inRoom: false)
//    }
//
//    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
//        logMessage(messageText: "Failed to connect to room with error")
//
//
//        print(error)
//        print("Failed to connect to room with error")
//        self.room = nil
//
//        self.showRoomUI(inRoom: false)
//    }
//
//    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
//        if (self.remoteParticipant == nil) {
//            self.remoteParticipant = participant
//            self.remoteParticipant?.delegate = self
//        }
//        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//
//
//    }
//
//    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
//        if (self.remoteParticipant == participant) {
//            cleanupRemoteParticipant()
//        }
//        self.navigationController?.popToRootViewController(animated: true)
//        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
//        print("Room \(room.name), Participant \(participant.identity) disconnected")
//
//        UserDefaults.standard.set(nil , forKey: "voip")
//    }
//}
//
//// MARK: TVIRemoteParticipantDelegate
//extension VideoCallVC : TVIRemoteParticipantDelegate {
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
//
//        // Remote Participant has offered to share the video Track.
//
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
//        print("Participant \(participant.identity) published \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
//
//        // Remote Participant has stopped sharing the video Track.
//
//        //logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
//        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
//
//        // Remote Participant has offered to share the audio Track.
//
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
//        print("Participant \(participant.identity) published \(publication.trackName) audio track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
//
//        // Remote Participant has stopped sharing the audio Track.
//
//        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//    }
//
//    func subscribed(to videoTrack: TVIRemoteVideoTrack,
//                    publication: TVIRemoteVideoTrackPublication,
//                    for participant: TVIRemoteParticipant) {
//
//        // We are subscribed to the remote Participant's audio Track. We will start receiving the
//        // remote Participant's video frames now.
//
//        // logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//
//        logMessage(messageText: "")
//
//        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//
//        if (self.remoteParticipant == participant) {
//            setupRemoteVideoView()
//            videoTrack.addRenderer(self.remoteView!)
//        }
//    }
//
//    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
//                      publication: TVIRemoteVideoTrackPublication,
//                      for participant: TVIRemoteParticipant) {
//
//        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
//        // remote Participant's video.
//
//        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
//
//        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
//
//        if (self.remoteParticipant == participant) {
//            videoTrack.removeRenderer(self.remoteView!)
//            self.remoteView?.removeFromSuperview()
//            self.remoteView = nil
//        }
//    }
//
//    func subscribed(to audioTrack: TVIRemoteAudioTrack,
//                    publication: TVIRemoteAudioTrackPublication,
//                    for participant: TVIRemoteParticipant) {
//
//        // We are subscribed to the remote Participant's audio Track. We will start receiving the
//        // remote Participant's audio now.
//
//        //logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//
//        logMessage(messageText: "")
//
//        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//
//        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//
//
//    }
//
//    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
//                      publication: TVIRemoteAudioTrackPublication,
//                      for participant: TVIRemoteParticipant) {
//
//        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
//        // remote Participant's audio.
//
//        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
//        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
//
//        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
//
//        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
//
//        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
//    }
//
//    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
//                           error: Error,
//                           for participant: TVIRemoteParticipant) {
//        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//    }
//
//    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
//                           error: Error,
//                           for participant: TVIRemoteParticipant) {
//        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//    }
//}
//
//
//
//// MARK: TVIVideoViewDelegate
//extension VideoCallVC : TVIVideoViewDelegate {
//    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
//        self.view.setNeedsLayout()
//    }
//}
//
//
//// MARK: TVICameraCapturerDelegate
//extension VideoCallVC : TVICameraCapturerDelegate {
//    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
//        logMessage(messageText: "Camera source failed with error: \(capturer.isCapturing)")
//
//    }
//}
//
//import TwilioVideo
//import TwilioVoice
//import UIKit
//import Async
//class VoiceCallVC: BaseVC,CallDelegate {
//
//    // MARK:- View Controller Members
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
//    var camera: TVICameraSource?
//    var localAudioTrack: TVILocalAudioTrack!
//    var localVideoTrack: TVILocalVideoTrack!
//
//    // Audio Sinks
//
//    // MARK:- UI Element Outlets and handles
//
//    @IBOutlet weak var connectButton: UIButton!
//    @IBOutlet weak var disconnectButton: UIButton!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var remoteViewStack: UIStackView!
//    @IBOutlet weak var roomTextField: UITextField!
//    @IBOutlet weak var roomLine: UIView!
//    @IBOutlet weak var roomLabel: UILabel!
//
//    // Speech UI
//    weak var dimmingView: UIView!
//    weak var speechLabel: UILabel!
//
//    var messageTimer: Timer!
//
//    let kPreviewPadding = CGFloat(10)
//    let kTextBottomPadding = CGFloat(4)
//    let kMaxRemoteVideos = Int(2)
//    var roomId:String? = ""
//    var callID:Int? = 0
//
//    var callKitCompletionCallback: ((Bool) -> Void)? = nil
//    var audioDevice = DefaultAudioDevice()
//    var activeCallInvites: [String: CallInvite]! = [:]
//    var activeCalls: [String: Call]! = [:]
//
//    // activeCall represents the last connected call
//    var activeCall: Call? = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.connectButton.isHidden = true
//        self.roomTextField.isHidden = true
//        self.roomTextField.text = self.roomId ?? ""
////        title = "AudioSink Example"
//        disconnectButton.isHidden = true
//        disconnectButton.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .disabled)
//        connectButton.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .disabled)
//        roomTextField.autocapitalizationType = .none
//        roomTextField.delegate = self
//
//        if (recordAudio == false) {
//            navigationItem.leftBarButtonItem = nil
//        }
//
//        prepareLocalMedia()
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
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//
//        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
//            builder.params = ["to": self.roomId ?? ""]
////            builder.uuid = uuid
//
//        }
//
//        let call = TwilioVoice.connect(options: connectOptions, delegate: self)
//        activeCall = call
////        activeCalls[call.uuid!.uuidString] = call
//
//
////        let connectOptions = TVIConnectOptions(token: accessToken) { (builder) in
////
////            if let audioTrack = self.localAudioTrack {
////                builder.audioTracks = [audioTrack]
////            }
////            if let videoTrack = self.localVideoTrack {
////                builder.videoTracks = [videoTrack]
////            }
////
////            // Use the preferred codecs
////            if let preferredAudioCodec = Settings.shared.audioCodec {
////                builder.preferredAudioCodecs = [preferredAudioCodec]
////            }
////            if let preferredVideoCodec = Settings.shared.videoCodec {
////                builder.preferredVideoCodecs = [preferredVideoCodec]
////            }
////
////            // Use the preferred encoding parameters
////            if let encodingParameters = Settings.shared.getEncodingParameters() {
////                builder.encodingParameters = encodingParameters
////            }
////
////            // Use the preferred signaling region
////
////
////            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
////            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
////            builder.roomName = self.roomId ?? ""
////        }
//
//        // Connect to the Room using the options we provided.
////        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//
////        logMessage(messageText: "Connecting to \(roomTextField.text ?? "a Room")")
//
////        self.showRoomUI(inRoom: true)
//        self.dismissKeyboard()
//
//    }
//
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
////        activeCalls.removeValue(forKey: call.uuid!.uuidString)
//    }
//
//
//
//
////    func showMicrophoneAccessRequest(_ uuid: UUID, _ handle: String) {
////        let alertController = UIAlertController(title: "Voice Quick Start",
////                                                message: "Microphone permission not granted",
////                                                preferredStyle: .alert)
////
////        let continueWithoutMic = UIAlertAction(title: "Continue without microphone", style: .default) { [weak self] _ in
//////            self?.performStartCallAction(uuid: uuid, handle: handle)
////        }
////
////        let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
////            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
////                                      options: [UIApplicationOpenURLOptionUniversalLinksOnly: false],
////                                      completionHandler: nil)
////        }
////
////        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
//////            self?.toggleUIState(isEnabled: true, showCallControl: false)
//////            self?.stopSpin()
////        }
////
////        [continueWithoutMic, goToSettings, cancel].forEach { alertController.addAction($0) }
////
////        present(alertController, animated: true, completion: nil)
////    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
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
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//        let connectOptions = TVIConnectOptions(token: accessToken) { (builder) in
//
//            if let audioTrack = self.localAudioTrack {
//                builder.audioTracks = [audioTrack]
//            }
//            if let videoTrack = self.localVideoTrack {
//                builder.videoTracks = [videoTrack]
//            }
//
//            // Use the preferred codecs
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//                builder.preferredAudioCodecs = [preferredAudioCodec]
//            }
//            if let preferredVideoCodec = Settings.shared.videoCodec {
//                builder.preferredVideoCodecs = [preferredVideoCodec]
//            }
//
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
//
//            // Use the preferred signaling region
//
//
//            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
//            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
//            builder.roomName = self.roomId ?? ""
//        }
//
//        // Connect to the Room using the options we provided.
//        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//
//        logMessage(messageText: "Connecting to \(roomTextField.text ?? "a Room")")
//
//        self.showRoomUI(inRoom: true)
//        self.dismissKeyboard()
//    }
//
//    @IBAction func disconnect(sender: UIButton) {
//        if let room = self.room {
//            logMessage(messageText: "Disconnecting from \(room.name)")
//            room.disconnect()
//            sender.isEnabled = false
//            self.deleteCall(callID: self.callID ?? 0)
//        }
//
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        var bottomRight = CGPoint(x: view.bounds.width, y: view.bounds.height)
//        var layoutWidth = view.bounds.width
//        if #available(iOS 11.0, *) {
//            // Ensure the preview fits in the safe area.
//            let safeAreaGuide = self.view.safeAreaLayoutGuide
//            let layoutFrame = safeAreaGuide.layoutFrame
//            bottomRight.x = layoutFrame.origin.x + layoutFrame.width
//            bottomRight.y = layoutFrame.origin.y + layoutFrame.height
//            layoutWidth = layoutFrame.width
//        }
//        // Layout the speech label.
//        if let speechLabel = self.speechLabel {
//            speechLabel.preferredMaxLayoutWidth = layoutWidth - (kPreviewPadding * 2)
//
//            let constrainedSize = CGSize(width: view.bounds.width,
//                                         height: view.bounds.height)
//            let fittingSize = speechLabel.sizeThatFits(constrainedSize)
//            let speechFrame = CGRect(x: 0,
//                                     y: bottomRight.y - fittingSize.height - kTextBottomPadding,
//                                     width: view.bounds.width,
//                                     height: (view.bounds.height - bottomRight.y) + fittingSize.height + kTextBottomPadding)
//            speechLabel.frame = speechFrame.integral
//        }
//
//        // Layout the preview view.
//        if let previewView = self.camera?.previewView {
//            let dimensions = previewView.videoDimensions
//            var previewBounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160))
//            previewBounds = AVMakeRect(aspectRatio: CGSize(width: CGFloat(dimensions.width),
//                                                           height: CGFloat(dimensions.height)),
//                                       insideRect: previewBounds)
//
//            previewBounds = previewBounds.integral
//            previewView.bounds = previewBounds
//            previewView.center = CGPoint(x: bottomRight.x - previewBounds.width / 2 - kPreviewPadding,
//                                         y: bottomRight.y - previewBounds.height / 2 - kPreviewPadding)
//
//            if let speechLabel = self.speechLabel {
//                previewView.center.y = speechLabel.frame.minY - (2.0 * kPreviewPadding) - (previewBounds.height / 2.0);
//            }
//        }
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
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if (newCollection.horizontalSizeClass == .regular ||
//            (newCollection.horizontalSizeClass == .compact && newCollection.verticalSizeClass == .compact)) {
//            remoteViewStack.axis = .horizontal
//        } else {
//            remoteViewStack.axis = .vertical
//        }
//    }
//
//    // Update our UI based upon if we are in a Room or not
//    func showRoomUI(inRoom: Bool) {
//        self.connectButton.isHidden = inRoom
//        self.connectButton.isEnabled = !inRoom
//        self.roomTextField.isHidden = inRoom
//        self.roomLine.isHidden = inRoom
//        self.roomLabel.isHidden = inRoom
//        self.disconnectButton.isHidden = !inRoom
//        self.disconnectButton.isEnabled = inRoom
//        UIApplication.shared.isIdleTimerDisabled = inRoom
//        if #available(iOS 11.0, *) {
//            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
//        }
//        self.setNeedsStatusBarAppearanceUpdate()
//
//        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
//    }
//
//    func showSpeechRecognitionUI(view: UIView, message: String) {
//        // Create a dimmer view for the Participant being recognized.
//        let dimmer = UIView(frame: view.bounds)
//        dimmer.alpha = 0
//        dimmer.backgroundColor = UIColor(white: 1, alpha: 0.26)
//        dimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(dimmer)
//        self.dimmingView = dimmer
//
//        // Create a label which will be added to the stack and display recognized speech.
//        let messageLabel = UILabel()
//        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        messageLabel.textColor = UIColor.white
//        messageLabel.backgroundColor = UIColor(red: 226/255, green: 29/255, blue: 37/255, alpha: 1)
//        messageLabel.alpha = 0
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = NSTextAlignment.center
//
//        self.view.addSubview(messageLabel)
//        self.speechLabel = messageLabel
//
//        // Force a layout to position the speech label before animations.
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
//
//        UIView.animate(withDuration: 0.4, animations: {
//            self.view.setNeedsLayout()
//
//            messageLabel.text = message
//            dimmer.alpha = 1.0
//            messageLabel.alpha = 1.0
//            view.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
//            self.disconnectButton.alpha = 0
//
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func hideSpeechRecognitionUI(view: UIView) {
//        guard let dimmer = self.dimmingView else {
//            return
//        }
//
//        self.view.setNeedsLayout()
//
//        UIView.animate(withDuration: 0.4, animations: {
//            dimmer.alpha = 0.0
//            view.transform = CGAffineTransform.identity
//            self.speechLabel?.alpha = 0.0
//            self.disconnectButton.alpha = 1.0
//            self.view.layoutIfNeeded()
//        }, completion: { (complete) in
//            if (complete) {
//                self.speechLabel?.removeFromSuperview()
//                self.speechLabel = nil
//                dimmer.removeFromSuperview()
//                self.dimmingView = nil
//                UIView.animate(withDuration: 0.4, animations: {
//                    self.view.setNeedsLayout()
//                    self.view.layoutIfNeeded()
//                })
//            }
//        })
//    }
//
//    override func dismissKeyboard() {
//        if (self.roomTextField.isFirstResponder) {
//            self.roomTextField.resignFirstResponder()
//        }
//    }
//
//    func logMessage(messageText: String) {
//        NSLog(messageText)
//        messageLabel.text = messageText
//
//        if (messageLabel.alpha < 1.0) {
//            self.messageLabel.isHidden = false
//            UIView.animate(withDuration: 0.4, animations: {
//                self.messageLabel.alpha = 1.0
//            })
//        }
//
//        // Hide the message with a delay.
//        self.messageTimer?.invalidate()
//        let timer = Timer(timeInterval: TimeInterval(6), repeats: false) { (timer) in
//            if (self.messageLabel.isHidden == false) {
//                UIView.animate(withDuration: 0.6, animations: {
//                    self.messageLabel.alpha = 0
//                }, completion: { (complete) in
//                    if (complete) {
//                        self.messageLabel.isHidden = true
//                    }
//                })
//            }
//        }
//
//        self.messageTimer = timer
//        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
//    }
//
//    // MARK:- Speech Recognition
//
//
//
//
//
//
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
//    }
//
//
////    func prepareLocalMedia() {
////        // Create an audio track.
////        localAudioTrack = TVILocalAudioTrack()
////        if (localAudioTrack == nil) {
////            logMessage(messageText: "Failed to create audio track!")
////            return
////        }
////
////        // Create a video track which captures from the front camera.
////        guard let frontCamera = CameraSource.captureDevice(position: .front) else {
////            logMessage(messageText: "Front camera is not available, using microphone only.")
////            return
////        }
////
////        // We will render the camera using CameraPreviewView.
////        let cameraSourceOptions = CameraSourceOptions() { (builder) in
////            builder.enablePreview = true
////        }
////
////        self.camera = TVICameraSource(options: cameraSourceOptions, delegate: self)
////        if let camera = self.camera {
////            localVideoTrack = LocalVideoTrack(source: camera)
////            logMessage(messageText: "Video track created.")
////
////            if let preview = camera.previewView {
////                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.recognizeLocalAudio))
////                preview.addGestureRecognizer(tap)
////                view.addSubview(preview);
////            }
////
////            camera.startCapture(device: frontCamera) { (captureDevice, videoFormat, error) in
////                if let error = error {
////                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
////                    self.camera?.previewView?.removeFromSuperview()
////                } else {
////                    // Layout the camera preview with dimensions appropriate for our orientation.
////                    self.view.setNeedsLayout()
////                }
////            }
////        }
////    }
//
////    func setupRemoteVideoView(publication: RemoteVideoTrackPublication) {
////        // Create a `VideoView` programmatically, and add to our `UIStackView`
////        if let remoteView = VideoView(frame: CGRect.zero, delegate:nil) {
////            // We will bet that a hash collision between two unique SIDs is very rare.
////            remoteView.tag = publication.trackSid.hashValue
////
////            // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit.
////            // scaleAspectFit is the default mode when you create `VideoView` programmatically.
////            remoteView.contentMode = .scaleAspectFit;
////
////            // Double tap to change the content mode.
////            let recognizerDoubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.changeRemoteVideoAspect))
////            recognizerDoubleTap.numberOfTapsRequired = 2
////            remoteView.addGestureRecognizer(recognizerDoubleTap)
////
////            // Single tap to recognize remote audio.
////            let recognizerTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.recognizeRemoteAudio))
////            recognizerTap.require(toFail: recognizerDoubleTap)
////            remoteView.addGestureRecognizer(recognizerTap)
////
////            // Start rendering, and add to our stack.
////            publication.remoteTrack?.addRenderer(remoteView)
////            self.remoteViewStack.addArrangedSubview(remoteView)
////        }
////    }
//
////    func removeRemoteVideoView(publication: RemoteVideoTrackPublication) {
////        let viewTag = publication.trackSid.hashValue
////        if let remoteView = self.remoteViewStack.viewWithTag(viewTag) {
////            // Stop rendering, we don't want to receive any more frames.
////            publication.remoteTrack?.removeRenderer(remoteView as! VideoRenderer)
////            // Automatically removes us from the UIStackView's arranged subviews.
////            remoteView.removeFromSuperview()
////        }
////    }
//
//    @objc func changeRemoteVideoAspect(gestureRecognizer: UIGestureRecognizer) {
//        guard let remoteView = gestureRecognizer.view else {
//            print("Couldn't find a view attached to the tap recognizer. \(gestureRecognizer)")
//            return;
//        }
//
//        if (remoteView.contentMode == .scaleAspectFit) {
//            remoteView.contentMode = .scaleAspectFill
//        } else {
//            remoteView.contentMode = .scaleAspectFit
//        }
//    }
//
//}
//
//// MARK:- UITextFieldDelegate
//extension VoiceCallVC : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.connect(sender: textField)
//        return true
//    }
//}
//
//// MARK:- RoomDelegate
//extension VoiceCallVC : TVIRoomDelegate {
//
////    func didConnect(to room: TVIRoom) {
////
////        // At the moment, this example only supports rendering one Participant at a time.
////
////        //logMessage(messageText: "Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
////
////        logMessage(messageText: "Connecting...")
////
////
////        // logMessage(messageText: "Please wait until \(self.selectedUserName!) accept your request...")
////
////        //Please wait until (user name) accept your request.
////
////
////    }
//
//    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
//        logMessage(messageText: "Disconncted from room \(room.name), error = \(String(describing: error))")
//
//        print("Disconncted from room \(room.name), error = \(String(describing: error))")
//
//        UserDefaults.standard.set(nil , forKey: "voip")
//
//        self.navigationController?.popViewController(animated: true)
//
//        self.room = nil
//
////        self.showRoomUI(inRoom: false)
//        self.deleteCall(callID: self.callID ?? 0)
//    }
//
//    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
//        logMessage(messageText: "Failed to connect to room with error")
//
//
//        print(error)
//        print("Failed to connect to room with error")
//        self.room = nil
//
////        self.showRoomUI(inRoom: false)
//        self.deleteCall(callID: self.callID ?? 0)
//
//    }
//
//    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
//
//        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//
//
//    }
//
//    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
//
//        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
//        print("Room \(room.name), Participant \(participant.identity) disconnected")
//
//        UserDefaults.standard.set(nil , forKey: "voip")
//    }
//}
//
//// MARK:- RemoteParticipantDelegate
//extension VoiceCallVC : TVIRemoteParticipantDelegate {
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
//
//        // Remote Participant has offered to share the video Track.
//
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
//        print("Participant \(participant.identity) published \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
//
//        // Remote Participant has stopped sharing the video Track.
//
//        //logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
//        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
//
//        // Remote Participant has offered to share the audio Track.
//
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
//        print("Participant \(participant.identity) published \(publication.trackName) audio track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
//
//        // Remote Participant has stopped sharing the audio Track.
//
//        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//    }
//
//    func subscribed(to videoTrack: TVIRemoteVideoTrack,
//                    publication: TVIRemoteVideoTrackPublication,
//                    for participant: TVIRemoteParticipant) {
//
//        // We are subscribed to the remote Participant's audio Track. We will start receiving the
//        // remote Participant's video frames now.
//
//        // logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//
//        logMessage(messageText: "")
//
//        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//
//
//    }
//
//    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
//                      publication: TVIRemoteVideoTrackPublication,
//                      for participant: TVIRemoteParticipant) {
//
//        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
//        // remote Participant's video.
//
//        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
//
//        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
//
//
//    }
//
//    func subscribed(to audioTrack: TVIRemoteAudioTrack,
//                    publication: TVIRemoteAudioTrackPublication,
//                    for participant: TVIRemoteParticipant) {
//
//        // We are subscribed to the remote Participant's audio Track. We will start receiving the
//        // remote Participant's audio now.
//
//        //logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//
//        logMessage(messageText: "")
//
//        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//
//        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//
//
//    }
//
//    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
//                      publication: TVIRemoteAudioTrackPublication,
//                      for participant: TVIRemoteParticipant) {
//
//        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
//        // remote Participant's audio.
//
//        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
//        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
//
//        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
//
//        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
//
//        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
//    }
//
//    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
//                           error: Error,
//                           for participant: TVIRemoteParticipant) {
//        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//    }
//
//    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
//                           error: Error,
//                           for participant: TVIRemoteParticipant) {
//        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//    }
//}
//
//// MARK: TVIVideoViewDelegate
//extension VoiceCallVC : TVIVideoViewDelegate {
//    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
//        self.view.setNeedsLayout()
//    }
//}
//
//
//// MARK: TVICameraCapturerDelegate
//extension VoiceCallVC : TVICameraCapturerDelegate {
//    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
//        logMessage(messageText: "Camera source failed with error: \(capturer.isCapturing)")
//
//    }
//}

import AgoraRtcKit
import Async
import QuickDateSDK

class VideoCallVC: UIViewController {
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var controlButtons: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedBg: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
    
    var agoraKit: AgoraRtcEngineKit!
    
    var recipientId:String? = ""
    var callId:Int? = 0
    var roomID:String? = ""
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        hideVideoMuted()
        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo()
        joinChannel()
        Logger.verbose("Room ID: = \(self.roomID!)")
          self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    //cea80c3b9a744f69ba90a68d07ca9167
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId:ControlSettings.agoraCallingToken , delegate: self)
    }

    func setupVideo() {
        agoraKit.enableVideo()  // Default mode is disableVideo
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative, mirrorMode: AgoraVideoMirrorMode.disabled))
    }
    
 
    func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    
    func joinChannel() {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: nil, channelId: "\(callId!)", info:nil, uid:0) {[weak self] (sid, uid, elapsed) -> Void in
            // Join channel "demoChannel1"
            if let weakSelf = self {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
    }
    

    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
        
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        hideControlButtons()
        UIApplication.shared.isIdleTimerDisabled = false
        remoteVideo.removeFromSuperview()
        localVideo.removeFromSuperview()
        let callIdConverted = "\(callId!)"
            self.deleteCall(callID: callId ?? 0)
    }
    func setupButtons() {
        perform(#selector(hideControlButtons), with:nil, afterDelay:8)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ViewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc func hideControlButtons() {
        controlButtons.isHidden = true
    }
    
    @objc func ViewTapped() {
        if (controlButtons.isHidden) {
            controlButtons.isHidden = false;
            perform(#selector(hideControlButtons), with:nil, afterDelay:8)
        }
    }
    
    func resetHideButtonsTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(hideControlButtons), with:nil, afterDelay:8)
    }
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
        resetHideButtonsTimer()
    }
    

    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalVideoStream(sender.isSelected)
        localVideo.isHidden = sender.isSelected
        localVideoMutedBg.isHidden = !sender.isSelected
        localVideoMutedIndicator.isHidden = !sender.isSelected
        resetHideButtonsTimer()
    }
    
    func hideVideoMuted() {
        remoteVideoMutedIndicator.isHidden = true
        localVideoMutedBg.isHidden = true
        localVideoMutedIndicator.isHidden = true
    }
    

    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.switchCamera()
        resetHideButtonsTimer()
    }
    private func deleteCall(callID:Int){
        //        self.dismiss(animated: true, completion: nil)
        let accessToken = AppInstance.shared.accessToken ?? ""

        Async.background({
            VideoCallManager.instance.deleteVideoCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                       
                            Logger.debug("userList = \(success?.status ?? nil)")
//                        self.checkForCallAction(callID: self.callId ?? 0)
//                            self.dismiss(animated: true, completion: nil)
                        
                    })
                }else if sessionError != nil{
                    Async.main({
                       
                            self.view.makeToast(sessionError?.errors?.errorText)
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")

                        
                    })
                }else {
                    Async.main({
                        
                            self.view.makeToast(error?.localizedDescription)
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        
                    })
                }
            })

        })
    }
    
    @objc func update() {
        self.checkForCallAction(callID: self.callId!)
        
    }
    private func checkForCallAction(callID:Int){
        let accessToken = AppInstance.shared.accessToken
        
            Async.background({
                VideoCallManager.instance.checkForVideoCallAnswer(AccessToken: accessToken ?? "", callID: callID) {status,  Success, SessionError, error in
                    if status == 300{
                        self.dismiss(animated: true) {
                            self.leaveChannel()
                            self.timer.invalidate()
                        }
                        print("Call Has Been Declined")
                    }else if Success != nil{
                        Async.main({
                                print("userList = \(Success?.status ?? nil)")
                             
                                 if Success?.status == 200{
                                    print("Call Has Been Answered")
                                }
                            
                        })
                    }else if SessionError != nil{
                        Async.main({
                        
                                self.view.makeToast(SessionError?.errors?.errorText)
                                print("sessionError = \(SessionError?.errors?.errorText ?? "")")
                                
                            
                        })
                    }else {
                        Async.main({
                          
                                self.view.makeToast(error?.localizedDescription)
                                print("error = \(error?.localizedDescription)")
                            
                        })
                    }
                }
            })
        
    }
}

extension VideoCallVC: AgoraRtcEngineDelegate {

    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        if (remoteVideo.isHidden) {
            remoteVideo.isHidden = false
        }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .adaptive
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    

    internal func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        self.remoteVideo.isHidden = true
    }
    

    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        remoteVideo.isHidden = muted
        remoteVideoMutedIndicator.isHidden = !muted
    }
}
