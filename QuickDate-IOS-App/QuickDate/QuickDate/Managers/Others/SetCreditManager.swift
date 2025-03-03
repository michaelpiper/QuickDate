

import Foundation
import Alamofire
import QuickDateSDK

class SetCreditManager{
    static let instance = SetCreditManager()
    
    func setPro(AccessToken:String,Credits:Int,Price:Int,Via:String, completionBlock: @escaping (_ Success:SetCreditModel.SetCreditSuccessModel?,_ SessionError:SetCreditModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.credits: Credits,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.via: Via,
            API.PARAMS.price: Price
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.SET_CREDIT_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.SET_CREDIT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SetCreditModel.SetCreditSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(SetCreditModel.sessionErrorModel.self, from: data!)
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
