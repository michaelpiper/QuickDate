
import Foundation
 
class LiveUserModel {
	public var id : Int
	public var user_id : Int
	public var text : String
	public var postType : String
	public var postFile : String
	public var image : String
	public var stream_name : String
	public var agora_token : String
	public var live_time : Int
	public var live_ended : Int
	public var agora_resource_id : String
	public var agora_sid : String
	public var time : Int
	public var created_at : String
	public var user_data : UserProfileSettings?
    
    init(dict: JSON) {
        id = dict["id"] as? Int ?? 0
        user_id = dict["user_id"] as? Int ?? 0
        text = dict["text"] as? String ?? ""
        postType = dict["postType"] as? String ?? ""
        postFile = dict["postFile"] as? String ?? ""
        image = dict["image"] as? String ?? ""
        stream_name = dict["stream_name"] as? String ?? ""
        agora_token = dict["agora_token"] as? String ?? ""
        live_time = dict["live_time"] as? Int ?? 0
        live_ended = dict["live_ended"] as? Int ?? 0
        agora_resource_id = dict["agora_resource_id"] as? String ?? ""
        agora_sid = dict["agora_sid"] as? String ?? ""
        time = dict["time"] as? Int ?? 0
        created_at = dict["created_at"] as? String ?? ""
        user_data = dict.getUserDataList(with: "user_data")
    }

}
