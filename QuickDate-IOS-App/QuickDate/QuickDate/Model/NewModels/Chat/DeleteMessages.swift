//
//  DeleteMessages.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class DeleteMessagesModel{
    
    struct DeleteMessagesSuccessModel {
        var code: Int?
        var message: String?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let message = json["message"] as? String
            self.code = code ?? 0
            self.message = message ?? ""
        }
    }
    
    struct DeleteMessagesErrorModel{
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
