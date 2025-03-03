//
//  PaymentCardVC.swift
//  Playtube
//
//  Created by iMac on 19/06/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import Stripe
import QuickDateSDK

protocol PaymentCardViewDelegate {
    func cardView(_ isSuccess: Bool)
}

class PaymentCardVC: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: FloatingTextField!
    @IBOutlet weak var cvvTextField: FloatingTextField!
    @IBOutlet weak var yearTextField: FloatingTextField!
    @IBOutlet weak var nameTextField: FloatingTextField!
    @IBOutlet weak var postalCodeTextField: FloatingTextField!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblErrorCardNumber: UILabel!
    @IBOutlet weak var lblCvv: UILabel!
    @IBOutlet weak var lblErrorCvv: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblErrorYear: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    
    var paymentType: PaymentName = .creditCard
    var amount: Int = 0
    var delegate: PaymentCardViewDelegate?
    var payType:String = ""
    var memberShipType:Int = 0
    var credits:Int = 0
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cardNumberTextField.setTitle(title: "Card Number")
        self.cvvTextField.setTitle(title: "CVV")
        self.yearTextField.setTitle(title: "Year")
        self.postalCodeTextField.setTitle(title: "Postal Code")
        self.nameTextField.setTitle(title: "Name On Card")
        self.initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
        
    // MARK: - Selectors
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Continue Button Action
    @IBAction func continueButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if paymentType == .authorizeNet {
            self.payAuthorizeNetAcceptPayment()
            return
        }
        if paymentType == .creditCard {
            self.getStripeToken()
            return
        }
    }
        
    // MARK: - Helper Functions
    
    // Initial Config
    func initialConfig() {
        self.setData()
    }
    
    // Set Data
    func setData() {
        self.cardNumberTextField.delegate = self
        self.yearTextField.delegate = self
        self.cvvTextField.delegate = self
        self.nameTextField.delegate = self
        self.lblErrorCardNumber.text = "Your card's number is invalid."
        self.lblErrorCvv.text = "Your card's security code is invalid."
        self.lblErrorYear.text = "Your card's expiration year is invalid."
        if paymentType == .authorizeNet {
            self.headerLabel.text = "AuthorizeNet"
        }
        if paymentType == .creditCard {
            self.headerLabel.text = "Credit Card"
        }
    }
}

// MARK: - Extensions

// MARK: Stripe Setup
extension PaymentCardVC {
    private func getStripeToken() {
        self.showProgressDialog(with: "Loading...")
        let stripeCardParams = STPCardParams()
        stripeCardParams.number = self.cardNumberTextField.text
        let expiryParameters = yearTextField.text?.components(separatedBy: "/")
        stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
        stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
        stripeCardParams.cvc = cvvTextField.text
        _ = STPPaymentConfiguration.shared
        let stpApiClient = STPAPIClient(publishableKey: ControlSettings.stripeId)
        stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
            if error == nil {
                Async.main({
                    print("Token = \(token?.tokenId ?? "")")
                    if let stripeToken = token?.tokenId {
                        self.createStripeSession(stripeToken: stripeToken)
                    }
                })
            } else {
                self.dismissProgressDialog {
                    self.view.makeToast(error?.localizedDescription ?? "")
                    print("Error = \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    func createStripeSession(stripeToken: String) {
        let params : JSON = [
            API.PARAMS.access_token: AppInstance.shared.accessToken ?? "",
            API.PARAMS.price: self.amount
        ]
        PaymentManager.instance.createStripeSession(params: params) { success, error in
            if let error = error {
                self.view.makeToast(error)
                return
            }else{
                print(success ?? [:])
                if let hash_id = success?["hash"] as? String {
                    print(hash_id)
                    self.createStripeSuccessAPI(stripeToken: stripeToken, hash_id: hash_id)
                }
            }
        }
    }
    
    func createStripeSuccessAPI(stripeToken: String, hash_id: String) {
        let params : JSON = [
            API.PARAMS.access_token: AppInstance.shared.accessToken ?? "",
            API.PARAMS.price: self.amount,
            "hash" : hash_id,
            "stripeToken": stripeToken
        ]
        PaymentManager.instance.createStripeSuccess(params: params) { success, error in
            if let error = error {
                self.view.makeToast(error)
                return
            }else{
                print(success ?? [:])
                if let message = success?["message"] as? String {
                    self.view.makeToast(message)
                    if self.payType == "go_pro" {
                        self.setPro(through: "stripe")
                    }else{
                        self.setCredit(through: "stripe")
                    }
                }
            }
        }
    }
    
    private func setPro(through:String) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let amountInt = self.amount
            let membershipTypeInt = self.memberShipType
            
            Async.background({
                SetProManager.instance.setPro(AccessToken: accessToken, Type: membershipTypeInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                                self.delegate?.cardView(true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    private func setCredit(through:String) {
//        self.showProgressDialog(with: "Loading...")
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let amountInt = self.amount
            let creditInt = self.credits
            Async.background({
                SetCreditManager.instance.setPro(AccessToken: accessToken, Credits: creditInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
//                                AppManager.shared.fetchUserProfile()
                                self.navigationController?.popViewController(animated: true)
                                self.delegate?.cardView(true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}

// MARK: Authorize Net Api Call
extension PaymentCardVC {
    private func payAuthorizeNetAcceptPayment() {
        self.showProgressDialog(with: "Loading...")
        let expiryParameters = yearTextField.text?.components(separatedBy: "/") ?? []
        let params = [
            API.PARAMS.access_token: AppInstance.shared.accessToken ?? "",
            "type": self.payType,
            "card_number": cleanCreditCardNo(self.cardNumberTextField.text ?? ""),
            "card_month": expiryParameters[0],
            "card_year": expiryParameters[1],
            "price": "\(self.amount)",
            "card_cvc": cvvTextField.text ?? ""
        ] as [String : Any]
        print(params)
        PaymentManager.instance.createAuthorizeNetSession(params: params) { json, error in
            if let error = error {
                Async.main {
                    self.dismissProgressDialog {
                        self.view.makeToast(error)
                        return
                    }
                }
            } else {
                Async.main {
                    self.dismissProgressDialog {
                        if let message = json?["message"] as? String {
                            self.appDelegate.window?.rootViewController?.view.makeToast(message)
                            if self.payType == "go_pro" {
                                self.setPro(through: "authorizeNet")
                            }else{
                                self.setCredit(through: "authorizeNet")
                            }
//                            self.navigationController?.popViewController(animated: true)
//                            self.delegate?.cardView(true)
                        }
                    }
                }
            }
        }
    }
}

// MARK: UITextFieldDelegate Methods
extension PaymentCardVC: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if cardNumberTextField == textField {
            self.cardNumberTextField.text = textField.text?.formattedCreditCard
            if self.cardNumberTextField.text == "" {
                self.lblCardNumber.text = "**** **** **** ****"
            }else {
                self.lblCardNumber.text = self.cardNumberTextField.text?.formattedCreditCard
            }
            guard let numberAsString = textField.text else { return }
            self.lblErrorCardNumber.isHidden = self.isCardNumberValid2(numberAsString)
            let recognizedType = CCValidator.typeCheckingPrefixOnly(creditCardNumber: numberAsString)
            //check if type is e.g. .Visa, .MasterCard or .NotRecognized
            print(recognizedType.name)
            cardImageView.image = recognizedType.image
        }
        
        if yearTextField == textField {
            if self.yearTextField.text == "" {
                self.lblYear.text = "MM/YYYY"
            }else {
                self.lblYear.text = textField.text?.formattedExpiredDate
            }
            self.lblErrorYear.isHidden = self.isExpDateValid(self.yearTextField.text?.formattedExpiredDate ?? "")
        }
        
        if cvvTextField == textField {
            cvvTextField.text = textField.text?.formattedCvv
            if self.cvvTextField.text == "" {
                self.lblCvv.text = "***"
            }else{
                self.lblCvv.text = self.cvvTextField.text?.formattedCvv
            }
            self.lblErrorCvv.isHidden = self.isCvvValid(self.cvvTextField.text?.formattedCvv)
        }
        
        if nameTextField == textField {
            self.nameTextField.text = textField.text
            if self.nameTextField.text == "" {
                self.lblName.text = "Your Name"
            }else{
                self.lblName.text = self.nameTextField.text
            }
            self.lblErrorCvv.isHidden = self.isCvvValid(self.cvvTextField.text?.formattedCvv)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == cardNumberTextField) {
            return newLength <= 19
        }
        
        if yearTextField == textField {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: r, with: string)
            
            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
            } else if updatedText.count == 2 {
                if updatedText <= "12" { //Prevent user to not enter month more than 12
                    textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
                }
                return false
            } else if updatedText.count == 7 {
                //                    return true
            } else if updatedText.count > 7 {
                return false
            }
        }
        return true
    }
    
}

extension PaymentCardVC {
    
    public  func cleanCreditCardNo(_ creditCardNo: String) -> String {
        return creditCardNo.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    public  func isCardNumberValid2(_ cardNumber: String) -> Bool {
        let recognizedType = CCValidator.validate(creditCardNumber: cardNumber)
        return recognizedType
    }
    
    public  func isCardNumberValid(_ cardNumber: String?) -> Bool {
        guard let cardNumber = cardNumber else {
            return false
        }
        let number = cardNumber.onlyNumbers()
        guard number.count >= 14 && number.count <= 19 else {
            return false
        }
        
        var digits = number.map { Int(String($0))! }
        stride(from: digits.count - 2, through: 0, by: -2).forEach { i in
            var value = digits[i] * 2
            if value > 9 {
                value = value % 10 + 1
            }
            digits[i] = value
        }
        
        let sum = digits.reduce(0, +)
        return sum % 10 == 0
    }
    
    public func isExpDateValid(_ dateStr: String) -> Bool {
        
        let currentYear = Calendar.current.component(.year, from: Date())   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateStr.suffix(4)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                return true
            } else {
                return false
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    public  func isCvvValid(_ cvv: String?) -> Bool {
        guard let cvv = cvv else {
            return false
        }
        if (cvv.count == 3) {
            return true
        }
        return false
    }
}

extension String {
    func onlyNumbers() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var formattedCreditCard: String {
        return format(with: CardTextField.cardNumber, phone: self)
    }
    
    var formattedExpiredDate: String {
        return format(with: CardTextField.dateExpiration, phone: self)
    }
    
    var formattedCvv: String {
        return format(with: CardTextField.cvv, phone: self)
    }
    
    func format(with maskType: CardTextField, phone: String) -> String {
        let mask = maskType.mask
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

public enum CardTextField {
    case cardNumber
    case cvv
    case cardHolder
    case dateExpiration
    
    var mask: String {
        switch self {
        case .cardNumber:
            return "XXXX XXXX XXXX XXXX"
        case .cvv:
            return "XXX"
        case .cardHolder:
            return ""
        case .dateExpiration:
            return "XX/XXXX"
        }
    }
}
