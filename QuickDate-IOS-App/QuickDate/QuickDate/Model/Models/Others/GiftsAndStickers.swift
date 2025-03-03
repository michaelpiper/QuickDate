//
//  GiftsAndStickers.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 27.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import RealmSwift

class GiftsAndStickers: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var updatedDate: Date = Date()
    @Persisted var giftsData: Data?
    @Persisted var stickersData: Data?
}

// MARK: - GiftModel

struct GiftModel: Decodable {
    let data: [Gift]
    let code: Int
    let errors: GiftError
    let message: String
}

struct Gift: Decodable {
    let id: Int
    let file: String
}

// MARK: - StickerModel

struct StickerModel: Decodable {
    let data: [Sticker]
    let code: Int
    let errors: GiftError
    let message: String
}

struct Sticker: Decodable {
    let id: Int
    let file: String
}

// MARK: - GiftError

struct GiftError: Codable {
    let errorID, errorText: String

    enum CodingKeys: String, CodingKey {
        case errorID = "error_id"
        case errorText = "error_text"
    }
}

struct GiftSuccessModel {
    let id: Int
    let file: String
    
    init(json: JSON) {
        self.id = json["id"] as? Int ?? 0
        self.file = json["file"] as? String ?? ""
    }
}
