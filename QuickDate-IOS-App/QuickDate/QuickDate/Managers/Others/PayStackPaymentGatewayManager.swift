//
//  PayStackPaymentGatewayManager.swift
//  Playtube
//
//  Created by iMac on 17/06/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK


class PayStackPaymentGatewayManager: NSObject {
    
    static let instance = PayStackPaymentGatewayManager()
    
    func payStackInitializeAPI(params: JSON, completionBlock: @escaping (_ Success: JSON?, String?) -> () ) {
        print(params)
        let URL = "\(API.PAYSTACK_PAYMENT_METHODS.PAYSTACK_INITIALIZE)"
        Logger.verbose("URL :=> \(URL)")
        AF.request(URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let res = response.value as? [String: Any] {
                guard let api_status = res["status"]  as? Int else { return }
                if api_status == API.ERROR_CODES.E_200 {
                    completionBlock(res, nil)
                } else if api_status == API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            } else {
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil, response.error?.localizedDescription)
            }
        }
    }
    
    func payStackPaymentSuccessAPI(params: JSON, completionBlock: @escaping (_ Success: JSON?, String?) -> () ) {
        print(params)
        let URL = API.PAYSTACK_PAYMENT_METHODS.PAYSTACK_PAYMENT
        Logger.verbose("URL :=> \(URL)")
        AF.request(URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let res = response.value as? [String: Any] {
                guard let api_status = res["status"]  as? Int else { return }
                if api_status == API.ERROR_CODES.E_200 {
                    completionBlock(res, nil)
                } else if api_status == API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            } else {
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil, response.error?.localizedDescription)
            }
        }
    }
}
