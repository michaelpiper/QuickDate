
import Foundation
 
class Likes {
	public var id : Int?
	public var like_userid : Int?
	public var is_like : Int?
	public var is_dislike : Int?
	public var data : UserProfileSettings?

    init(from dict: JSON) {
        id = dict["id"] as? Int
        like_userid = dict["like_userid"] as? Int
        is_like = dict["is_like"] as? Int
        is_dislike = dict["is_dislike"] as? Int
        data = dict.getUserDataList(with: "data")
    }
}
