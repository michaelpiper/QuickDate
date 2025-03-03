//
//  ProfileFeatures.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 26.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import SwiftUI

/// - Tag: ChoiceProperty
typealias ChoiceProperty = (type: String, text: String)

class ProfileFeatures {
        
    var relationShip, preferredLanguage,  workStatus, education: ChoiceProperty
    var ethnicity, body, height, hairColor: ChoiceProperty
    var character, children, friends, pets: ChoiceProperty
    var liveWith, car, religion, smoke, drink, travel: ChoiceProperty
    
    private init(relationShip: ChoiceProperty, preferredLanguage: ChoiceProperty,
         workStatus: ChoiceProperty, education: ChoiceProperty,
         ethnicity: ChoiceProperty, body: ChoiceProperty,
         height: ChoiceProperty, hairColor: ChoiceProperty,
         character: ChoiceProperty, children: ChoiceProperty,
         friends: ChoiceProperty, pets: ChoiceProperty,
         liveWith: ChoiceProperty, car: ChoiceProperty,
         religion: ChoiceProperty, smoke: ChoiceProperty,
         drink: ChoiceProperty, travel: ChoiceProperty) {
        
        self.relationShip = relationShip
        self.preferredLanguage = preferredLanguage
        self.workStatus = workStatus
        self.education = education
        self.ethnicity = ethnicity
        self.body = body
        self.height = height
        self.hairColor = hairColor
        self.character = character
        self.children = children
        self.friends = friends
        self.pets = pets
        self.liveWith = liveWith
        self.car = car
        self.religion = religion
        self.smoke = smoke
        self.drink = drink
        self.travel = travel
        
    }
    
    convenience init(from dict: JSON) {
        let relationShip = dict.getChoice(type: .relationship, txt: .relationshipTxt)
        let preferredLanguage = dict.getChoice(type: .language, txt: .languageTxt)
        let workStatus = dict.getChoice(type: .workStatus, txt: .workStatusTxt)
        let education = dict.getChoice(type: .education, txt: .educationTxt)
        
        let ethnicity = dict.getChoice(type: .ethnicity, txt: .ethnicityTxt)
        let body = dict.getChoice(type: .body, txt: .bodyTxt)
        let height = dict.getChoice(type: .height, txt: .height)
        let hairColor = dict.getChoice(type: .hairColor, txt: .hairColorTxt)
        
        let character = dict.getChoice(type: .character, txt: .characterTxt)
        let children = dict.getChoice(type: .children, txt: .childrenTxt)
        let friends = dict.getChoice(type: .friends, txt: .friendsTxt)
        let pets = dict.getChoice(type: .pets, txt: .petsTxt)
        
        let liveWith = dict.getChoice(type: .liveWith, txt: .liveWithTxt)
        let car = dict.getChoice(type: .car, txt: .carTxt)
        let religion = dict.getChoice(type: .religion, txt: .religionTxt)
        let smoke = dict.getChoice(type: .smoke, txt: .smokeTxt)
        let drink = dict.getChoice(type: .drink, txt: .drinkTxt)
        let travel = dict.getChoice(type: .travel, txt: .travelTxt)
        
        self.init(
            relationShip: relationShip, preferredLanguage: preferredLanguage,
            workStatus: workStatus, education: education,
            ethnicity: ethnicity, body: body,
            height: height, hairColor: hairColor,
            character: character, children: children,
            friends: friends, pets: pets,
            liveWith: liveWith, car: car,
            religion: religion, smoke: smoke,
            drink: drink, travel: travel)
    }
    
    // txt values can not be taken from notification API
    convenience init(notifierDict dict: JSON) {
        let adminSettings = AppInstance.shared.adminSettings
        
        let languageKey = dict.getValue(key: .language, defaultValue: "")
        let language = adminSettings?.language[languageKey] ?? ""
        let preferredLanguage = (languageKey, language)
        
        let relationshipKey = dict.getValue(key: .relationship, defaultValue: "")
        let relationshipTxt = adminSettings?.relationship[relationshipKey] ?? ""
        let relationShip = (relationshipKey, relationshipTxt)
        
        let workStatusKey = dict.getValue(key: .workStatus, defaultValue: "")
        let workStatusTxt = adminSettings?.workStatus[workStatusKey] ?? ""
        let workStatus = (workStatusKey, workStatusTxt)
        
        let educationKey = dict.getValue(key: .education, defaultValue: "")
        let educationTxt = adminSettings?.education[educationKey] ?? ""
        let education = (educationKey, educationTxt)
        
        let ethnicityKey = dict.getValue(key: .ethnicity, defaultValue: "")
        let ethnicityTxt = adminSettings?.ethnicity[ethnicityKey] ?? ""
        let ethnicity = (ethnicityKey, ethnicityTxt)

        let bodyKey = dict.getValue(key: .body, defaultValue: "")
        let bodyTxt = adminSettings?.body[bodyKey] ?? ""
        let body = (bodyKey, bodyTxt)
        
        let heightKey = dict.getValue(key: .height, defaultValue: "")
        let heighTxt = adminSettings?.body[heightKey] ?? ""
        let height = (heightKey, heighTxt)

        let hairColorKey = dict.getValue(key: .hairColor, defaultValue: "")
        let hairColorTxt = adminSettings?.hairColor[hairColorKey] ?? ""
        let hairColor = (hairColorKey, hairColorTxt)

        let characterKey = dict.getValue(key: .character, defaultValue: "")
        let characterTxt = adminSettings?.character[characterKey] ?? ""
        let character = (characterKey, characterTxt)

        let childrenKey = dict.getValue(key: .children, defaultValue: "")
        let childrenTxt = adminSettings?.children[childrenKey] ?? ""
        let children = (childrenKey, childrenTxt)

        let friendsKey = dict.getValue(key: .friends, defaultValue: "")
        let friendsTxt = adminSettings?.friends[friendsKey] ?? ""
        let friends = (friendsKey, friendsTxt)

        let petsKey = dict.getValue(key: .pets, defaultValue: "")
        let petsTxt = adminSettings?.pets[petsKey] ?? ""
        let pets = (petsKey, petsTxt)

        let liveWithKey = dict.getValue(key: .liveWith, defaultValue: "")
        let liveWithTxt = adminSettings?.liveWith[liveWithKey] ?? ""
        let liveWith = (liveWithKey, liveWithTxt)

        let carKey = dict.getValue(key: .car, defaultValue: "")
        let carTxt = adminSettings?.car[carKey] ?? ""
        let car = (carKey, carTxt)

        let religionKey = dict.getValue(key: .religion, defaultValue: "")
        let religionTxt = adminSettings?.religion[religionKey] ?? ""
        let religion = (religionKey, religionTxt)

        let smokeKey = dict.getValue(key: .smoke, defaultValue: "")
        let smokeTxt = adminSettings?.smoke[smokeKey] ?? ""
        let smoke = (smokeKey, smokeTxt)

        let drinkKey = dict.getValue(key: .drink, defaultValue: "")
        let drinkTxt = adminSettings?.drink[drinkKey] ?? ""
        let drink = (drinkKey, drinkTxt)

        let travelKey = dict.getValue(key: .travel, defaultValue: "")
        let travelTxt = adminSettings?.travel[travelKey] ?? ""
        let travel = (travelKey, travelTxt)
        
        self.init(
            relationShip: relationShip, preferredLanguage: preferredLanguage,
            workStatus: workStatus, education: education,
            ethnicity: ethnicity, body: body,
            height: height, hairColor: hairColor,
            character: character, children: children,
            friends: friends, pets: pets,
            liveWith: liveWith, car: car,
            religion: religion, smoke: smoke,
            drink: drink, travel: travel)
    }
    
    fileprivate enum JSONKeys: String {
        case language, height, relationship, education, ethnicity, body, character
        case children, friends, pets, car, religion, smoke, drink, travel
        case languageTxt = "language_txt"
        case heightTxt = "height_txt"
        case hairColor = "hair_color"
        case hairColorTxt = "hair_color_txt"
        case relationshipTxt = "relationship_txt"
        case workStatus = "work_status"
        case workStatusTxt = "work_status_txt"
        case educationTxt = "education_txt"
        case ethnicityTxt = "ethnicity_txt"
        case bodyTxt = "body_txt"
        case characterTxt = "character_txt"
        case childrenTxt = "children_txt"
        case friendsTxt = "friends_txt"
        case petsTxt = "pets_txt"
        case liveWith = "live_with"
        case liveWithTxt = "live_with_txt"
        case carTxt = "car_txt"
        case religionTxt = "religion_txt"
        case smokeTxt = "smoke_txt"
        case drinkTxt = "drink_txt"
        case travelTxt = "travel_txt"
    }
}

extension ProfileFeatures: CustomStringConvertible {
    
    var description: String {
        var text = ""
        // workStatus
        text += createText(before: "",
                           feature: workStatus.text.htmlAttributedString ?? ".",
                           after: "")
        // relationShip
        text += createText(before: " I'm ",
                           feature: relationShip.text.htmlAttributedString ?? "",
                           after: "")
        // ethnicity
        if !ethnicity.text.isEmpty && !relationShip.text.isEmpty {
            text += " and a \(ethnicity.text.htmlAttributedString ?? "") person."
        } else if !ethnicity.text.isEmpty && relationShip.text.isEmpty {
            text += "I am a \(ethnicity.text.htmlAttributedString ?? "") person"
        }
        // body
        text += createText(before: " I'm a ", feature: body.text.lowercased(), after: "person")
        // height
        if !height.text.isEmpty && !body.text.isEmpty {
            text += " and \(height.text.htmlAttributedString ?? "") Cm tall."
        } else if !height.text.isEmpty && body.text.isEmpty {
            text += " I'm \(height.text.htmlAttributedString ?? "") Cm tall."
        } else {
            text += "."
        }
        // hairColor
        text += createText(before: " I have ",
                           feature: hairColor.text.lowercased().htmlAttributedString ?? "",
                           after: " hair.")
        // character
        text += createText(before: " I'm a ",
                           feature: character.text.lowercased().htmlAttributedString ?? "",
                           after: " person.")
        // friends
        if !friends.text.isEmpty && !character.text.isEmpty {
            text += " and have \(friends.text.lowercased().htmlAttributedString ?? "")."
        } else if !friends.text.isEmpty && character.text.isEmpty {
            text += " I have \(friends.text.lowercased().htmlAttributedString ?? "")."
        }
        // children
        text += createText(before: " My thought about children is that: ",
                           feature: children.text.htmlAttributedString ?? "",
                           after: ".")
               
        // religion
        text += createText(before: " I'm a ",
                           feature: religion.text.lowercased().htmlAttributedString ?? "",
                           after: ".")
        
        // liveWith
        if liveWith.text == "Alone" {
            text += " I live alone."
        } else if liveWith.text == "" {
            text += ""
        } else {
            text += " I live with \(liveWith.text.lowercased().htmlAttributedString ?? "")."
        }
        
        // smoke
        if smoke.text == "Never" {
            text += " I never smoke."
        } else if smoke.text == "" {
            text += ""
        } else {
            text += " My thought about smoking is that:)."
            text += " \(smoke.text.htmlAttributedString ?? "")."
        }
        
        // drink
        if drink.text == "Never" {
            text += " I never drink."
        } else if drink.text == "" {
            text += ""
        } else {
            text += " \(drink.text.htmlAttributedString ?? "")."
        }
        
        // pets
        if pets.text == "None" {
            text += " I don't have a pet."
        } else if pets.text == "" {
            text += ""
        } else {
            text += " I have \(pets.text.lowercased().htmlAttributedString ?? "")."
        }
        
        // car
        if car.text == "None" {
            text += " I don't have a car."
        } else if car.text == "" {
            text += ""
        } else {
            text += " I have \(car.text.lowercased().htmlAttributedString ?? "")."
        }
        
        return text
                           
    }
                        
    private func createText(before beforeText: String,
                            feature: String,
                            after afterText: String) -> String {
        guard let featureText = feature.htmlAttributedString else {
            Logger.error("getting feature"); return ""
        }
        
        return feature.isEmpty
        ? ""
        : "\(beforeText)\(featureText)\(afterText)"
    }
}


extension JSON {
    /// Get Choice Property which has early set choices from server and its texts to provide clear code
    /// - Parameters:
    ///   - dict: JSON value from server
    ///   - keys: type and text key
    /// - Returns: [ChoiceProperty](x-source-tag://ChoiceProperty)
    fileprivate func getChoice(type: ProfileFeatures.JSONKeys,
                               txt: ProfileFeatures.JSONKeys) -> ChoiceProperty {
        let type = self[type.rawValue] as? String ?? ""
        let text = self[txt.rawValue] as? String ?? ""
        return (type, text)
    }
    
    fileprivate func getValue<T>(key: ProfileFeatures.JSONKeys, defaultValue: T) -> T {
        return self[key.rawValue] as? T ?? defaultValue
    }
}
