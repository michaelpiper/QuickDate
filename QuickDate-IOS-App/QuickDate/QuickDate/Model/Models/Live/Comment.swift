//
//  Comment.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 7.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// MARK: - Comment
struct Comment: Equatable {
    let id: Int
    let text: String
    let publisher: Publisher
    
    // MARK: - Initializer
    init(dict: JSON) {
        
        self.id = dict.getCommentValue(key: .id, defaultValue: 0)
        self.text = dict.getCommentValue(key: .text, defaultValue: "")
        let json = dict.returnNonOptional(with: JSONKeys.publisher.rawValue)
        self.publisher = Publisher(dict: json)
    }
    
    fileprivate enum JSONKeys: String {
        case id
        case userID = "user_id"
        case postID = "post_id"
        case text, time, publisher
    }
    
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - Publisher
class Publisher {
    
    let userId: Int
    let username, firstName, lastName: String
    let avatar: String
    
    var avatarURL: URL? {
        return URL(string: avatar)
    }
    
    var fullName: String {
        return firstName.isEmpty && lastName.isEmpty ? username
        : lastName.isEmpty ? firstName
        : firstName.isEmpty ? username
        : "\(firstName) \(lastName)"
    }
    
    fileprivate init(dict: JSON) {
        self.userId = dict.getValue(key: .id, defaultValue: 0)
        self.avatar = dict.getValue(key: .avater, defaultValue: "")
        self.username = dict.getValue(key: .username, defaultValue: "")
        self.firstName = dict.getValue(key: .firstName, defaultValue: "")
        self.lastName = dict.getValue(key: .lastName, defaultValue: "")
    }
    
    fileprivate enum JSONKeys: String {
        case id
        case fullname
        case avater
        case username
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

extension JSON {
    
    fileprivate func getCommentValue<T>(key: Comment.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    
    fileprivate func getValue<T>(key: Publisher.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
    
}
