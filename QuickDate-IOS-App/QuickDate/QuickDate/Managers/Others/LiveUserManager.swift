//
//  LiveUserManager.swift
//  QuickDate
//
//  Created by iMac on 09/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Alamofire
import QuickDateSDK

class LiveUserManager {
    static let instance = LiveUserManager()
    
    func fetchLiveUserAPI(params: JSON, completionBlock: @escaping (_ Success: [LiveUserModel]?,_ SessionError:[String:Any]?, Error?) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.LIVE_STREAM_METHODS.LIVE_USERS_LIST)")
        Logger.verbose("Decoded String = \(decoded)")
        
        AF.request(API.LIVE_STREAM_METHODS.LIVE_USERS_LIST, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let result):
                guard let res = result as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    if let data = res["data"] as? [JSON] {
                        let array = data.map({LiveUserModel(dict: $0)})
                        completionBlock(array,nil,nil)
                    }
                } else {
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    completionBlock(nil,res,nil)
                }
            case .failure(let error):
                Logger.error("error = \(error.localizedDescription)")
                completionBlock(nil,nil,error)
            }
        }
    }
    
    func getMatches(AccessToken:String,Limit:Int,Offset:Int,genders:String, completionBlock: @escaping (_ Success:[String:Any]?,_ SessionError:[String:Any]?, Error?) ->()){
        let params = [
        
            API.PARAMS.limit: Limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.offset: Offset,
            API.PARAMS.genders: genders
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.RANDOM_USER_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.RANDOM_USER_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
//                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
//                    let result = try? JSONDecoder().decode(GetMatchModel.GetMatchSuccessModel.self, from: data!)
                    completionBlock(res,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
//                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
//                    let result = try? JSONDecoder().decode(GetMatchModel.sessionErrorModel.self, from: data!)
//                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,res,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
