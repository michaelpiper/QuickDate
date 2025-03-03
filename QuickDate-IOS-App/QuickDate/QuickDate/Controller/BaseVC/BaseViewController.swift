
import UIKit
import Toast_Swift
import JGProgressHUD
import SwiftEventBus
import Async
import QuickDateSDK
import SDWebImage
import OneSignal

// TODO: Check this class and variables if sth is not necessary then delete it.

class BaseViewController: UIViewController {
    
    
    @IBOutlet var backgroundGradientShadow: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var progressHUD: JGProgressHUD?
    
    var alert:UIAlertController?
    var userId:String? = nil
    var sessionId:String? = nil
    var contactNameArray = [String]()
    var contactNumberArray = [String]()
    var deviceID:String? = ""
    private var timer = Timer()
    var isVoice:Bool? = false
    var callId:Int? = 0
    var oneSignalID:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()
        self.deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchNotification()
        }
        
        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            
        }
    }
    
    internal func createMainViewGradientLayer(to view: UIView, startColor: UIColor, endColor: UIColor) {
        view.removeGradientLayer()
        let gradientLayer = createGradient(colors: [startColor, endColor])
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func getUserSession(){
        Logger.verbose("getUserSession = \(UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session))")
        let localUserSessionData = UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session)
        
        self.userId = localUserSessionData[Local.USER_SESSION.User_id] as? String
        self.sessionId = localUserSessionData[Local.USER_SESSION.Access_token] as? String
    }
    
    
    internal func showProgressDialog(with text: String) {
        progressHUD = JGProgressHUD(style: .dark)
        progressHUD?.textLabel.text = text.localized
        progressHUD?.show(in: self.view)
    }
    
    internal func dismissProgressDialog(completionBlock: @escaping () ->()) {
        progressHUD?.dismiss()
        completionBlock()
        
    }
    
    func fetchStickers(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            //              Async.background({
            //                  StickerManager.instance.getSticker(AccessToken: accessToken, completionBlock: { (success, sessionError, error) in
            //                      if success != nil{
            //                          Async.main({
            //                              self.dismissProgressDialog {
            //                                  self.setStickersInCore(StickersArray: (success?.data)!)
            //
            //                              }
            //                          })
            //                      }else if sessionError != nil{
            //                          Async.main({
            //                              self.dismissProgressDialog {
            //
            //                                  self.view.makeToast(sessionError?.errors?.errorText ?? "")
            //                                  Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
            //                              }
            //                          })
            //                      }else {
            //                          Async.main({
            //                              self.dismissProgressDialog {
            //                                  self.view.makeToast(error?.localizedDescription ?? "")
            //                                  Logger.error("error = \(error?.localizedDescription ?? "")")
            //                              }
            //                          })
            //                      }
            //                  })
            //
            //              })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
    func fetchGifts(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            //              Async.background({
            //                  GiftManager.instance.getGift(AccessToken: accessToken, completionBlock: { (success, sessionError, error) in
            //                      if success != nil{
            //                          Async.main({
            //                              self.dismissProgressDialog {
            //                                  self.setGiftsInCore(giftsArray: (success?.data)!)
            //                              }
            //                          })
            //                      }else if sessionError != nil{
            //                          Async.main({
            //                              self.dismissProgressDialog {
            //
            //                                  self.view.makeToast(sessionError?.errors?.errorText ?? "")
            //                                  Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
            //                              }
            //                          })
            //                      }else {
            //                          Async.main({
            //                              self.dismissProgressDialog {
            //                                  self.view.makeToast(error?.localizedDescription ?? "")
            //                                  Logger.error("error = \(error?.localizedDescription ?? "")")
            //                              }
            //                          })
            //                      }
            //                  })
            //              })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
    //      private func setStickersInCore(StickersArray:[StickerModel.Datum]){
    //          Logger.verbose("Check = \(UserDefaults.standard.getStickers(Key: Local.STICKERS.Stickers))")
    //          let data = try? PropertyListEncoder().encode(StickersArray)
    //          UserDefaults.standard.setStickers(value: data!, ForKey: Local.STICKERS.Stickers)
    //      }
    //
    //      private func setGiftsInCore(giftsArray:[GiftModel.Datum]){
    //          Logger.verbose("Check = \(UserDefaults.standard.getGifts(Key: Local.GIFTS.Gifts))")
    //          let data = try? PropertyListEncoder().encode(giftsArray)
    //          UserDefaults.standard.setGifts(value: data!, ForKey: Local.GIFTS.Gifts)
    //      }
    private func fetchNotification(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                CheckCallManager.instance.checkCall(AccessToken: accessToken, Limit: 10, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.verbose("success data = \(success)")
                                if success != nil{
                                    var callStatus = ""
                                    self.isVoice  = success?.isvoiceCall ?? false
                                    self.callId = success?.callId?.toInt() ?? 0
                                    if success?.isvoiceCall ?? false{
                                        callStatus = "Voice Call"
                                    }else{
                                        callStatus = "Video Call"
                                    }
                                    let storyboards = UIStoryboard(name: "Call", bundle: nil)
                                    let vc = storyboards.instantiateViewController(identifier: "IncomingCallVC") as! IncomingCallController
                                    vc.callername = "\(success?.fullname ?? "") is calling"
                                    vc.callStatuss = callStatus
                                    vc.imageURL = success?.avatar ?? ""
                                    vc.call_id = success?.callId?.toInt() ?? 0
                                    vc.isVoice = success?.isvoiceCall ?? false
                                    vc.vc = self
                                    vc.delegate = self
                                    vc.modalTransitionStyle = .coverVertical
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                    
                                    self.alert = UIAlertController(title:callStatus , message: "\(success?.fullname ?? "") is calling you.", preferredStyle: .alert)
                                    let answer = UIAlertAction(title: "answer", style: .default, handler: { (action) in
                                        Logger.verbose("Answer Call")
                                        self.answerCall(callID:success?.callId?.toInt() ?? 0, callTypeBool: success?.isvoiceCall ?? false)
                                    })
                                    let decline = UIAlertAction(title: "decline", style: .destructive, handler: { (action) in
                                        Logger.verbose("decline Call")
                                        self.declineCall(callID: success?.callId?.toInt() ?? 0, callTypeBool: success?.isvoiceCall ?? false)
                                        
                                    })
                                    self.alert!.addAction(answer)
                                    self.alert!.addAction(decline)
                                    self.present(self.alert!, animated: true, completion: nil)
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                                    
                                    
                                }else{
                                    Logger.verbose("There is no call !!")
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
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
    private func declineCall(callID:Int,callTypeBool:Bool){
        let accessToken = AppInstance.shared.accessToken ?? ""
        if callTypeBool{
            Async.background({
                AudioCallManager.instance.declineAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.status ?? nil)")
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
        }else{
            Async.background({
                VideoCallManager.instance.declineVideoCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.status ?? nil)")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
        }
    }
    private func answerCall(callID:Int,callTypeBool:Bool){
        let accessToken = AppInstance.shared.accessToken ?? ""
        if callTypeBool{
            Async.background({
                AudioCallManager.instance.answerAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("Call Has been Answered )")
                                
                                let vc = R.storyboard.call.tempVCalling()
                                vc?.accessToken = success?.data.accessToken2 ?? ""
                                vc?.roomId = success?.data.roomName ?? ""
                                //                                vc?.callID = success?.data.id.toInt() ?? 0
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
        }else{
            Async.background({
                VideoCallManager.instance.answerVideoCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("Video call has been answered")
                                let vc = R.storyboard.call.tempVCalling()
                                vc?.accessToken = success?.data.accessToken ?? ""
                                vc?.roomId = success?.data.roomName ?? ""
                                //                                vc?.callid = success?.data.id.toInt() ?? 0
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
        }
    }
    private func checkForCallAction(callID:Int,callTypeBool:Bool){
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        if callTypeBool{
            Async.background({
                AudioCallManager.instance.checkForAudioCallAnswer(AccessToken: accessToken, callID: callID, completionBlock: { (status,success, sessionError, error) in
                    if status == 300{
                        Logger.verbose("Call Has Been Declined")
                        self.view.makeToast("Call Has Been Declined")
                    }else if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? nil)")
                                
                                if success?.status ==  200{
                                    self.view.makeToast("Call Has Been Answered")
                                    Logger.verbose("Call Has Been Answered")
                                    self.timer.invalidate()
                                    
                                }else if  success?.status == 400{
                                    //                                    self.alert.dismiss(animated: true, completion: nil)
                                    self.view.makeToast("No Answer")
                                    Logger.verbose("No Answer")
                                    self.timer.invalidate()
                                    
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
            
        }else{
            Async.background({
                VideoCallManager.instance.checkForVideoCallAnswer(AccessToken: accessToken, callID: callID, completionBlock: { (status,success, sessionError, error) in
                    if status == 400{
                        Logger.verbose("Call Has Been Declined")
                    }else if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? nil)")
                                if success?.status ==  200{
                                    Logger.verbose("Call Has Been Answered")
                                    self.timer.invalidate()
                                    
                                }else if  success?.status == 400{
                                    //                                    self.alert!.dismiss(animated: true, completion: nil)
                                    Logger.verbose("No Answer")
                                    self.timer.invalidate()
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
        }
        
    }
    @objc func update() {
        self.checkForCallAction(callID:self.callId ?? 0, callTypeBool: self.isVoice ?? false)
    }
}

extension BaseViewController:ReceiveCallDelegate{
    func receiveCall(status: Bool, profileImage: String, CallId: Int, AccessToken: String, RoomId: String, username: String, isVoice: Bool) {
        if isVoice{
            let vc = R.storyboard.call.voiceCallVC()
            //            vc?.accessToken = AccessToken
            vc?.roomID = RoomId
            vc?.callID = CallId
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = R.storyboard.call.videoCallVC()
            //            vc?.accessToken = AccessToken
            vc?.roomID = RoomId
            vc?.callId = CallId
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }
}

extension BaseViewController {
    //MARK: TabBar
    func showTabBar() {
        if let tabBarVC = navigationController?.tabBarController as? MainTabBarViewController {
            tabBarVC.setTabBarHidden(tabBarHidden: false, vc: self)
        }
    }
    
    func hideTabBar() {
        if let tabBarVC = navigationController?.tabBarController as? MainTabBarViewController {
            tabBarVC.setTabBarHidden(tabBarHidden: true, vc: self)
        }
    }
}
