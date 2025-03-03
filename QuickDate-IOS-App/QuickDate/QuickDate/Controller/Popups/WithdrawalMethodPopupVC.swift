//
//  WithdrawalMethodPopupVC.swift
//  QuickDate
//
//  Created by iMac on 20/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class WithdrawalMethodPopupVC: UIViewController {
    
    var delegate : WithdrawalMethodPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func paypalPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.selectedMethod("Paypal")
        }
    }
    
    @IBAction func bankPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.selectedMethod("Bank")
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

     
