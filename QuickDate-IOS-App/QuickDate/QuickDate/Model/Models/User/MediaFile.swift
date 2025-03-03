//
//  MediaFile.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 4.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

class MediaFile: Codable {
    var id: Int
    var full, avatar, privateFileFull, privateFileAvatar, videoFile: String
    var isPrivate, isVideo, isConfirmed, isApproved: Bool
    
    var avatarURL: URL? {
        return URL(string: avatar)
    }
    
    init(from dict: JSON) {
        self.id = dict["id"] as? Int ?? 0
        self.full = dict["full"] as? String ?? ""
        self.avatar = dict["avater"] as? String ?? ""
        self.privateFileFull = dict["private_file_full"] as? String ?? ""
        self.privateFileAvatar = dict["private_file_avater"] as? String ?? ""
        self.videoFile = dict["video_file"] as? String ?? ""
        
        self.isPrivate = dict.getBoolType(with: "is_private")
        self.isVideo = dict.getBoolType(with: "is_video")
        self.isConfirmed = dict.getBoolType(with: "is_confirmed")
        self.isApproved = dict.getBoolType(with: "is_approved")
    }
}
