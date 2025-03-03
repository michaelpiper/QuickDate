

import Foundation
import Alamofire
import QuickDateSDK

class BlockUserManager {
     static let instance = BlockUserManager()
    
    func blockUser(AccessToken:String,To_userId:Int, completionBlock: @escaping (_ Success:BlockModel.blockSuccessModel?,_ SessionError:BlockModel.BlockErrorModal?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.block_userid: To_userId,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.BLOCK_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.BLOCK_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = BlockModel.blockSuccessModel.init(json: res)
                    Logger.error("AuthError = \(result.message ?? "")")
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let result = BlockModel.BlockErrorModal.init(json: res)
                    Logger.error("AuthError = \(result.message ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
