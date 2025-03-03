//
//  AddRequestManager.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.

import Foundation
import Alamofire
import QuickDateSDK

class AddFriendRequestManager{
    
    static let instance = AddFriendRequestManager()
    
    func AddRequest(AccessToken:
        String,uid:String, completionBlock: @escaping (_ Success:AddRequestModel.AddRequestSuccessModel?,_ sessionError:AddRequestModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.uid: uid,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.FRIEND_REQUEST_CONSTANT_METHODS.ADD_FRIEND_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.FRIEND_REQUEST_CONSTANT_METHODS.ADD_FRIEND_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                if let apiCode = res["status"] as? Int {
                    if apiCode ==  API.ERROR_CODES.E_200 {
                        Logger.verbose("apiStatus Int = \(apiCode)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                        let result = try? JSONDecoder().decode(AddRequestModel.AddRequestSuccessModel.self, from: data!)
                        completionBlock(result,nil,nil)
                    }else if apiCode ==  API.ERROR_CODES.E_400{
                        Logger.verbose("apiStatus String = \(apiCode)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                        let result = try? JSONDecoder().decode(AddRequestModel.sessionErrorModel.self, from: data!)
                        Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                        completionBlock(nil,result,nil)
                    }
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}

