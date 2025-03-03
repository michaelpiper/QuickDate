//
//  FavoriteManager.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class FavoriteManager{
    
    static let instance = FavoriteManager()
    
    private init() {}
    
    func fetchFavorite(AccessToken:
                        String,limit:Int,offset:Int, completionBlock: @escaping (_ Success:ListFavoriteModel.ListFavoriteSuccessModel?,_ sessionError:ListFavoriteModel.ListFavoriteErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.limit: limit,
            API.PARAMS.offset: offset,
            API.PARAMS.access_token: AccessToken,
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.FAVORITE_CONSTANT_METHODS.FETCH_FAVORITE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.FAVORITE_CONSTANT_METHODS.FETCH_FAVORITE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = ListFavoriteModel.ListFavoriteSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = ListFavoriteModel.ListFavoriteErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func addFavorite(AccessToken:
                        String,uid:Int, completionBlock: @escaping (_ Success:AddFavoritesModel.AddFavoritesSuccessModel?,_ sessionError:AddFavoritesModel.AddFavoritesErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.uid: uid,
            API.PARAMS.access_token: AccessToken,
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.FAVORITE_CONSTANT_METHODS.ADD_FAVORITE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.FAVORITE_CONSTANT_METHODS.ADD_FAVORITE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode == nil{
                    let apiCode = res["code"]  as? Int
                    if apiCode ==  API.ERROR_CODES.E_200 {
                        let result = AddFavoritesModel.AddFavoritesSuccessModel.init(json: res)
                        completionBlock(result,nil,nil)
                    }else if apiCode ==  API.ERROR_CODES.E_400{
                        let result = AddFavoritesModel.AddFavoritesErrorModel.init(json: res)
                        completionBlock(nil,result,nil)
                    }
                }else{
                    if apiCode ==  API.ERROR_CODES.E_200 {
                        let result = AddFavoritesModel.AddFavoritesSuccessModel.init(json: res)
                        completionBlock(result,nil,nil)
                    }else if apiCode ==  API.ERROR_CODES.E_400{
                        let result = AddFavoritesModel.AddFavoritesErrorModel.init(json: res)
                        completionBlock(nil,result,nil)
                    }
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteFavorite(AccessToken:
                            String,uid:Int, completionBlock: @escaping (_ Success:DeleteFavoritesModel.DeleteFavoritesSuccessModel?,_ sessionError:DeleteFavoritesModel.DeleteFavoritesErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.uid: uid,
            API.PARAMS.access_token: AccessToken,
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.FAVORITE_CONSTANT_METHODS.DELETE_FAVORITE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.FAVORITE_CONSTANT_METHODS.DELETE_FAVORITE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = DeleteFavoritesModel.DeleteFavoritesSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    let result = DeleteFavoritesModel.DeleteFavoritesErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}

