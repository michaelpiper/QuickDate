
import Foundation
import Alamofire
import QuickDateSDK

class AudioCallManager{
    static let instance = AudioCallManager()
    
    func createAudioCall(AccessToken:String,toUserId:Int, completionBlock: @escaping (_ Success:CreateAudioCallModel.CreateAudioCallSuccessModel?,_ SessionError:CreateAudioCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.to_userid: toUserId,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.CREATE_NEW_AUDIO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.CREATE_NEW_AUDIO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
//            Logger.verbose("apiStatus Int = \(response.result.value)")

            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(CreateAudioCallModel.CreateAudioCallSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(CreateAudioCallModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func checkForAudioCallAnswer(AccessToken:String,callID:Int, completionBlock: @escaping (_ status:Int?,_ Success:CheckForAudioCallAnswerModel.CheckForAudioCallAnswerSuccessModel?,_ SessionError:CheckForAudioCallAnswerModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.CHECK_FOR_AUDIO_ANSWER_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.CHECK_FOR_AUDIO_ANSWER_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("Response = \(response.value)")
            print(response.value)
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(CheckForAudioCallAnswerModel.CheckForAudioCallAnswerSuccessModel.self, from: data!)
                    print("Result",result)
                    completionBlock(apiCode,result,nil,nil)
                }else if apiCode ==  300{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    completionBlock(apiCode,nil,nil,nil)

                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(CheckForAudioCallAnswerModel.sessionErrorModel.self, from: data!)
                    completionBlock(apiCode,nil,result,nil)

                }else if apiCode ==  401{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(CheckForAudioCallAnswerModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(apiCode,nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,nil,response.error)
            }
        }
    }
    func declineAudioCall(AccessToken:String,callID:Int, completionBlock: @escaping (_ Success:DeclineAudioCallModel.DeclineAudioSuccessCallModel?,_ SessionError:DeclineAudioCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.DECLINE_AUDIO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.DECLINE_AUDIO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(DeclineAudioCallModel.DeclineAudioSuccessCallModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(DeclineAudioCallModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func answerAudioCall(AccessToken:String,callID:Int, completionBlock: @escaping (_ Success:AnswerAudioCallModel.AnswerAudioCallSuccessModel?,_ SessionError:AnswerAudioCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.ANSWER_AUDIO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.ANSWER_AUDIO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AnswerAudioCallModel.AnswerAudioCallSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(AnswerAudioCallModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteAudioCall(AccessToken:String,callID:Int, completionBlock: @escaping (_ Success:DeleteAudioCallModel.DeleteVideoCallSuccessModel?,_ SessionError:DeleteAudioCallModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.id: callID,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUDIO_VIDEO_CONSTANT_METHODS.DELETE_AUDIO_CALL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUDIO_VIDEO_CONSTANT_METHODS.DELETE_AUDIO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(DeleteAudioCallModel.DeleteVideoCallSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(DeleteAudioCallModel.sessionErrorModel.self, from: data!)
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

