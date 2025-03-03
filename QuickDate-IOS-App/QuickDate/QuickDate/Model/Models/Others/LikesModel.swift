

import Foundation
class LikesModel:BaseModel{
    
    struct LikesSuccessModel: Codable {
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
