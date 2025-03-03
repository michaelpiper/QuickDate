

import UIKit
import Alamofire
import Async
import BraintreeDropIn
import Braintree
import Stripe
import QuickDateSDK
import AuthorizeNetAccept

/// - Tag: PayVC
class PayVC: BaseViewController,UITextFieldDelegate  {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var continueLabel: UIButton!
    
    var payInfo: PayingInformation?
    
    var payType:String? = "membership"
    var Description:String? = "CraditCard"
    var amount:Int? = 100
    var memberShipType:Int? = 0
    var credits:Int? = 0
    var paymentType:String? = ""
    var isAuthorizeNet: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yearTextField.delegate = self
        cardNumberTextField.delegate = self
        self.setupUI()
    }
    
    private func setupUI(){
        self.cardView.backgroundColor = UIColor.hexStringToUIColor(hex: "FF007F")
        self.continueLabel.backgroundColor = UIColor.hexStringToUIColor(hex: "FF007F")
        if isAuthorizeNet {
            self.creditLabel.text = NSLocalizedString("AuthorizeNet", comment: "AuthorizeNet")
        } else {
            self.creditLabel.text = NSLocalizedString("Credit Card", comment: "Credit Card")
        }
        self.cardNumberTextField.placeholder =  NSLocalizedString("Enter your card number", comment: "Enter your card number")
        self.yearTextField.placeholder = NSLocalizedString("MMYY", comment: "MMYY")
        cvvTextField.placeholder = NSLocalizedString("CVV", comment: "CVV")
        continueLabel.setTitle(NSLocalizedString("Continue", comment: "Continue"), for: .normal)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if !isAuthorizeNet {
            self.getStipeToken()
        } else {
            self.payAuthorizeNetAcceptPayment()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
        self.tabBarController?.tabBar.isHidden = true
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(hide: false)
        self.tabBarController?.tabBar.isHidden = false
        showTabBar()
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func payAuthorizeNetAcceptPayment() {
        let expiryParameters = yearTextField.text?.components(separatedBy: "/")
        let params = [
            "access_token": AppInstance.shared.accessToken ?? "",
             "type": "credit",
            "card_number": self.cardNumberTextField.text ?? "",
            "card_month": expiryParameters?.first ?? "0",
            "card_year": expiryParameters?.last ?? "0",
            "price": self.payInfo?.amount ?? 0,
            "card_cvc": cvvTextField.text ?? ""
            ] as [String : Any]
        
        PaymentManager.instance.authorizePaySuccess(params: params) { json, error in
            guard error == nil else {
                self.displayDefaultAlert(title:NSLocalizedString("Error", comment: "Error"), message: error ?? "Error")
                return
            }
            self.displayDefaultAlert(title:NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("The AuthorizeNet transaction was complete.", comment: "The AuthorizeNet transaction was complete"))
        }
        print(params)
    }
    
    private func getStipeToken(){
        self.showProgressDialog(with: "Loading...")
        let stripeCardParams = STPCardParams()
        stripeCardParams.number = self.cardNumberTextField.text
        let expiryParameters = yearTextField.text?.components(separatedBy: "/")
        stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
        stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
        stripeCardParams.cvc = cvvTextField.text
        let config = STPPaymentConfiguration.shared
        let stpApiClient = STPAPIClient.init(configuration: config)
        stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
            if error == nil {
                Async.main({
                    Logger.verbose("Token = \(token?.tokenId ?? "")")
                    self.payStipe(stripeToken: token?.tokenId ?? "")
                })
            } else {
                self.dismissProgressDialog {
                    self.view.makeToast(error?.localizedDescription ?? "")
                    Logger.verbose("Error = \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    private func payStipe(stripeToken:String){
        //        tok_visa
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let payTypeString = self.payType ?? ""
            let descriptionString = self.Description ?? ""
            let amountInt = self.amount ?? 0
            self.paymentType = "stripe"
            Async.background({
                PayStripeManager.instance.payStripe(params: [:], completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            if payTypeString == "membership"{
                                self.setPro(through: "stripe")
                            }else{
                                self.setCredit(through: "stripe")
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
    private func setPro(through:String){
        if paymentType == "paypal"{
            self.showProgressDialog(with: "Loading...")
        }
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let amountInt = self.amount ?? 0
            let membershipTypeInt = self.memberShipType ?? 0
            
            Async.background({
                SetProManager.instance.setPro(AccessToken: accessToken, Type: membershipTypeInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                                
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
    private func setCredit(through:String){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let amountInt = self.amount ?? 0
            let creditInt = self.credits ?? 0
            Async.background({
                SetCreditManager.instance.setPro(AccessToken: accessToken, Credits: creditInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if yearTextField == textField {
            if string == "" {
                return true
            }
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            textField.text = updatedText
            let numberOfCharacters = updatedText.count
            if numberOfCharacters == 2 {
                textField.text?.append("/")
            }
            return false
        } else if cardNumberTextField == textField {
            if let typeValue = CreditCardTypeChecker.type(for: cardNumberTextField.text ?? "") {
                let v = Validator(cardType: typeValue, value: cardNumberTextField.text ?? "")
                if v.test() {
                    cardImage.image = typeValue.getCardImage(type: typeValue)
                } else {
                    cardImage.image = UIImage(named: "ic_no_credit_card")
                }
            } else {
                cardImage.image = UIImage(named: "ic_no_credit_card")
            }
        }
        return true
    }
}

//ic_no_credit_card

