//
//  WithdrawalsModel.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import Foundation
class WithdrawalsModel:BaseModel{
    
    struct WithdrawalsSuccessModel: Codable {
    let message: String?
    let code: Int?
   
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
