//
//  GetProfileManager.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/18/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class GetProfileManager{
        func getProfileData(user_id:String,completionBlock : @escaping (_ Success: ProfileModel.ProfileSuccessModel?, _ AuthError : ProfileModel.ProfileErrorModal? , Error?)->()) {
        let accessToken = AppInstance.shared.accessToken ?? ""
        let params = [API.PARAMS.access_token:accessToken,API.PARAMS.user_id:user_id,API.PARAMS.fetch:"data,media,likes,blocks,payments,reports,visits,referrals,aff_payments"] as [String : Any]

        AF.request(API.USERS_CONSTANT_METHODS.PROFILE_API, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//            print(response.result.value)
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"]  as? Any else {return}
                let apiCodeInt = apiStatusCode as? Int
                if apiCodeInt == 200{
                    let result = ProfileModel.ProfileSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    let result = ProfileModel.ProfileErrorModal.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = GetProfileManager()
    private init() {}
}
