

import Foundation
class OnlineSwitchModel:BaseModel{
    struct OnlineSwitchSuccessModel: Codable {
        let code: Int?
        let message: String?
      
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
