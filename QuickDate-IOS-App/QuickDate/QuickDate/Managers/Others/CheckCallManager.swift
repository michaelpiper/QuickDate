

import Foundation
import Alamofire
import QuickDateSDK

class CheckCallManager{
    static let instance = CheckCallManager()
    
    func checkCall(AccessToken:String,Limit:Int,Offset:Int, completionBlock: @escaping (_ Success:callData?,_ SessionError:CheckCallModel.sessionErrorModel?, Error?) ->()){
        
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
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    guard let voiceCall = res["audio_call"] as? Any else{return}
                    guard let videoCall = res["video_call"] as? Any else{return}
                    Logger.verbose("voiceCall = \(voiceCall)")
                    if voiceCall is Bool{
                        Logger.verbose("Nothing Here to show for audio")
                    }else{
                        
                        guard let voiceCallData = voiceCall as? [String:Any] else{return}
                        guard let callID = voiceCallData["id"] as? String? else{return}
                        guard let accessToken1 = voiceCallData["access_token"] as? String? else{return}
                        guard let accessToken2 = voiceCallData["access_token_2"] as? String? else{return}
                        guard let fromID = voiceCallData["from_id"] as? String? else{return}
                        guard let toID = voiceCallData["to_id"] as? String? else{return}
                        guard let roomName = voiceCallData["room_name"] as? String? else{return}
                        guard let username = voiceCallData["username"] as? String? else{return}
                        guard let fullname = voiceCallData["fullname"] as? String? else{return}
                        guard let avatar = voiceCallData["avater"] as? String? else{return}
                        let object = callData(AccessToken1: accessToken1, AccessToken2: accessToken2, callId: callID, username: username, fullname: fullname, isvoiceCall: true, fromId: fromID, toId: toID, avatar: avatar, roomName: roomName)
                        
                        Logger.verbose("voiceCalldata = \(object)")
                        
                        completionBlock(object,nil,nil)
                        
                    }
                    if videoCall is Bool{
                        Logger.verbose("Nothing Here to show for video")
                    }else{
                        
                        guard let voiceCallData =  videoCall as? [String:Any] else{return}
                        guard let callID = voiceCallData["id"] as? String? else{return}
                        guard let accessToken1 = voiceCallData["access_token"] as? String? else{return}
                        guard let accessToken2 = voiceCallData["access_token_2"] as? String? else{return}
                        guard let fromID = voiceCallData["from_id"] as? String? else{return}
                        guard let toID = voiceCallData["to_id"] as? String? else{return}
                        guard let roomName = voiceCallData["room_name"] as? String? else{return}
                        guard let username = voiceCallData["username"] as? String? else{return}
                        guard let fullname = voiceCallData["fullname"] as? String? else{return}
                        guard let avatar = voiceCallData["avater"] as? String? else{return}
                        let object = callData(AccessToken1: accessToken1, AccessToken2: accessToken2, callId: callID, username: username, fullname: fullname, isvoiceCall: false, fromId: fromID, toId: toID, avatar: avatar, roomName: roomName)
                        
                        Logger.verbose("videoCallData = \(object)")
                        
                        completionBlock(object,nil,nil)
                        
                    }
                    
                    
                    completionBlock(nil,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(CheckCallModel.sessionErrorModel.self, from: data!)
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
