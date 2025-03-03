

import Foundation
class SetCreditModel:BaseModel{
    struct SetCreditSuccessModel: Codable {
        let message: String?
        let code: Int?
        let balance: String?
     
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
