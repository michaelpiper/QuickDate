//
//  LoginViewController+SocialLogin.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 8.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import Async
import FBSDKLoginKit
import QuickDateSDK

extension LoginViewController {
    
    // MARK: - Facebook
    internal func facebookLogin() {
        
        guard Connectivity.isConnectedToNetwork() else {
            self.dismissProgressDialog {
                
                self.showOKAlertOverNavBar(title: "Internet Error".localized,
                                           message: nil)
            }
            return
        }
        
        let fbLoginManager: LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["email"], from: self) { [self] (result, error) in
            // 1. Check Error
            if let error = error {
                showOKAlertOverNavBar(title: "Something Wrong".localized,
                                      message: error.localizedDescription)
                return
            }
            // 2. Check Result
            guard let result = result else {
                showOKAlertOverNavBar(title: "Something Wrong".localized,
                                      message: "Could you please try again later?".localized)
                return
            }
            
            self.showProgressDialog(with: "Loading...")
            let fbLoginResult: LoginManagerLoginResult = result
            
            if result.isCancelled {
                dismissProgressDialog { Logger.verbose("result.isCancelled = \(result.isCancelled)") }; return
            }
            
            guard fbLoginResult.grantedPermissions.contains("email") else {
                dismissProgressDialog { Logger.verbose("Something wrong...") }; return
            }
            
            guard (AccessToken.current) != nil else {
                dismissProgressDialog { Logger.verbose("AccessToken.current is nil") }; return
            }
            
            facebookGraphRequest()
        }
    }
    
    internal func facebookGraphRequest() {
        GraphRequest(
            graphPath: "me",
            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            .start(completionHandler: { (connection, result, error) -> Void in
                
                if let error = error {
                    self.dismissProgressDialog { Logger.verbose(error) }; return
                }
                
                guard let dict = result as? [String : AnyObject] else {
                    self.dismissProgressDialog { Logger.verbose("Something wrong...") }; return
                }
                Logger.debug("result = \(dict)")
                
                guard (dict["first_name"] as? String) != nil else {return}
                guard (dict["last_name"] as? String) != nil else {return}
                guard (dict["email"] as? String) != nil else {return}
                
                let accessToken = AccessToken.current?.tokenString
                Logger.verbose("FaceBookaccessToken = \(String(describing: accessToken))")
                
                self.dismissProgressDialog {
                    Logger.verbose("FaceBookaccessToken = \(String(describing: accessToken))")
                }
                
                let FBAccessToken = accessToken ?? ""
                let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
                
                Async.background( { [self] in
                    
                    userManager.socialLogin(accessToken: FBAccessToken,
                                            Provider: "facebook",
                                            DeviceId:  deviceID,
                                            googleApiKey: "") { (success, sessionError, error) in
                        
                        if let error = error {
                            
                            Async.main({
                                self.dismissProgressDialog {
                                    showOKAlertOverNavBar(title: "Security".localized,
                                                          message: error.localizedDescription)
                                }
                            })
                            
                        } else if let sessionError = sessionError {
                            Async.main{
                                self.dismissProgressDialog {
                                    let errors = sessionError["errors"] as? [String:Any]
                                    let errorText = errors?["error_text"] as? String
                                    showOKAlertOverNavBar(title: "Security".localized,
                                                          message: errorText ?? "")
                                }
                            }
                        } else if let success = success {
                            Async.main{
                                self.dismissProgressDialog{
                                    let message = success["message"] as? String
                                    let data = success["data"] as? [String:Any]
                                    Logger.verbose("Success = \(message ??  "")")
                                    let accessToken  = data?["access_token"] as? String
                                    let userID = data?["user_id"] as? Int
                                    Logger.verbose("Access Token = \(accessToken ?? "")")
                                    Logger.verbose("userID = \(userID  ?? 0)")
                                    
                                    self.view.makeToast("Login Successful...".localized)
                                    self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
                                    self.appManager.reloadAllDataFromRemoteDatabase()
                                    self.setDidLogUserIn(to: true)
                                    self.handleGiftsAndStickers()
                                    self.appNavigator.dashboardNavigate(to: .intro)
                                }
                            }
                        }
                    }
                })
                Logger.verbose("FBSDKAccessToken.current() = \(AccessToken.current?.tokenString ?? "")")
            })
    }
    
    // MARK: - Google
    
    internal func googleLogin(access_Token: String) {
        
        self.showProgressDialog(with: "Loading...".localized)
        
        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
        
        guard Connectivity.isConnectedToNetwork() else {
            self.showOKAlertOverNavBar(title: "Internet Error".localized,
                                       message: nil)
            return
        }
        
        Async.background {
            
            self.userManager.socialLogin(accessToken: access_Token,
                                             Provider: "google",
                                             DeviceId: deviceID,
                                             googleApiKey: ControlSettings.googleApiKey,
                                             completionBlock: { (success, sessionError, error) in
                
                if let success = success {
                    
                    Async.main {
                        
                        self.dismissProgressDialog { [self] in
                            let message = success["message"] as? String
                            let data = success["data"] as? [String: Any]
                            Logger.verbose("Success = \(message ??  "")")
                            
                            let accessToken = data?["access_token"] as? String
                            let userID = data?["user_id"] as? Int
                            Logger.verbose("Access Token = \(accessToken ?? "")")
                            Logger.verbose("userID = \(userID  ?? 0)")
                            
                            self.view.makeToast("Login Successful...".localized)
                            self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
                            self.appManager.reloadAllDataFromRemoteDatabase()
                            self.setDidLogUserIn(to: true)
                            self.handleGiftsAndStickers()
                            self.appNavigator.dashboardNavigate(to: .intro)
                        }
                    }
                    
                } else if let sessionError = sessionError {
                    Async.main {
                        self.dismissProgressDialog {
                            let errors = sessionError["errors"] as? [String:Any]
                            let errorText = errors?["error_text"] as? String
                            Logger.verbose("session Error = \(errorText ?? "")")
                            self.showOKAlertOverNavBar(title: "Security".localized,
                                                       message: errorText)
                        }
                    }
                    
                } else if let error = error {
                    Async.main {
                        self.dismissProgressDialog {
                            Logger.verbose("error = \(error.localizedDescription)")
                            
                            self.showOKAlertOverNavBar(title: "Security".localized,
                                                       message: error.localizedDescription)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: - Apple
     
     internal func appleLogin(access_Token: String) {
         
         self.showProgressDialog(with: "Loading...".localized)
         
         let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
         
         guard Connectivity.isConnectedToNetwork() else {
             self.showOKAlertOverNavBar(title: "Internet Error".localized,
                                        message: nil)
             return
         }
         
         Async.background {
             
             self.userManager.socialLogin(accessToken: access_Token,
                                              Provider: "apple",
                                              DeviceId: deviceID,
                                              googleApiKey: ControlSettings.googleApiKey,
                                              completionBlock: { (success, sessionError, error) in
                 
                 if let success = success {
                     
                     Async.main {
                         
                         self.dismissProgressDialog { [self] in
                             let message = success["message"] as? String
                             let data = success["data"] as? [String: Any]
                             Logger.verbose("Success = \(message ??  "")")
                             
                             let accessToken = data?["access_token"] as? String
                             let userID = data?["user_id"] as? Int
                             Logger.verbose("Access Token = \(accessToken ?? "")")
                             Logger.verbose("userID = \(userID  ?? 0)")
                             
                             self.view.makeToast("Login Successful...".localized)
                             self.saveUserSession(accessToken: accessToken ?? "", userID: userID ?? 0)
                             self.appManager.reloadAllDataFromRemoteDatabase()
                             self.setDidLogUserIn(to: true)
                             self.handleGiftsAndStickers()
                             self.appNavigator.dashboardNavigate(to: .intro)
                         }
                     }
                     
                 } else if let sessionError = sessionError {
                     Async.main {
                         self.dismissProgressDialog {
                             let errors = sessionError["errors"] as? [String:Any]
                             let errorText = errors?["error_text"] as? String
                             Logger.verbose("session Error = \(errorText ?? "")")
                             self.showOKAlertOverNavBar(title: "Security".localized,
                                                        message: errorText)
                         }
                     }
                     
                 } else if let error = error {
                     Async.main {
                         self.dismissProgressDialog {
                             Logger.verbose("error = \(error.localizedDescription)")
                             
                             self.showOKAlertOverNavBar(title: "Security".localized,
                                                        message: error.localizedDescription)
                         }
                     }
                 }
             })
         }
     }
}
