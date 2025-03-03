
import Foundation
import Alamofire
import QuickDateSDK

class UpdateAvatarManager{
    
    static let instance = UpdateAvatarManager()
    func updateAvatar(AccesToken: String,AvatarData:Data?, completionBlock: @escaping (_ Success:UpdateAvatarModel.UpdateAvatarSuccessModel?,_ sessionError:UpdateAvatarModel.UpdateAvatarErrorModel?, Error?) ->()){
        
        let params = [
            API.PARAMS.access_token : AccesToken,
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
       
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = AvatarData{
                multipartFormData.append(data, withName: "avater", fileName: "avatar.jpg", mimeType: "image/png")
                
            }
            
        }, to: API.USERS_CONSTANT_METHODS.UPDATE_AVATAR_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            print("Succesfully uploaded")
            Logger.verbose("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                Logger.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = UpdateAvatarModel.UpdateAvatarSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let result = UpdateAvatarModel.UpdateAvatarErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
                
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
