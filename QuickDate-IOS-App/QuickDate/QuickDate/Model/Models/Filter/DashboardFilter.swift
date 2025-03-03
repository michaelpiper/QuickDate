//
//  DashboardFilter.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 20.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import QuickDateSDK

enum Gender: Int, Codable {
    case female
    case male
    case both
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:  self = .female
        case 1:  self = .male
        default: self = .both
        }
    }
    
    init(stringValue: String) {
        switch stringValue {
        case "4526":  self = .female
        case "4525":  self = .male
        default:      self = .both
        }
    }
    
    var code: Int? {
        switch self {
        case .female: return 4526
        case .male:   return 4525
        case .both:   return nil
        }
    }
    
}

class DashboardFilter: Codable {
    
    // Properties
    var gender: Gender = .both
    var onlineNow: Bool?
    var birthDay: String?
    
    // Computed Properties
    var params: APIParameters {
        var params: APIParameters = [:]
        
        if onlineNow != nil {
            params[API.PARAMS.online] = "1"
        }
        
        if let genderCode = gender.code {
            params[API.PARAMS.genders] = "\(genderCode)"
        }
        return params
    }
    
}
