
import Foundation
class BlogsModel:BaseModel{
 
    // MARK: - Welcome
    struct BlogsSuccessModel: Codable {
        let data: [Datum]?
        let code: Int?
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id: Int?
        let title, content, datumDescription, posted: String?
        let category: Int?
        let thumbnail: String?
        let view, shared: Int?
        let tags: String?
        let createdAt: Int?
        let categoryName: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id, title, content
            case datumDescription = "description"
            case posted, category, thumbnail, view, shared, tags
            case createdAt = "created_at"
            case categoryName = "category_name"
            case url
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
