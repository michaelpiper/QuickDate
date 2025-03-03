//
//  MainNetworkModel.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 12.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// TODO: If it is not necessary then delete this document.

// MARK: - MainNetworkModel

struct MainNetworkModel {
    
    let code: Int
    let message: String
    let errors: Errors
    
    init(dict: JSON, successCode: SuccessCode) {
        self.code = dict[successCode.rawValue] as? Int ?? 0
        self.message = dict["message"] as? String ?? ""
        self.errors = Errors(dict: dict["errors"] as? JSON)
    }
}

// MARK: - UpdateDataModel

struct UpdateDataModel {
    
    let data: String
    let code: Int
    let errors: Errors
    let message: String
    
    init(dict: JSON, successCode: SuccessCode) {
        self.data = dict["data"]  as? String ?? ""
        self.code = dict[successCode.rawValue] as? Int ?? 0
        self.message = dict["message"] as? String ?? ""
        self.errors = Errors(dict: dict["errors"] as? JSON)
    }
}

// MARK: - Errors

struct Errors {
    
    let errorID, errorText: String
    
    init(dict: JSON?) {
        self.errorID = dict?["error_id"] as? String ?? ""
        self.errorText = dict?["error_text"] as? String ?? ""
    }
}
