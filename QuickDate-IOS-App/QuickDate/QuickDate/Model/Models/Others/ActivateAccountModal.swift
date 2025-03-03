//
//  ActivateAccountModal.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/2/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation


class ActivateAccountModal{
    struct ActivateAccount_SuccessModal {
        var code: Int
        var message: String
        var data: [String:Any]
        var errors: [String:Any]
        //        var message: String?
        //        var code: Int?
        //        var success_type:
        //        var data: DataClass?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let message = json["message"] as? String
            let data = json["data"] as? [String:Any]
            let error = json["errors"] as? [String:Any]
            self.code = code ?? 0
            self.message = message ?? ""
            self.data = data ?? ["":""]
            self.errors = error ?? ["":""]
        }
        
    }
    
    struct ActivateAccount_ErrorModal:Codable{
        let code: Int
        let errors: Errors
        let data: [JSONAny]
        let message: String
    }
    
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String

        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
    
}
