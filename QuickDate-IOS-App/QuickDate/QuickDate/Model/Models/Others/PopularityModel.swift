

import Foundation
class PopularityModel:BaseModel{
    struct PopularitySuccessModel: Codable {
        let status, creditAmount: Int?
        let message: String?
        
        enum CodingKeys: String, CodingKey {
            case status
            case creditAmount = "credit_amount"
            case message
        }
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
