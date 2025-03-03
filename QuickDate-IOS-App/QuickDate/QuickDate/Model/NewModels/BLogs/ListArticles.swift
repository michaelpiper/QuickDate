//
//  ListArticles.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class ListArticlesModel{
    
    struct ListArticlesSuccessModel {
        var code: Int?
        var message: String?
        var data: [Blog]
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let message = json["message"] as? String ?? ""
            self.code = code ?? 0
            self.message = message
            var dtArr = [Blog]()
            if let data = (json["data"] as? [JSON]) {
                dtArr = data.map({Blog(from: $0)})
            }
            self.data = dtArr
        }
    }
    
    struct ListArticlesErrorModel {
        var code: Int?
        var errors: [String:Any]?
        var message: String?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let errors = json["errors"] as? [String:Any]
            let message = json["message"] as? String ?? ""
            self.code = code ?? 0
            self.errors = errors ?? [:]
            self.message = message
        }
    }
    
}

public class Blog {
    public var id : Int
    public var title : String
    public var content : String
    public var description : String
    public var posted : String
    public var category : Int
    public var thumbnail : String
    public var view : Int
    public var shared : Int
    public var tags : String
    public var created_at : Int
    public var category_name : String
    public var url : String
    
    init(from dict: JSON) {
        id = dict["id"] as? Int ?? 0
        title = dict["title"] as? String ?? ""
        content = dict["content"] as? String ?? ""
        description = dict["description"] as? String ?? ""
        posted = dict["posted"] as? String ?? ""
        category = dict["category"] as? Int ?? 0
        thumbnail = dict["thumbnail"] as? String ?? ""
        view = dict["view"]  as? Int ?? 0
        shared = dict["shared"]  as? Int ?? 0
        tags = dict["tags"] as? String ?? ""
        created_at = dict["created_at"] as? Int ?? 0
        category_name = dict["category_name"] as? String ?? ""
        url = dict["url"] as? String ?? ""
    }
}
