//
//  LocalSettingsModels.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 13.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import RealmSwift

protocol Convertible {
    init()
}

extension String: Convertible {}
extension Int: Convertible {}

class AdminSettings: Object {
    
    @Persisted(primaryKey: true) var id = 0
    @Persisted var updatedDate: Date = Date()
    @Persisted var localData: Data?
    
}


class UserSettings: Object {
    
    @Persisted(primaryKey: true) var id = 0
    @Persisted var updatedDate: Date = Date()
    @Persisted var localData: Data?
    
    // MARK: - Computed Properties
    var userID: Int? {
        switch localData {
        case .none: return nil
        case .some(let data):
            let userID: Int? = getValue(key: "user_id", from: data)
            return userID
        }
    }
    
    var accessToken: String? {
        switch localData {
        case .none: return nil
        case .some(let data):
            let token: String? = getValue(key: "access_token", from: data)
            return token
        }
    }
}

// MARK: - Functions
extension UserSettings {
    private func getValue<T: Convertible>(key: String, from data: Data) -> T? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDictionary = json as? JSON,
              let responseJSON = jsonDictionary["data"] as? JSON  else {
                  return nil
              }
        return responseJSON[key] as? T
    }
}
