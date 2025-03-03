//
//  TrendingFilter.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import QuickDateSDK

// MARK: - TrendingFilter

class TrendingFilter: Codable {
    
    var basic: BasicFilter = BasicFilter()
    var looks: LooksFilter = LooksFilter()
    var background: BackgroundFilter = BackgroundFilter()
    var lifeStyle: LifeStyleFilter = LifeStyleFilter()
    var more: MoreFilter = MoreFilter()
    
    var params: APIParameters {
        var params: APIParameters = [:]
        getParams(from: basic.params, to: &params)
        getParams(from: looks.params, to: &params)
        getParams(from: background.params, to: &params)
        getParams(from: lifeStyle.params, to: &params)
        getParams(from: more.params, to: &params)
        return params
    }
    
    private func getParams(from fromDict: APIParameters, to dict: inout APIParameters) {
        fromDict.forEach { dict[$0.key] = $0.value }
    }
}

// MARK: - BasicFilter

class BasicFilter: Codable {
    var location: String?
    var gender: Gender = .both
    var ageFrom: Double = 18
    var ageTo: Double = 75
    var distance: Float = 35
    var onlineNow: Bool?
    
    fileprivate var genderValue: Int? {
        switch gender {
        case .female: return 4526
        case .male:   return 4525
        case .both:   return nil
        }
    }
    var params: APIParameters {
        var params: APIParameters = [:]
        if let location = location {
            params[API.PARAMS.location0] = location
        }
        params[API.PARAMS.age_from0] = "\(ageFrom)"
        params[API.PARAMS.age_to0] = "\(ageTo)"
        
        if let genderCode = gender.code {
            params[API.PARAMS.genders] = "\(genderCode)"
        }
        
        params[API.PARAMS.located0] = "\(distance)"
        
        if onlineNow != nil {
            params[API.PARAMS.online] = "\(1)"
        }
        return params
    }
}

// MARK: - LooksFilter

class LooksFilter: Codable {
    
    var body: String?
    var fromHeight: String = "139"
    var toHeight: String = "220"
    
    var params: APIParameters {
        var params: APIParameters = [:]
        if let body = body {
            params[API.PARAMS.body0] = body
        }
        params[API.PARAMS.height_from0] = fromHeight
        params[API.PARAMS.height_to0] = toHeight
        
        return params
    }
}

// MARK: - BackgroundFilter

class BackgroundFilter: Codable {
    
    var language: String = "english"
    var religion: String?
    var ethnicity: String?
    
    var params: APIParameters {
        var params: APIParameters = [:]
        params[API.PARAMS.language0] = language
        
        if let religion = religion {
            params[API.PARAMS.religion0] = religion
        }
        if let ethnicity = ethnicity {
            params[API.PARAMS.ethnicity0] = ethnicity
        }
        return params
    }
}

// MARK: - BackgroundFilter

class LifeStyleFilter: Codable {
    
    var relationship: String?
    var smoke: String?
    var drink: String?
    
    var params: APIParameters {
        var params: APIParameters = [:]
        if let relationship = relationship {
            params[API.PARAMS.relationship0] = relationship
        }
        if let smoke = smoke {
            params[API.PARAMS.smoke0] = smoke
        }
        if let drink = drink {
            params[API.PARAMS.drink0] = drink
        }
        return params
    }
}

// MARK: - MoreFilter

class MoreFilter: Codable {
    
    var interest: String?
    var education: String?
    var pets: String?
    
    var params: APIParameters {
        var params: APIParameters = [:]
        if let interest = interest {
            params[API.PARAMS.interest0] = interest
        }
        if let education = education {
            params[API.PARAMS.education0] = education
        }
        if let pets = pets {
            params[API.PARAMS.pets0] = pets
        }
        return params
    }
}
