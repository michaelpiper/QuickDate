//
//  GoogleGeoCodeManager.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire

class GoogleGeoCodeManager{

    func geoCode(address : String, completionBlock : @escaping (_ Success: GoogleGeoCodeModal.GoogleGeoCode_SuccessModal?, _ AuthError : GoogleGeoCodeModal.GoogleGeoCodeErrorModel? , Error?)->()) {
//        AIzaSyCdzU_y3YKo12pjsa3HBSCwqeLjbqf4zjc
    let params = ["address" : address,"key":ControlSettings.googleApiKey] as [String : Any]
//        https://maps.googleapis.com/maps/api/geocode/json
//        APIClient.GoogleMap.googleMapApi
        AF.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["status"] else {return}
                let apiCodeString = apiStatusCode as? String
                
                if apiCodeString == "OK" {
                    guard let value = response.value,
                          let alldata = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
                    //                    print(response.value)
                    guard let result = try? JSONDecoder().decode(GoogleGeoCodeModal.GoogleGeoCode_SuccessModal.self, from: alldata) else {return}
                    //                    print(result)
                    completionBlock(result,nil,nil)
                    
                }
                    
                else if apiCodeString == "INVALID_REQUEST" {
                    guard let value = response.value,
                          let alldata = try? JSONSerialization.data(withJSONObject: value, options: []) else { return }
                    let result = try? JSONDecoder().decode(GoogleGeoCodeModal.GoogleGeoCodeErrorModel.self, from: alldata)
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func geoCode(type:String,lat:Double,lng:Double,completionBlock :@escaping (_ Success: GeoCodesModalMap.geoCode_SuccessModal?, _ AuthError: GeoCodesModalMap.geoCode_ErrorModal?, Error?)->()) {
        
        AF.request("https://maps.googleapis.com/maps/api/geocode/json?\(type)=\(lat),\(lng)&key=\(ControlSettings.googleApiKey)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.value {
                guard let res = value as? [String:Any] else {return}
                guard let apiStatusCode = res["status"] else {return}
                if apiStatusCode as? String == "OK"{
                    let result = GeoCodesModalMap.geoCode_SuccessModal.init(json: res)
                    print(result)
                    completionBlock(result,nil,nil)
                }
                else{
                    let error = GeoCodesModalMap.geoCode_ErrorModal.init(json: res)
                    print(error)
                    completionBlock(nil,error,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func reverseGeoCode(address:String,completionBlock :@escaping (_ Success: ReverseGeoCodeModal.reverseGeoCode_SuccessModal?, _ AuthError: ReverseGeoCodeModal.reverseGeoCode_ErrorModal?, Error?)->()) {
        var url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&key=\(ControlSettings.googleApiKey)"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.value {
                guard let res = value as? [String:Any] else {return}
                guard let apiStatusCode = res["status"] else {return}
                if apiStatusCode as? String == "OK"{
                    let result = ReverseGeoCodeModal.reverseGeoCode_SuccessModal.init(json: res)
                    print(result)
                    completionBlock(result,nil,nil)
                }
                else{
                    let error = ReverseGeoCodeModal.reverseGeoCode_ErrorModal.init(json: res)
                    print(error)
                    completionBlock(nil,error,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    static let sharedInstance = GoogleGeoCodeManager()
    private init() {}
}
