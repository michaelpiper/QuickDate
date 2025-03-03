//
//  TwoFactorPopupVC.swift
//  QuickDate
//
//  Created by iMac on 21/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class TwoFactorPopupVC: UIViewController {
    
    var delegate : TwoFactorTypePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enablePressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.selectedType("Enable")
        }
    }
    
    @IBAction func disablePressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.selectedType("Disable")
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

     
