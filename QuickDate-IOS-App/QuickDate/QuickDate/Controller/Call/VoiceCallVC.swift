//
import UIKit
import AgoraRtcKit
import Async
import QuickDateSDK

class VoiceCallVC:UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var controlButtonsView: UIView!
    
    var agoraKit: AgoraRtcEngineKit!
    var callID:Int? = 0
    var roomID:String? = ""
    var profileImageUrlString:String? = ""
    var usernameString:String? = ""
    private var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        initializeAgoraEngine()
        joinChannel()
        self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update1), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId:ControlSettings.agoraCallingToken, delegate: nil)
    }
    
    func joinChannel() {
        agoraKit.joinChannel(byToken: nil, channelId: "\(self.callID!)", info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
            self.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
        let callIdConverted = "\(callID!)"
      
        self.deleteCall(callID: callID ?? 0)
        }
        
    
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
//        hideControlButtons()
        UIApplication.shared.isIdleTimerDisabled = false
        
    }
    
    func hideControlButtons() {
        controlButtonsView.isHidden = true
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchSpeakerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.setEnableSpeakerphone(sender.isSelected)
    }
    private func setupUI(){
//        self.usernameLabel.text = self.usernameString ?? ""
        let url = URL.init(string:profileImageUrlString ?? "")
       self.profileImage.sd_setImage(with: url , placeholderImage:R.image.no_profile_image())
        self.profileImage.cornerRadiusV = self.profileImage.frame.height / 2
    }
    private func deleteCall(callID:Int){
        //        self.dismiss(animated: true, completion: nil)
        let accessToken = AppInstance.shared.accessToken ?? ""

        Async.background({
            AudioCallManager.instance.deleteAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                       
                            Logger.debug("userList = \(success?.status ?? nil)")
                            self.navigationController?.popViewController(animated: true)
                        
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
    
   @objc  func update1() {
        self.checkForCallAction(callID: self.callID!)
        
    }
    private func checkForCallAction(callID:Int){
        let accessToken = AppInstance.shared.accessToken
        
            Async.background({
                AudioCallManager.instance.checkForAudioCallAnswer(AccessToken: accessToken ?? "", callID: callID) {status, Success,
                    SessionError, error in
                    if status == 300{
                        self.navigationController?.popViewController(animated: true)
                        self.leaveChannel()
                        self.timer.invalidate()
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

