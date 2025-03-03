//
//  ChatData.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 4.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

struct ChatData {
    
    let conversationStatus: Int
    let id, owner, seen, accepted: Int
    let text: String
    let media, sticker: String?
    let time: String
    let createdAt: String
    let newMessages, fromID, toID: Int
//    let user: ChatUser
    let messageType: String
    
    init(dict: JSON) {
        self.conversationStatus = dict.getValue(key: .conversationStatus, defaultValue: 0)
        self.id = dict.getValue(key: .id, defaultValue: 0)
        self.owner = dict.getValue(key: .owner, defaultValue: 0)
        self.seen = dict.getValue(key: .seen, defaultValue: 0)
        self.accepted = dict.getValue(key: .accepted, defaultValue: 0)
        self.text = dict.getValue(key: .text, defaultValue: "")
        self.media = dict.getValue(key: .media, defaultValue: "")
        self.sticker = dict.getValue(key: .sticker, defaultValue: "")
        self.time = dict.getValue(key: .time, defaultValue: "")
        self.createdAt = dict.getValue(key: .createdAt, defaultValue: "")
        self.newMessages = dict.getValue(key: .newMessages, defaultValue: 0)
        self.fromID = dict.getValue(key: .fromID, defaultValue: 0)
        self.toID = dict.getValue(key: .toID, defaultValue: 0)
        self.messageType = dict.getValue(key: .messageType, defaultValue: "")
    }

    fileprivate enum JSONKeys: String{
        case conversationStatus = "conversation_status"
        case conversationCreatedAt = "conversation_created_at"
        case id, owner, seen, accepted, text, media, sticker, time
        case createdAt = "created_at"
        case newMessages = "new_messages"
        case fromID = "from_id"
        case toID = "to_id"
        case user
        case messageType = "message_type"
    }
}

struct ChatUser: Codable {
    let id: String
    let verifiedFinal: Bool
    let fullname: String
    let mediafiles: [Mediafile]
    let avater: String
    let username, firstName, lastName, lastseen: String

    enum CodingKeys: String, CodingKey {
        case id
        case verifiedFinal = "verified_final"
        case fullname, mediafiles, avater, username
        case firstName = "first_name"
        case lastName = "last_name"
        case lastseen
    }
}


struct ChatMediaFile: Codable {
    let id: Int
    let full, avater: String
    let isPrivate: Int
    let privateFull, privateAvater: String

    enum CodingKeys: String, CodingKey {
        case id, full, avater
        case isPrivate = "is_private"
        case privateFull = "private_full"
        case privateAvater = "private_avater"
    }
}


extension JSON {
    
    fileprivate func getIntegerFromString(key: ChatData.JSONKeys, defaultValue: Int) -> Int {
        guard let numberString = self[key.rawValue] as? String,
              let number = Int(numberString) else {
                  return defaultValue
              }
        return number
    }
    
    fileprivate func getBool(key: ChatData.JSONKeys, defaultValue: Bool) -> Bool {
        guard let boolString = self[key.rawValue] as? String else {
                  return defaultValue
              }
        return boolString.lowercased() == "true" ? true : false
    }
    
    fileprivate func getValue<T>(key: ChatData.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    
}
