//
//  ListLikedUsers.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class ListLikedUsersModel{
    
    struct ListLikedUsersSuccessModel {
        var status: Int?
        var message: String?
        var data: [UserProfileSettings]
        
        init(json:[String:Any]) {
            let status = json["status"] as? Int
            let message = json["message"] as? String
            self.status = status ?? 0
            self.message = message ?? ""
            var dtArr = [UserProfileSettings]()
            if let data = (json["data"] as? [JSON]) {
                dtArr = data.map({UserProfileSettings(dict: $0)})
            }
            self.data = dtArr
        }
    }

    struct ListLikedUsersErrorModel{
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
