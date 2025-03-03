//
//  AppPaymentEnum.swift
//  QuickDate
//
//  Created by iMac on 31/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import UIKit

enum CreditCardType {

    case visa
    case visaElectron
    case mastercard
    case maestro
    case americanExpress
//    case dinnersClub
//    case discovery
//    case jcb

    static var all: [CreditCardType] {
        return [
            .visa,
            .visaElectron,
            .mastercard,
            .maestro,
            .americanExpress
        ]
    }
    
    func getCardImage(type: CreditCardType) -> UIImage?{
        switch type {
        case .visa:
            return UIImage(named: "ic_visa")
        case .visaElectron:
            return UIImage(named: "ic_visa_electron")
        case .mastercard:
            return UIImage(named: "ic_mastercardpng")
        case .maestro:
            return UIImage(named: "ic_maestro")
        case .americanExpress:
            return UIImage(named: "ic_american_express")
        }
    }

    var pattern: String {
        switch self {
        case .visa: return "^4[0-9]{6,}$"
        case .visaElectron: return "^(4026|417500|4508|4844|491(3|7))"
        case .mastercard: return "^5[1-5][0-9]{14}$"
        case .maestro: return "^(5018|5020|5038|6304|6759|676[1-3])"
        case .americanExpress: return "^3[47][0-9]{13}$"
//        case .dinnersClub: return "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
//        case .discovery: return "^6(?:011|5[0-9]{2})[0-9]{12}$"
//        case .jcb: return "^(?:2131|1800|35\\d{3})\\d{11}$"
        }
    }
}

struct Validator {
    let cardType: CreditCardType
    let value: String

    func test() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: cardType.pattern, options: .caseInsensitive)
            return regex.matches(in: value, options: [], range: NSMakeRange(0, value.count)).isEmpty == false
        } catch {
            return false
        }
    }
}

struct CreditCardTypeChecker {
    static func type(for value: String) -> CreditCardType? {
        for creditCardType in CreditCardType.all {
            if isValid(for: creditCardType, value: value) {
                return creditCardType
            }
        }
        return nil
    }
    
    private static func isValid(for cardType: CreditCardType, value: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: cardType.pattern,
                                                options: .caseInsensitive)
            return regex.matches(in: value,
                                 options: [],
                                 range: NSMakeRange(0, value.count)).count > 0
        } catch {
            return false
        }
    }
}

