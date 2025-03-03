

import Foundation
import Alamofire
import QuickDateSDK

class PopularityManager{
    static let instance = PopularityManager()
    
    func managePopularity(AccessToken:String,Type:String, completionBlock: @escaping (_ Success:ManagePopularityModel.ManagePopularitySuccessModel?,_ SessionError:ManagePopularityModel.ManagePopularityErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.type: Type,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.MANAGE_POPULARITY_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.MANAGE_POPULARITY_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                 let apiStatus = res["status"]  as? Int
                 let apiCode = res["code"]  as? Int
                if apiStatus ==  API.ERROR_CODES.E_200 || apiCode == API.ERROR_CODES.E_200 {
                    let result = ManagePopularityModel.ManagePopularitySuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 || apiCode == API.ERROR_CODES.E_400{
                    let result = ManagePopularityModel.ManagePopularityErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
