
import Foundation

class Blocks {
	public var id : Int
	public var block_userid : Int
	public var created_at : String
	public var data : UserProfileSettings?

    init(from dict: JSON) {
        id = dict["id"] as? Int ?? 0
        block_userid = dict["block_userid"] as? Int ?? 0
        created_at = dict["created_at"] as? String ?? ""
        data = dict.getUserDataList(with: "data")
    }
}
