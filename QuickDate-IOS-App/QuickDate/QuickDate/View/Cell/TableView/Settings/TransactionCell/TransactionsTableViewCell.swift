//
//  TransactionsTableViewCell.swift
//  QuickDate
//
//  Created by iMac on 01/11/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPaymentName: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTransactionsData(modelObject: TransactionsData) {
        let price = modelObject.amount ?? 0
        var planValue = ""
        if price == 8 {
            planValue = "Weekly"
        } else if price == 25 {
            planValue = "Monthly"
        } else if price == 280 {
            planValue = "Yearly"
        }
        else if price == 500 {
            planValue = "Lifetime"
        }
        lblPaymentName.text = modelObject.via ?? ""
        lblDateTime.text = modelObject.date ?? ""
        lblPaymentType.text = (modelObject.type ?? "") + " - \(planValue)"
        lblPrice.text = "\(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")\(price)"
    }
}
