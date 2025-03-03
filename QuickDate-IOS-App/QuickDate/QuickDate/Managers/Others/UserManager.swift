

import Foundation
import Alamofire
import QuickDateSDK

class UserManager {
    // MARK: - Properties
    static let instance = UserManager()
    // Property Injections
    private let networkManager: NetworkManager
    
    private init() {
        networkManager = .shared
    }
    
    // MARK: - Functions
    
    // TODO: Change these step by step to handle clean code and DRY principle
    
    func registerUser(with credentials: RegisterCredentials,
                      completionBlock: @escaping (_ Success: [String: Any]?, _ SessionError: [String:Any]?, Error?) -> Void) {
        
        let params = [
            API.PARAMS.first_name: credentials.firstName,
            API.PARAMS.last_name: credentials.lastName ,
            API.PARAMS.email: credentials.email,
            API.PARAMS.username: credentials.username,
            API.PARAMS.password: credentials.password,
            API.PARAMS.device_id: credentials.deviceId
        ]
        
        print(params)
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.REGISTER_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.REGISTER_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            print(response.value as Any)
            Logger.verbose("Response = \(String(describing: response.value))")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                Logger.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    completionBlock(res,nil,nil)
//                    Logger.verbose("apiStatus Int = \(apiStatus)")
////                    let data = try! JSONSerialization.data(withJSONObject: response.value!, options: [])
//                    let result = RegisterModel.RegisterSuccessModel.init(json: res)
//                    print(result)
////                    let result = try! JSONDecoder().decode(RegisterModel.RegisterSuccessModel.self, from: data)
//                   var accessToken = ""
//                    var userId = 0
//                    if let dataa = res["data"] as? [String:Any]{
//                        if let token = dataa["access_token"] as? String{
//                            accessToken = token
//                        }
//                        if let id = dataa["user_id"] as? Int{
//                            userId = id
//                        }
//                    }
//                    Logger.debug("Success = \(accessToken),,\(userId)")
//                    let User_Session = [Local.USER_SESSION.Access_token:accessToken as Any,Local.USER_SESSION.User_id:userId as Any] as [String : Any]
//                    UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
//                    completionBlock(result,nil,nil)
                }else{
//                    Logger.verbose("apiStatus String = \(apiStatus)")
//                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
//                    let result = try? JSONDecoder().decode(RegisterModel.sessionErrorModel.self, from: data!)
//                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,res,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func forgetPassword(Email:String, completionBlock: @escaping (_ Success:ForgetPasswordModel.ForgetPasswordSuccessModel?,_ SessionError:ForgetPasswordModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.email: Email,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.RESET_PASSWORD_API)")
        Logger.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.RESET_PASSWORD_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ForgetPasswordModel.ForgetPasswordSuccessModel.self, from: data!)
                    Logger.debug("Success = \(String(describing: result))")
                    
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ForgetPasswordModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func logout(AccessToken:String, completionBlock: @escaping (_ Success:LogoutModel.LogoutSuccessModel?,_ SessionError:LogoutModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.LOGOUT_API)")
        Logger.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.LOGOUT_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LogoutModel.LogoutSuccessModel.self, from: data!)
                    Logger.debug("Success = \(result)")
                    
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LogoutModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func deleteAccount(AccessToken:String,Password:String, completionBlock: @escaping (_ Success:DeleteAccountModel.DeleteAccountSuccessModel?,_ SessionError:DeleteAccountModel.DeleteAccountErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.password: Password,
            
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.DELETE_ACCOUNT_API)")
        Logger.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.DELETE_ACCOUNT_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = DeleteAccountModel.DeleteAccountSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result =  DeleteAccountModel.DeleteAccountErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func socialLogin(accessToken: String, Provider: String,DeviceId:String,googleApiKey:String ,completionBlock: @escaping (_ Success:[String:Any]?,_ SessionError:[String:Any]?, Error?) ->()){
        var params = [String:String]()
               if Provider == API.SOCIAL_PROVIDERS.FACEBOOK{
                   params = [
                       API.PARAMS.provider: Provider,
                       API.PARAMS.access_token: accessToken,
                   ]
               }else{
                   params = [
                       API.PARAMS.provider: Provider,
                       API.PARAMS.access_token: accessToken,
//                       API.PARAMS.Google_Key : googleApiKey
                       ] as! [String : String]
               }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.SOCIAL_LOGIN_API)")
        Logger.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.SOCIAL_LOGIN_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
//                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
//                    let result = try? JSONDecoder().decode(LoginModel.LoginSuccessModel.self, from: data!)
//                    Logger.debug("Success = \(result?.message ?? "")")
//                    let User_Session = [Local.USER_SESSION.Access_token:result?.data?.accessToken ?? "",Local.USER_SESSION.User_id:result?.data?.userID ?? 0] as! [String : Any]
//                    UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                    completionBlock(res,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
//                    Logger.verbose("apiStatus String = \(apiStatus)")
//                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
//                    let result = try? JSONDecoder().decode(LoginModel.sessionErrorModel.self, from: data!)
//                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,res,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func verifyTwoFactor( userId: Int,code:Int,completionBlock: @escaping (_ Success:[String:Any]?,_ SessionError:[String:Any]?, Error?) ->()){
           let params = [
               
               API.PARAMS.code: code,
               API.PARAMS.user_id:userId
            ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
           let decoded = String(data: jsonData!, encoding: .utf8)!
           Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.VERIFY_TWO_FACTOR_API)")
           Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.VERIFY_TWO_FACTOR_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
               Logger.verbose("Response = \(response.value)")
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   Logger.verbose("Response = \(res)")
                   guard let apiStatus = res["code"]  as? Int else {return}
                   if apiStatus ==  API.ERROR_CODES.E_200{
//                       Logger.verbose("apiStatus Int = \(apiStatus)")
//                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
//                    let result = try? JSONDecoder().decode(LoginModel.LoginSuccessModel.self, from: data!)
//                    Logger.debug("Success = \(result?.data?.accessToken ?? "")")
//                    let User_Session = [Local.USER_SESSION.Access_token:result?.data?.accessToken as Any,Local.USER_SESSION.User_id:result?.data?.userID as Any] as [String : Any]
//                       UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                       completionBlock(res,nil,nil)
                   }else{
//                       Logger.verbose("apiStatus String = \(apiStatus)")
//                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
//                       let result = try? JSONDecoder().decode(LoginModel.sessionErrorModel.self, from: data!)
//                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                       completionBlock(nil,res,nil)
                   }
               }else{
                   Logger.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
    func loginWithWoWonder(userName : String, password : String, completionBlock : @escaping (_ Success:LoginWithWoWonderModel.LoginWithWoWonderSuccessModel?, _ AuthError : LoginWithWoWonderModel.LoginWithWoWonderErrorModel?, Error?)->()) {
        
        let params  = [
            API.PARAMS.ServerKey : ControlSettings.wowonder_ServerKey,
            API.PARAMS.username : userName,
            API.PARAMS.password :password
        ]
        
        AF.request("\(ControlSettings.wowonder_URL)api/auth", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"]  as? Any else {return}
                let apiCode = apiStatusCode as? Int
                if apiCode == 200 {
                    guard let allData = try? JSONSerialization.data(withJSONObject: response.value, options: [])else {return}
                    guard let result = try? JSONDecoder().decode(LoginWithWoWonderModel.LoginWithWoWonderSuccessModel.self, from: allData) else {return}
                    completionBlock(result,nil,nil)
                    
                }
                    
                else {
                    guard let allData = try? JSONSerialization.data(withJSONObject: response.value, options: [])else {return}
                    guard let result = try? JSONDecoder().decode(LoginWithWoWonderModel.LoginWithWoWonderErrorModel.self, from: allData) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
