//
//  ChangePassword.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class ChangePasswordModel{
    
    struct ChangePasswordSuccessModel {
        var code: Int?
        var data: String?
        let message:String?

        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let data = json["data"] as? String
            let message = json["messsage"] as? String
            self.code = code ?? 0
            self.data = data ?? ""
            self.message = message ?? ""
            
        }
    }
    struct CHangePasswordErrorModel{
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
