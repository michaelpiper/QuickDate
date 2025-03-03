//
//  SessionManager.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class SessionManager{
    
    static let instance = SessionManager()
    
    func getSession(AccessToken:
                    String,completionBlock: @escaping (_ Success: SessionModel.SessionSuccessModel?, _ sessionError: SessionModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.LIST_SESSIONS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.LIST_SESSIONS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                Logger.verbose("Response = \(res)")
                guard let apiStatus = res["status"] as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try! JSONDecoder().decode(SessionModel.SessionSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: res, options: [])
                 let result = try? JSONDecoder().decode(SessionModel.sessionErrorModel.self, from: data!)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteSession(AccessToken:
                        String,id:Int,completionBlock: @escaping (_ Success:DeleteSessionModel.DeleteSessionSuccessModel?,_ sessionError:DeleteSessionModel.DeleteSessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
             API.PARAMS.sid: id,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.DELETE_SESSION_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.DELETE_SESSION_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = DeleteSessionModel.DeleteSessionSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result =  DeleteSessionModel.DeleteSessionErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
