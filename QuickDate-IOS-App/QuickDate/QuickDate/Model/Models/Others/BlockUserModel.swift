

import Foundation
class BlockUserModel:BaseModel{
    struct BlockUserSuccessModel: Codable {
        let message: String?
        let code: Int?
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, userID, blockUserid: Int?
        let createdAt: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case blockUserid = "block_userid"
            case createdAt = "created_at"
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
