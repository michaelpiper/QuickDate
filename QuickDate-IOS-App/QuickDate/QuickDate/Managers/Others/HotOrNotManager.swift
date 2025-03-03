//
//  HotOrNotManager.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class HotOrNotManager{
    
    static let instance = HotOrNotManager()
    
    func getHotOrNot(AccessToken:
                        String,limit:Int,offset:Int, genders:String,completionBlock: @escaping (_ Success:HotOrNotModel.HotOrNotSuccessModel?,_ sessionError:HotOrNotModel.HotOrNotErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.offset: offset,
            API.PARAMS.limit: limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.genders: genders,
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.HOT_OR_NOT_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.HOT_OR_NOT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let result = HotOrNotModel.HotOrNotSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = HotOrNotModel.HotOrNotErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func addHot(AccessToken:
                    String,userId:Int,completionBlock: @escaping (_ Success:AddHotModel.AddHotSuccessModel?,_ sessionError:AddHotModel.AddHotErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.user_id: userId,
            API.PARAMS.access_token: AccessToken,
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.ADD_HOT_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.ADD_HOT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = AddHotModel.AddHotSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = AddHotModel.AddHotErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func addNot(AccessToken:
                    String,userId:Int,completionBlock: @escaping (_ Success:AddNotModel.AddNotSuccessModel?,_ sessionError:AddNotModel.AddNotErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.user_id: userId,
            API.PARAMS.access_token: AccessToken,
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.ADD_NOT_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.ADD_NOT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let result = AddNotModel.AddNotSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = AddNotModel.AddNotErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}

