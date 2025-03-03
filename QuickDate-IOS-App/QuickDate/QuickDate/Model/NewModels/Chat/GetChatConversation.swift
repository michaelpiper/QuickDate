//
//  GetChatConversation.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class GetChatConversationModel {
    
    struct GetChatConversationSuccessModel {
        var code: Int?
        var message: String?
        let data : [ChatConversationModel]
        let requests : [[String:Any]]
        let requests_count : Int?
                
        init(json: JSON) {
            let code = json["code"] as? Int
            let message = json["message"] as? String
            let data = json["data"] as? [[String:Any]]
            let requestCOunt = json["requests_count"] as? Int
            let requests = json["requests"] as? [[String:Any]]
            self.code = code ?? 0
            self.message = message ?? ""
            var dtArr = [ChatConversationModel]()
            if let data = (json["data"] as? [JSON]) {
                dtArr = data.map({ChatConversationModel(with: $0)})
            }
            self.data = dtArr
            self.requests_count = requestCOunt ?? 0
            self.requests = requests ?? []
        }
    }

    struct GetChatConversationErrorModel {
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

class GetChatModel {
    
    struct GetChatSuccessModel {
        var code: Int?
        var message: String?
        let data : [ChatModel]
                
        init(json: JSON) {
            let code = json["code"] as? Int
            let message = json["message"] as? String
            self.code = code ?? 0
            self.message = message ?? ""
            var dtArr = [ChatModel]()
            if let data = (json["data"] as? [JSON]) {
                dtArr = data.map({ChatModel(with: $0)})
            }
            self.data = dtArr
        }
    }

    struct GetChatErrorModel {
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
