//
//  WithdrawalsManager.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class WithdrawalsManager{
    
    static let instance = WithdrawalsManager()
    
    func requestWithdrawals(AccessToken: String,
                            withdraw_method: String,
                            amount: String,
                            email: String,
                            completionBlock: @escaping (_ Success:RequestWithdrawModel.RequestWithdrawSuccessModel?,_ sessionError:RequestWithdrawModel.RequestWithdrawErrorModel?, Error?) ->()) {
        let params = [
            API.PARAMS.amount: amount,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.paypal_email: email,
            "withdraw_method": withdraw_method            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.REQUEST_WITHDRAWAL_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.REQUEST_WITHDRAWAL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    let result = RequestWithdrawModel.RequestWithdrawSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let result = RequestWithdrawModel.RequestWithdrawErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
