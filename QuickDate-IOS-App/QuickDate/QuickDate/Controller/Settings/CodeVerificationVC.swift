//
//  CodeVerificationVC.swift
//  QuickDate
//
//  Created by iMac on 10/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class CodeVerificationVC: BaseViewController {

    @IBOutlet var otpTF1: UITextField!
    @IBOutlet var otpTF2: UITextField!
    @IBOutlet var otpTF3: UITextField!
    @IBOutlet var otpTF4: UITextField!
    
    @IBOutlet var lineView1: UIView!
    @IBOutlet var lineView2: UIView!
    @IBOutlet var lineView3: UIView!
    @IBOutlet var lineView4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }    
    
    func textFieldSetup() {
        otpTF1.delegate = self
        otpTF2.delegate = self
        otpTF3.delegate = self
        otpTF4.delegate = self
        
        otpTF1.becomeFirstResponder()
        
        self.otpTF1.placeholder = nil
        self.otpTF2.placeholder = nil
        self.otpTF3.placeholder = nil
        self.otpTF4.placeholder = nil
    }
}


    //MARK: - Extensions -
    /// UITextField Delegate Methods
extension CodeVerificationVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text
        guard let stringRange  = Range(range, in: currentText!) else{
            return false
        }
        let updatedString = currentText!.replacingCharacters(in: stringRange, with: string)
        if updatedString.count >= 1{
//            codeErrorView.isHidden = true
            switch textField{
            case otpTF1:
                otpTF1.text = string
                otpTF1.textColor = UIColor.PrimaryColor
                lineView1.backgroundColor = UIColor.PrimaryColor
                otpTF2.becomeFirstResponder()
            case otpTF2:
                otpTF2.text = string
                otpTF2.textColor = UIColor.PrimaryColor
                lineView2.backgroundColor = UIColor.PrimaryColor
                otpTF3.becomeFirstResponder()
            case otpTF3:
                otpTF3.text = string
                otpTF3.textColor = UIColor.PrimaryColor
                lineView3.backgroundColor = UIColor.PrimaryColor
                otpTF4.becomeFirstResponder()
            case otpTF4:
                otpTF4.text = string
                otpTF4.textColor = UIColor.PrimaryColor
                lineView4.backgroundColor = UIColor.PrimaryColor
//                self.view.endEditing(true)
//                verifyOTPApi()
            default:
                break
            }
            return false
        }
        
        if string.count > 0 {
//            codeErrorView.isHidden = true
            switch textField{
            case otpTF1:
                otpTF1.text = string
                otpTF2.becomeFirstResponder()
            case otpTF2:
                otpTF2.text = string
                otpTF3.becomeFirstResponder()
            case otpTF3:
                otpTF3.text = string
                otpTF4.becomeFirstResponder()
            case otpTF4:
                otpTF4.text = string
//                self.view.endEditing(true)
            default:
                break
            }
            return false
        }
        
        if string.count == 0 {
//            codeErrorView.isHidden = false
            switch textField {
            case otpTF1:
                otpTF1.text = string
                lineView1.backgroundColor = UIColor.lightGray
                otpTF1.becomeFirstResponder()
            case otpTF2:
                otpTF2.text = string
                lineView2.backgroundColor = UIColor.lightGray
                otpTF1.becomeFirstResponder()
            case otpTF3:
                otpTF3.text = string
                lineView3.backgroundColor = UIColor.lightGray
                otpTF2.becomeFirstResponder()
            case otpTF4:
                otpTF4.text = string
                otpTF3.becomeFirstResponder()
                lineView4.backgroundColor = UIColor.lightGray
            default:
                break
            }
            return false
        } else if textField.text!.count >= 1 && string.count == 0 {
            textField.text = string
            return false
        }else{
            return false
        }
    }
}

