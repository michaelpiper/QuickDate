//
//  ResendEmailManager.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/1/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK

class ResendEmailManager{
    
    func resendEmail(email:String,completionBlock: @escaping (_ Success:ResendEmailModal.ResendEmail_SuccessModal?,_ SessionError:ResendEmailModal.ResendEmail_ErrorModal?, Error?) ->()){
           let params = [API.PARAMS.email: email] as [String : Any]
        AF.request(API.AUTH_CONSTANT_METHODS.RESEND_EMAIL_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            print(response.value)
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   Logger.verbose("Response = \(res)")
                   guard let apiStatus = res["code"]  as? Int else {return}
                   if apiStatus ==  API.ERROR_CODES.E_200{
                       Logger.verbose("apiStatus Int = \(apiStatus)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ResendEmailModal.ResendEmail_SuccessModal.self, from: data!)
                       completionBlock(result,nil,nil)
                   }else{
                       Logger.verbose("apiStatus String = \(apiStatus)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ResendEmailModal.ResendEmail_ErrorModal.self, from: data!)
                       completionBlock(nil,result,nil)
                   }
               }else{
                   Logger.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
    
    static let sharedInstance = ResendEmailManager()
    private init() {}
    
}
