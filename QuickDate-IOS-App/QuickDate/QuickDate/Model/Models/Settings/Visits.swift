
import Foundation
 
class Visits {
    public var id : Int?
    public var view_userid : Int?
    public var created_at : String?
    public var data : UserProfileSettings?
    
    init(from dict: JSON) {
        id = dict["id"] as? Int
        view_userid = dict["view_userid"] as? Int
        created_at = dict["created_at"] as? String
        data = dict.getUserDataList(with: "data")
    }
}
