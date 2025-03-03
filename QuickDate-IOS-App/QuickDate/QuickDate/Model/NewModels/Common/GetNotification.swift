//
//  GetNotification.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class GetNotifcationModel{
    
    struct GetNotificationSuccessModel {
        
        var code: Int?
        var message: String?
        var data: [[String:Any]]?
        var newMessageCount:Int?
        var newNotificationCount:Int?
        var newFriendRequestCount:Int?
        
        init(json:[String:Any]) {
            
            let code = json["code"] as? Int
            let message = json["message"] as? String
            let data = json["data"] as? [[String:Any]]
            let newMessageCount = json["new_notification_count"] as? Int
            let newNotifciationCount = json["new_messages_count"] as? Int
            let newFriendRequestCount = json["friend_request_count"] as? Int
            
            self.code = code ?? 0
            self.message = message ?? ""
            self.data = data ?? []
            self.newNotificationCount = newNotifciationCount ?? 0
            self.newMessageCount = newMessageCount ?? 0
            self.newFriendRequestCount = newFriendRequestCount ?? 0
            
        }
    }

    struct GetNotificationErrorModel{
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
