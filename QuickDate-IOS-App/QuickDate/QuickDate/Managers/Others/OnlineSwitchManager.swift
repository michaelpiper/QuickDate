

import Foundation
import Alamofire
import QuickDateSDK

class OnlineSwitchManager{
    static let instance = OnlineSwitchManager()
    
    func getNotifications(AccessToken:String,status:Int, completionBlock: @escaping (_ Success:SwitchOnlineModel.SwitchOnlineSuccessModel?,_ SessionError:SwitchOnlineModel.SwitchOnlineErrorModel?, Error?) ->()){
        
        let params = [
            API.PARAMS.online: status,
            API.PARAMS.access_token: AccessToken            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.SWITCH_ONLINE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.SWITCH_ONLINE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let result = SwitchOnlineModel.SwitchOnlineSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = SwitchOnlineModel.SwitchOnlineErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
