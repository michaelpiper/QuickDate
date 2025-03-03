//
//  WithdrawalsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

class WithdrawalsVC: BaseViewController {
    
    //MARK: - Properties -
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var widthdrawalLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var typeLabel: UITextField!
    
    @IBOutlet weak var emailTextView: UIView!
    @IBOutlet weak var amountTextView: UIView!
    
    var email: String? = ""
    
    //MARK: - Life Cycle Functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK: - Helper Functions -
    
    func configView() {
        emailTextField.delegate = self
        amountText.delegate = self
        
        emailTextField.tintColor = .PrimaryColor
        amountText.tintColor = .PrimaryColor
        
        emailTextView.borderWidthV = 1
        amountTextView.borderWidthV = 1
        
        emailTextView.borderColorV = .clear
        amountTextView.borderColorV = .clear
        
    }
    
    private func setupUI() {
        self.amountView.addShadow()
        self.balanceLabel.text = NSLocalizedString("MY BALANCE", comment: "MY BALANCE")
        self.amountText.placeholder = NSLocalizedString("Amount", comment: "Amount")
        self.emailTextField.placeholder = NSLocalizedString("PayPal E-mail", comment: "PayPal E-mail")
        self.amountLabel.text = "\(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")" + "\(AppInstance.shared.userProfileSettings?.balance ?? 0.0)"
    }
    
    //MARK: - Selectors -
    @IBAction func backPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paymentOptionsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.popUps.withdrawalMethodPopupVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let amountValue = self.amountText.text ?? ""
        let accessToken = AppInstance.shared.accessToken ?? ""
        if Int(amountValue) ?? 0 >= 50 && !self.emailTextField.text!.isEmpty, self.typeLabel.text?.trimmingCharacters(in: .whitespaces).count != 0 {
            self.showProgressDialog(with: "Loading...")
            let email = self.emailTextField.text ?? ""
            Async.background({
                WithdrawalsManager.instance.requestWithdrawals(AccessToken: accessToken, withdraw_method: self.typeLabel.text ?? "", amount: amountValue, email: email) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription)
                            }
                        })
                    }
                }
            })
        } else if self.typeLabel.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.makeToast(NSLocalizedString("Please select Payment Method.", comment: "Please select Payment Method."))
        } else if amountValue == "" {
            self.view.makeToast(NSLocalizedString("Please enter amount.", comment: "Please enter amount."))
        } else if self.emailTextField.text!.isEmpty {
            self.view.makeToast(NSLocalizedString("Please enter email.", comment: "Please enter email."))
        } else if !self.emailTextField.text!.isEmail {
            self.view.makeToast(NSLocalizedString("Email is badly formatted.", comment: "Email is badly formatted."))
        } else {
            self.view.makeToast(NSLocalizedString("Amount shouldn't be less than 50.", comment: "Amount shouldn't be less than 50."))
        }
    }
}

//MARK: - Withdrawal Method Popup Delegate Methods -
extension WithdrawalsVC: WithdrawalMethodPopupDelegate {
    func selectedMethod(_ selected: String) {
        self.typeLabel.text = selected
    }
}

extension WithdrawalsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextView.borderColorV = .PrimaryColor
        } else if textField == amountText {
            amountTextView.borderColorV = .PrimaryColor
        }
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmpty = textField.text?.trimmingCharacters(in: .whitespaces).count == 0
        if textField == emailTextField {
            emailTextView.borderColorV = .clear
        } else if textField == amountText {
            amountTextView.borderColorV = .clear
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
