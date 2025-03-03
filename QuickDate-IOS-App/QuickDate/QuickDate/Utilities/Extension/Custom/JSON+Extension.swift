//
//  JSON+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 19.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

extension JSON {
    
    /// Get Choice Property which has early set choices from server and its texts to provide clear code
    /// - Parameters:
    ///   - dict: JSON value from server
    ///   - keys: type and text key
    /// - Returns: [ChoiceProperty](x-source-tag://ChoiceProperty)
    func getChoice(with keys: ChoiceProperty ) -> ChoiceProperty {
        let type = self[keys.type] as? String ?? ""
        let text = self[keys.text] as? String ?? ""
        return (type, text)
    }
    
    /// Handle return statement in initializer
    func returnNonOptional(with key: String) -> JSON {
        guard let dict = self[key] as? JSON else {
            Logger.error("getting JSON"); return [:]
        }
        return dict
    }
    
    func getBoolType(with key: String) -> Bool {
        if self[key] is String {
            return (self[key] as? String ?? "0") == "1" ? true : false
        }else {
            return (self[key] as? Int ?? 0) == 1 ? true : false
        }
    }
    
    func getDoubleType(with key: String) -> Double {
        return Double(self[key] as? String ?? "") ?? 0
    }
    
    func getIntType(with key: String) -> String {
        if let str = self[key] as? String {
            return str
        }else {
            return "\(self[key] as? Int ?? 0)"
        }
    }
    
    /// fetch MediaFile type and turn its to array
    func getMediaFileList(with key: String) -> [MediaFile] {
        guard let dictArray = self[key] as? [JSON] else { return [] }
        return dictArray.map { MediaFile(from: $0) }
    }
    
    /// fetch User Profile type and turn its to array
    func getUserDataList(with key: String) -> UserProfileSettings? {
        guard let dictArray = self[key] as? JSON else { return nil }
        return UserProfileSettings(dict: dictArray)
    }
    
    /// fetch Like type and turn its to array
    func getLikesList(with key: String) -> [Likes] {
        guard let dictArray = self[key] as? [JSON] else { return [] }
        return dictArray.map { Likes(from: $0) }
    }
    
    /// fetch Block User type and turn its to array
    func getBlocksList(with key: String) -> [Blocks] {
        guard let dictArray = self[key] as? [JSON] else { return [] }
        return dictArray.map { Blocks(from: $0) }
    }
    
    /// fetch Visit User type and turn its to array
    func getVisitList(with key: String) -> [Visits] {
        guard let dictArray = self[key] as? [JSON] else { return [] }
        return dictArray.map { Visits(from: $0) }
    }
    
    func getStringList(with key: String) -> [String] {
        guard let dictArray = self[key] as? [String] else { return [] }
        return dictArray
    }
    
    /// fetch MediaFile type and turn its to array
    func turnToDictFromDictionaryArray(with key: String) -> JSON {
        guard let dictArray = self[key] as? [JSON] else { return [:] }
        var resultDict: JSON = [:]
        dictArray.forEach { json in
            json.forEach { resultDict[$0.key] = $0.value }
        }
        return resultDict
    }
}

//MARK:- Remove Duplicate Value From Array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
