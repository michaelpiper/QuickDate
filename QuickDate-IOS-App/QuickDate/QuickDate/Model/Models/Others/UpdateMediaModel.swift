

import Foundation
class UpdateMediaModel:BaseModel{
    struct UpdateMediaSuccessModel {
        let code: Int
        let message: String
        let id: Int
        
        init(from dict: JSON) {
            id = dict["id"] as? Int ?? 0
            code = dict["code"] as? Int ?? 0
            message = dict["message"] as? String ?? ""
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

class deleteMediaModel:BaseModel{
    struct deleteMediaSuccessModel: Codable {
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
