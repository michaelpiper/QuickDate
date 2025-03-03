

import Foundation
class PayStripeModel:BaseModel{
    struct PayStripeSuccessModel: Codable {
        let code: Int?
        let message: String?
        let creditAmount: Int?
        
        enum CodingKeys: String, CodingKey {
            case code, message
            case creditAmount = "credit_amount"
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
