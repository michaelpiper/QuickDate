//
//  SendSticker.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class SendStickerModel{
    
    struct SendStickerSuccessModel {
        var code: Int?
        var message: String?
        var data: [String:Any]?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let message = json["message"] as? String
            let data = json["data"] as? [String:Any]
            self.code = code ?? 0
            self.message = message ?? ""
            self.data = data ?? [:]
        }
    }

    struct SendStickerErrorModel{
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


class sendGiftModel:BaseModel{
    struct sendGiftSuccessModel: Codable {
        let status: Int?
        let message: String?
        let data: DataClass?
        let hashID: String?
        
        enum CodingKeys: String, CodingKey {
            case status, message, data
            case hashID = "hash_id"
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, from, fromDelete, to: Int?
        let toDelete: Int?
        let text, media: String?
        let sticker, seen: Int?
        let createdAt, messageType: String?
        
        enum CodingKeys: String, CodingKey {
            case id, from
            case fromDelete = "from_delete"
            case to
            case toDelete = "to_delete"
            case text, media, sticker, seen
            case createdAt = "created_at"
            case messageType = "message_type"
        }
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}

class ClearChatModel:BaseModel{
    struct ClearChatSuccessModel: Codable {
        let status: Int?
        let message: String?
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
