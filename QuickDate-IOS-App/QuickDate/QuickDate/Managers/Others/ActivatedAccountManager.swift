//
//  ActivatedAccountManager.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/2/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class ActivatedAccountManager{
    
    func activateAccount(code:Int,email:String,completionBlock: @escaping (_ Success:ActivateAccountModal.ActivateAccount_SuccessModal?,_ SessionError:ActivateAccountModal.ActivateAccount_ErrorModal?, Error?) ->()){
        
        let params = [API.PARAMS.email: email,API.PARAMS.email_code:code,API.PARAMS.device_id:UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId) ?? ""] as [String : Any]
        
        AF.request(API.AUTH_CONSTANT_METHODS.ACTIVATE_ACCOUNT_API, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                //                Logger.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ActivateAccountModal.ActivateAccount_SuccessModal.init(json: res)
                    var userID = 0
                    var token = ""
                    if let data = res["data"] as? [String:Any]{
                        if let userId = data["user_id"] as? Int{
                            userID = userId
                        }
                        if let access_token = data["access_token"] as? String{
                            token = access_token
                        }
                    }
                    let User_Session = [Local.USER_SESSION.Access_token:token,Local.USER_SESSION.User_id:userID] as [String : Any]
                    UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                    completionBlock(result,nil,nil)
                }
                else{
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ActivateAccountModal.ActivateAccount_ErrorModal.self, from: data!)
                    completionBlock(nil,result,nil)
                }
            }
            else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = ActivatedAccountManager()
    private init() {}
}
