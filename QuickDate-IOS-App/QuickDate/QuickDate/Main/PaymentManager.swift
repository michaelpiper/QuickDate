//
//  PaymentManager.swift
//  QuickDate
//
//  Created by Sourav Mishra on 26/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK
import SwiftyJSON
import UIKit

class PaymentManager {
    static let instance = PaymentManager()

    func razorPaySuccess(AccessToken:String,payment_id:String,merchant_amount:String, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        
        let params = [
            "payment_id": payment_id,
             "merchant_amount": merchant_amount,
            API.PARAMS.access_token: AccessToken,
            "order_id": payment_id
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.COMMON_CONSTANT_METHODS.GET_NOTIFICATIONS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        let urlString = API.PAYMENT_METHODS.RAZORPAY_CREATE //"https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/razorpay/create"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    completionBlock(nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    completionBlock(nil,"Error 400")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func authorizePaySuccess(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.PAYMENT_METHODS.AUTHORIZE_PAY
        Logger.verbose("URL: --- \(urlString)")
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus == API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func iyzipayCreateSession(params: JSON, completionBlock: @escaping (_ Success:String?, String?) ->()) {
        let urlString = API.PAYMENT_METHODS.IYZIPAY_CREATE //"https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/iyzipay/createsession"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let htmlText = res["html"] as? String ?? ""
                    completionBlock(htmlText,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func createStripeSession(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.STRIPE_PAYMENT_METHODS.STRIPE_CREATE //"https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/authorize/pay"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func createAuthorizeNetSession(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.PAYMENT_METHODS.AUTHORIZE_PAY
        AF.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func createStripeSuccess(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.STRIPE_PAYMENT_METHODS.STRIPE_SUCCESS_PAY //"https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/authorize/pay"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func fetchAamarPaymentAPI(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.AAMAR_PAYMENY_METHODS.AAMARPAY_GET
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func fetchFlutteWavePaymentAPI(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.FLUTTE_WAVE_PAYMENY_METHODS.FLUTTE_WAVE_PAY
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func fetchCoinbasePaymentAPI(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.COINBASE_PAYMENY_METHODS.COINBASE_CREATE
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func fetchNgeniusPaymentAPI(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.NGENIUS_PAYMENY_METHODS.NGENIUS_GET
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func fetchNgeniusSuccessPaymentAPI(params: JSON, completionBlock: @escaping (_ Success:JSON?, String?) ->()) {
        let urlString = API.NGENIUS_PAYMENY_METHODS.NGENIUS_SUCCESS
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    completionBlock(res,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
}
