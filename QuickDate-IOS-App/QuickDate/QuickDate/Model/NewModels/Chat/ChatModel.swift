//
//  ChatModel.swift
//  QuickDate
//
//  Created by iMac on 31/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import Foundation

struct ChatModel {
    let id : Int
    let seen : Int
    let text : String
    let media : String
    let sticker : String
    let created_at : Int
    let message_type : String
    
    let from_name : String
    let from_avater : String
    let type : String
    let to_name : String
    let to_avater : String
    let from : Int
    let to : Int
    let from_delete : Bool
    let to_delete : Bool
    
    init(with dict: JSON) {
        id = dict["id"] as? Int ?? 0
        seen = dict["seen"] as? Int ?? 0
        text = dict["text"] as? String ?? ""
        media = dict["media"] as? String ?? ""
        sticker = dict["sticker"] as? String ?? ""
        created_at = dict["created_at"] as? Int ?? 0
        message_type = dict["message_type"] as? String ?? ""
        
        from_name = dict["from_name"] as? String ?? ""
        from_avater = dict["from_avater"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        to_name = dict["to_name"] as? String ?? ""
        to_avater = dict["to_avater"] as? String ?? ""
        from = dict["from"] as? Int ?? 0
        to = dict["to"] as? Int ?? 0
        from_delete = dict.getBoolType(with: "from_delete")
        to_delete = dict.getBoolType(with: "to_delete")        
    }
}
