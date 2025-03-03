//
//  PayStackEmailPopupVC.swift
//  Playtube
//
//  Created by iMac on 17/06/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Toast_Swift


protocol PayStackEmailPopupVCDelegate {
    func handlePayStackPayNowButtonTap(email: String)
}

class PayStackEmailPopupVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var payNowButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lineView: UIView!
    
    // MARK: - Properties
    
    var delegate: PayStackEmailPopupVCDelegate?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialConfig()
    }
    
    // MARK: - Selectors
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Pay Now Button Action
    @IBAction func payNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.makeToast("Please enter your email")
            return
        }
        if let email = emailTextField.text {
            self.dismiss(animated: true)
            self.delegate?.handlePayStackPayNowButtonTap(email: email)
        }
    }
    
    // MARK: - Helper Functions -
    
    // Initial Config
    func initialConfig() {
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        self.setUserData()
    }
    
    // Set User Data
    func setUserData() {
        self.emailTextField.text = AppInstance.shared.userProfileSettings?.email ?? ""
    }
    
}
