

import Foundation
class BaseModel{
    
    struct sessionErrorModel: Codable {
        let message: String?
        let code: Int?
        let errors: Errors?        
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


