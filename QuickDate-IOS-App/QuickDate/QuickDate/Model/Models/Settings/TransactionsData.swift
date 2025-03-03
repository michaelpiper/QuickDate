//
//  TransactionsData.swift
//  QuickDate
//
//  Created by iMac on 01/11/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// MARK: - TransactionsData
struct TransactionsData: Codable {
    let id, userID, amount: Int?
    let type, date, proPlan, creditAmount: String?
    let via: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case amount, type, date
        case proPlan = "pro_plan"
        case creditAmount = "credit_amount"
        case via
    }
}
