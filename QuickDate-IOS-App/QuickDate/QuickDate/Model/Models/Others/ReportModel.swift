

import Foundation

class ReportModel:BaseModel{
    
    struct ReportSuccessModel: Codable {
        let message: String?
        let code: Int?
        let data: DataClass?
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, userID, reportUserid, seen: Int?
        let createdAt: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case reportUserid = "report_userid"
            case seen
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
