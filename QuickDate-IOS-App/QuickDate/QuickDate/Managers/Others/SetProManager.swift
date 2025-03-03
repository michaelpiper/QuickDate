

import Foundation
import Alamofire
import QuickDateSDK

class SetProManager{
    static let instance = SetProManager()
    
    func setPro(AccessToken:String,Type:Int,Price:Int,Via:String, completionBlock: @escaping (_ Success:SetProModel.SetProSuccessModel?,_ SessionError:SetProModel.SetProErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.type: Type,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.via: Via,
            API.PARAMS.price: Price
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.SET_PRO_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.SET_PRO_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = SetProModel.SetProSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = SetProModel.SetProErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
