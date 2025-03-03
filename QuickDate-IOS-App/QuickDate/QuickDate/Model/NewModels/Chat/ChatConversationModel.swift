
import Foundation

struct ChatConversationModel {
    let conversation_status : Bool
    let conversation_created_at : String?
    let id : Int
    let owner : Int
    let seen : Int
    let accepted : Bool
    let text : String
    let media : String
    let sticker : String
    let time : String
    let created_at : String
    let new_messages : Int
    let from_id : Int
    let to_id : Int
    let user : UserProfileSettings?
    let message_type : String
    
    let from_name : String
    let from_avater : String
    let type : String
    let to_name : String
    let to_avater : String
    let from : Int
    let to : Int
    let from_delete : Bool
    let to_delete : Bool


    
    init(with dict: JSON) {
        conversation_status = dict.getBoolType(with: "conversation_status")
        conversation_created_at = dict["conversation_created_at"] as? String
        id = dict["id"] as? Int ?? 0
        owner = dict["owner"] as? Int ?? 0
        seen = dict["seen"] as? Int ?? 0
        accepted = dict.getBoolType(with: "accepted")
        text = dict["text"] as? String ?? ""
        media = dict["media"] as? String ?? ""
        sticker = dict["sticker"] as? String ?? ""
        time = dict["time"] as? String ?? ""
        created_at = dict["created_at"] as? String ?? ""
        new_messages = dict["new_messages"] as? Int ?? 0
        from_id = dict["from_id"] as? Int ?? 0
        to_id = dict["to_id"] as? Int ?? 0
        user = dict.getUserDataList(with: "user")
        message_type = dict["message_type"] as? String ?? ""
        
        from_name = dict["from_name"] as? String ?? ""
        from_avater = dict["from_avater"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        to_name = dict["to_name"] as? String ?? ""
        to_avater = dict["to_avater"] as? String ?? ""
        from = dict["from"] as? Int ?? 0
        to = dict["to"] as? Int ?? 0
        from_delete = dict.getBoolType(with: "from_delete")
        to_delete = dict.getBoolType(with: "to_delete")
        
    }
}
