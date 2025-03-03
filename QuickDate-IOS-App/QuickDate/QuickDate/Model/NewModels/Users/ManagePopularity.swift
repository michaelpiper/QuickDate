//
//  Manage Popularity.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class ManagePopularityModel{
    
    struct ManagePopularitySuccessModel {
        var status: Int?
        var creditAmount:Int?
        var message: String?
        
        
        init(json:[String:Any]) {
            let status = json["status"] as? Int
            let message = json["message"] as? String
            let creditAmount = json["credit_amount"] as? Int
            self.creditAmount = creditAmount ?? 0
            self.status = status ?? 0
            self.message = message ?? ""
        }
    }
    
    struct ManagePopularityErrorModel{
        var code: Int?
        var errors: [String:Any]?
        var message: String?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let errors = json["errors"] as? [String:Any]
            let message = json["message"] as? String
            self.code = code ?? 0
            self.errors = errors ?? [:]
        }
    }
    
}
