
import Foundation
import Alamofire
import QuickDateSDK

class BlogsManager{
    static let instance = BlogsManager()
    
    func getBlogs(AccessToken:String,limit:Int,offset:Int, completionBlock: @escaping (_ Success:ListArticlesModel.ListArticlesSuccessModel?,_ SessionError:ListArticlesModel.ListArticlesErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.limit: limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.offset: offset
      
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.BLOGS_CONSTANT_METHODS.ARTICLES_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.BLOGS_CONSTANT_METHODS.ARTICLES_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in            
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let result = ListArticlesModel.ListArticlesSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = ListArticlesModel.ListArticlesErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}

