

import Foundation
class BankTransferModel:BaseModel{
    struct BankTransferSuccessModel: Codable {
        let data, code: Int?
       
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
