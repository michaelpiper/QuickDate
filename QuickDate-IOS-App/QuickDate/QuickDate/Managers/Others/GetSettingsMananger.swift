

import Foundation
import Alamofire
import QuickDateSDK

class GetSettingsManager{
    static let instance = GetSettingsManager()
    
    internal let appInstance: AppInstance = .shared
    
    func getSettings(language:String, completionBlock: @escaping (_ Success:GetSettingsModel.GetSettingsSuccessModel?,_ SessionError:GetSettingsModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.language: language,
           
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.COMMON_CONSTANT_METHODS.GET_OPTIONS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        
        AF.request(API.COMMON_CONSTANT_METHODS.GET_OPTIONS_API,
                   method: .post,
                   parameters: params,
                   encoding:URLEncoding.default,
                   headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(GetSettingsModel.GetSettingsSuccessModel.self, from: data!)
                    self.appInstance.adminAllSettings = result
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GetSettingsModel.sessionErrorModel.self, from: data!)
                    
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
