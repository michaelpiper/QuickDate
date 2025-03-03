//
//  WoWonderProfileManager.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class WoWProfileManager {
    static let instance = WoWProfileManager()
    
    func WoWonderUserData (userId : String, access_token : String, completionBlock : @escaping (_ Success:SocialLoginModel.SocialLoginSuccessModel?, _ AuthError : SocialLoginModel.sessionErrorModel? , Error?)->()){
        
        let params = [API.PARAMS.ServerKey :ControlSettings.wowonder_ServerKey, API.PARAMS.user_id : userId, API.PARAMS.fetch : "user_data"] as [String : Any]
        
        AF.request("\(ControlSettings.wowonder_URL)api/get-user-data?access_token=" + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"]  as? Any else {return}
                let apiCode = apiStatusCode as? Int
                if apiCode == 200 {
                    let base64String = self.jsonToBaseString(yourJSON: res)
                    var params = [String:String]()
                    
                    params = [
                        API.PARAMS.provider: "wowonder",
                        API.PARAMS.access_token: base64String!,
                        API.PARAMS.device_id:UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId) ?? "",
                       
                    ]
                    
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
                    let decoded = String(data: jsonData!, encoding: .utf8)!
                    Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.SOCIAL_LOGIN_API)")
                    AF.request(API.AUTH_CONSTANT_METHODS.SOCIAL_LOGIN_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
                        
                        if (response.value != nil){
                            guard let res = response.value as? [String:Any] else {return}
                            Logger.verbose("Response = \(res)")
                            guard let apiStatus = res["status"]  as? Int else {return}
                            if apiStatus ==  API.ERROR_CODES.E_200{
                                Logger.verbose("apiStatus Int = \(apiStatus)")
                                let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                                let result = try? JSONDecoder().decode(SocialLoginModel.SocialLoginSuccessModel.self, from: data!)
                                Logger.debug("Success = \(result?.accessToken ?? "")")
                                let User_Session = [Local.USER_SESSION.Access_token:result?.accessToken as Any,Local.USER_SESSION.User_id:result?.data?.id as Any] as [String : Any]
                                UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                                completionBlock(result,nil,nil)
                            }else{
                                Logger.verbose("apiStatus String = \(apiStatus)")
                                let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                                let result = try? JSONDecoder().decode(SocialLoginModel.sessionErrorModel.self, from: data!)
                                Logger.error("AuthError = \(result?.errors?.errorText ?? "" ?? "")")
                                completionBlock(nil,result,nil)
                            }
                        }else{
                            Logger.error("error = \(response.error?.localizedDescription ?? "")")
                            completionBlock(nil,nil,response.error)
                        }
                    }
                }
                else {
                    completionBlock(nil,nil,nil)
                }
            }
                
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
                
            }
        }
    }
    func jsonToBaseString (yourJSON: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: yourJSON, options: JSONSerialization.WritingOptions.prettyPrinted)
            return
                jsonData.base64EncodedString(options: .endLineWithCarriageReturn)
        } catch {
            return nil
        }
    }
}
