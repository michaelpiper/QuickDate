

import Foundation
import Alamofire
import QuickDateSDK

class VideoCallManager{
    static let instance = VideoCallManager()
    
    func createVideoCall(AccessToken:String,toUserId:Int, completionBlock: @escaping (_ Success:CreateVideoCallModel.CreateVideoCallSuccessModel?,_ SessionError:CreateVideoCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.to_userid: toUserId,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.CREATE_NEW_VIDEO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.CREATE_NEW_VIDEO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(CreateVideoCallModel.CreateVideoCallSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(CreateVideoCallModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func checkForVideoCallAnswer(AccessToken:String,callID:Int, completionBlock: @escaping (_ status:Int?, _ Success:CheckForVideoCallAnswerModel.CheckForVideoCallAnswerSuccessModel?,_ SessionError:CheckForVideoCallAnswerModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.CHECK_FOR_VIDEO_ANSWER_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.CHECK_FOR_VIDEO_ANSWER_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try! JSONDecoder().decode(CheckForVideoCallAnswerModel.CheckForVideoCallAnswerSuccessModel.self, from: data!)
                    completionBlock(apiCode,result,nil,nil)
                }else if apiCode ==  300{
                    Logger.verbose("apiStatus Int = \(response.value)")
                    completionBlock(apiCode,nil,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus Int = \(response.value)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(CheckForVideoCallAnswerModel.sessionErrorModel.self, from: data!)
                    completionBlock(apiCode,nil,result,nil)
                }else if apiCode ==  401{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(CheckForVideoCallAnswerModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(apiCode,nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,nil,response.error)
            }
        }
    }
    func declineVideoCall(AccessToken:String,callID:Int, completionBlock: @escaping (_ Success:DeclineVideoCallModel.DeclineVideoSuccessCallModel?,_ SessionError:DeclineVideoCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.DECLINE_VIDEO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.DECLINE_VIDEO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(DeclineVideoCallModel.DeclineVideoSuccessCallModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(DeclineVideoCallModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func answerVideoCall(AccessToken:String,callID:Int, completionBlock: @escaping (_ Success:AnswerVideoCallModel.AnswerVideoCallSuccessModel?,_ SessionError:AnswerVideoCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.ANSWER_VIDEO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.ANSWER_VIDEO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AnswerVideoCallModel.AnswerVideoCallSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(AnswerVideoCallModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteVideoCall(AccessToken:String,callID:Int, completionBlock: @escaping (_ Success:DeleteVideoCallModel.DeleteVideoCallSuccessModel?,_ SessionError:DeleteVideoCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.DELETE_VIDEO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.DELETE_VIDEO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(DeleteVideoCallModel.DeleteVideoCallSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(DeleteVideoCallModel.sessionErrorModel.self, from: data!)
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

