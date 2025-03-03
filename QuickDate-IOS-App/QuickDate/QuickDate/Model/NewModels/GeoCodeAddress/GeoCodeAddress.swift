//
//  GeoCodeAddress.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class GeoCodesModalMap{
    
    struct geoCode_SuccessModal{
        var plus_code: [String:Any]
        var results: [[String:Any]]
        var status: String
        init(json:[String:Any]) {
            let plus_code = json["plus_code"] as? [String:Any]
            let results = json["results"] as? [[String:Any]]
            let status = json["status"] as? String
            self.plus_code = plus_code ?? ["":""]
            self.results = results ?? [["":""]]
            self.status = status ?? ""
        }
        
    }
    
    struct geoCode_ErrorModal {
       var error_message: String
       var results: [[String:Any]]
       var status: String
        init(json:[String:Any]) {
            let error_message = json["error_message"] as? String
            let results = json["results"] as? [[String:Any]]
            let status = json["status"] as? String
            self.error_message = error_message ?? ""
            self.results = results ?? [["":""]]
            self.status = status ?? ""
        }
    }
    
    
}
class ReverseGeoCodeModal{
    
    struct reverseGeoCode_SuccessModal{
         var results: [[String:Any]]
         var status: String
         init(json:[String:Any]) {
             let results = json["results"] as? [[String:Any]]
             let status = json["status"] as? String
             self.results = results ?? [["":""]]
             self.status = status ?? ""
         }
         
     }
    
    struct reverseGeoCode_ErrorModal {
       var error_message: String
       var results: [[String:Any]]
       var status: String
        init(json:[String:Any]) {
            let error_message = json["error_message"] as? String
            let results = json["results"] as? [[String:Any]]
            let status = json["status"] as? String
            self.error_message = error_message ?? ""
            self.results = results ?? [["":""]]
            self.status = status ?? ""
        }
    }
    
    
    
}
