//
//  LikeDislikeMananger.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation

import Alamofire
import QuickdateSDK
class LikeDislikeMananger{
    
    static let instance = LikeDislikeMananger()
    
    func getLikePeople(AccessToken:
                        String,limit:Int,offset:Int,completionBlock: @escaping (_ Success:ListLikedUsersModel.ListLikedUsersSuccessModel?,_ sessionError:ListLikedUsersModel.ListLikedUsersErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.limit: limit,
            API.PARAMS.offset: offset,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.LIST_LIKED_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.LIST_LIKED_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let result = ListLikedUsersModel.ListLikedUsersSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let result = ListLikedUsersModel.ListLikedUsersErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func getDislikePeople(AccessToken:
                            String,limit:Int,offset:Int,completionBlock: @escaping (_ Success:ListDisLikedUsersModel.ListDisLikedUsersSuccessModel?,_ sessionError:ListDisLikedUsersModel.ListDisLikedUsersErrorModel?, Error?) ->()){
           let params = [
               API.PARAMS.access_token: AccessToken,
               API.PARAMS.limit: limit,
               API.PARAMS.offset: offset,
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
           let decoded = String(data: jsonData!, encoding: .utf8)!
           Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.LIST_DISLIKED_API)")
           Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.LIST_DISLIKED_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   let apiCode = res["status"]  as? Int
                   if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = ListDisLikedUsersModel.ListDisLikedUsersSuccessModel.init(json: res)
                       completionBlock(result,nil,nil)
                   }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = ListDisLikedUsersModel.ListDisLikedUsersErrorModel.init(json: res)
                       completionBlock(nil,result,nil)
                   }
               }else{
                   Logger.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
    func deleteLike(AccessToken:
                        String,id:Int,completionBlock: @escaping (_ Success:LikeDeleteModel.LikeDeleteSuccessModel?,_ sessionError:LikeDeleteModel.LikeDeleteErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.user_likeid: id,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.DELETE_LIKE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.DELETE_LIKE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = LikeDeleteModel.LikeDeleteSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = LikeDeleteModel.LikeDeleteErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteDislike(AccessToken:
                        String,id:Int,completionBlock: @escaping (_ Success:DisLikeDeleteModel.DisLikeDeleteSuccessModel?,_ sessionError:DisLikeDeleteModel.DisLikeDeleteErrorModel?, Error?) ->()){
           let params = [
               API.PARAMS.access_token: AccessToken,
               API.PARAMS.user_dislike: id,
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
           Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.DELETE_DISLIKE_API)")
           Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.DELETE_DISLIKE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   let apiCode = res["code"]  as? Int
                   if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = DisLikeDeleteModel.DisLikeDeleteSuccessModel.init(json: res)
                       completionBlock(result,nil,nil)
                   }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = DisLikeDeleteModel.DisLikeDeleteErrorModel.init(json: res)
                       completionBlock(nil,result,nil)
                   }
               }else{
                   Logger.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }

}
