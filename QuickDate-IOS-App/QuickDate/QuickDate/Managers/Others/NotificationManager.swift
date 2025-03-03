

import Foundation
import Alamofire
import QuickDateSDK

class NotificationManager{
    static let instance = NotificationManager()
    
    func getNotifications(AccessToken:String,Limit:Int,Offset:Int, completionBlock: @escaping (_ Success:GetNotifcationModel.GetNotificationSuccessModel?,_ SessionError:GetNotifcationModel.GetNotificationErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.limit: Limit,
             API.PARAMS.offset: Offset,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.COMMON_CONSTANT_METHODS.GET_NOTIFICATIONS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.COMMON_CONSTANT_METHODS.GET_NOTIFICATIONS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = GetNotifcationModel.GetNotificationSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = GetNotifcationModel.GetNotificationErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
