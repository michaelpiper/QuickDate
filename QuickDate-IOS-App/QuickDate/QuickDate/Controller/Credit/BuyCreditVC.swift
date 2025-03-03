
import UIKit
import PassKit
import Async
import StoreKit
import QuickDateSDK

struct dataSet{
    var title:String?
    var bgColor:UIColor?
    var bgImage:UIImage?
}
struct dataSetTwo{
    var title:String?
    var Credit:String?
    var itemImage:UIImage?
    var ammount:String?
}

class BuyCreditVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let product_id: NSString = "com.some.inappid"
    var index = 0
    var dataSetArray = [dataSet]()
    var delegate: BuyCreditDelegate?
    var paymentRequest: PKPaymentRequest!
    var transactionId = ""
    var status = ""
    var amount = 100
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    var myProduct:SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        fetchProducts()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }*/
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setupUI(){
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(resource: R.nib.buyCreditSectionTableItem), forCellReuseIdentifier: R.reuseIdentifier.buyCreditSectionTableItem.identifier)
        self.tableView.register(UINib(resource: R.nib.buyCreditSectionTwoTableItem), forCellReuseIdentifier: R.reuseIdentifier.buyCreditSectionTwoTableItem.identifier)
        self.tableView.register(UINib(resource: R.nib.buyCreditSectionThreeTableItem), forCellReuseIdentifier: R.reuseIdentifier.buyCreditSectionThreeTableItem.identifier)
        
    }
    
    func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: [""])
        request.delegate = self
        request.start()
    }
    func setupApplePay(description: String, amount: Int) {
        paymentRequest = PKPaymentRequest()
        paymentRequest.currencyCode = "USD"
        paymentRequest.countryCode = "US"
        paymentRequest.merchantIdentifier = "merchant.com.ScriptSun.QuickDateiOS.App"
        // Payment networks array
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
        paymentRequest.supportedNetworks = paymentNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        let item = PKPaymentSummaryItem(label: "Order Total", amount: NSDecimalNumber(string: "\(amount)"))
        paymentRequest.paymentSummaryItems = [item]
        let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        applePayVC!.delegate = self
        self.present(applePayVC!, animated: true, completion: nil)
        
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewWillLayoutSubviews() {
        //        self.topView.halfCircleView()
    }
    
    @IBAction func termConditionPressed(_ sender: UIButton) {
        
    }
    @IBAction func skipCreditPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startCheckout(amount:Int,credit:Int) {
        braintreeClient = BTAPIClient(authorization: ControlSettings.paypalAuthorizationToken)!
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
//        payPalDriver.viewControllerPresentingDelegate = self
//        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalCheckoutRequest(amount: "\(amount)")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                _ = tokenizedPayPalAccount.email
                _ = tokenizedPayPalAccount.firstName
                _ = tokenizedPayPalAccount.lastName
                _ = tokenizedPayPalAccount.phone
                _ = tokenizedPayPalAccount.billingAddress
                _ = tokenizedPayPalAccount.shippingAddress
                
                
                self.setCredit(through: "paypal", amount: amount, credit: credit)
                
            } else if let error = error {
                Logger.verbose("error = \(error.localizedDescription )")
            } else {
                Logger.verbose("error = \(error?.localizedDescription ?? "")")
            }
        }
    }
    private func setCredit(through:String,amount:Int,credit:Int){
        
        self.showProgressDialog(with: "Loading...")
        
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let amountInt = amount
            let creditInt = credit
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
}

extension BuyCreditVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title:NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("The Apple Pay transaction was complete.", comment: "The Apple Pay transaction was complete."))
    }
}
// MARK: - TableView

extension BuyCreditVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:return 1
        case 1:return 1
        case 2:return 1
        default: return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.buyCreditSectionTableItem.identifier) as? BuyCreditSectionTableItem
            cell?.selectionStyle = .none
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.buyCreditSectionTwoTableItem.identifier) as? BuyCreditSectionTwoTableItem
            cell?.selectionStyle = .none
            cell?.delegate = self
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.buyCreditSectionThreeTableItem.identifier) as? BuyCreditSectionThreeTableItem
            cell?.selectionStyle = .none
            cell?.vc = self
            return cell!
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 375
        case 2:
            return UITableView.automaticDimension
        default:
            return 0//300
        }
    }
}

extension BuyCreditVC:SKProductsRequestDelegate,SKPaymentTransactionObserver{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first{
            self.myProduct = product
            Logger.verbose("product identifier = \(product.productIdentifier)")
            Logger.verbose("product price = \(product.price)")
            Logger.verbose("product title = \(product.localizedTitle)")
            Logger.verbose("product description = \(product.localizedDescription)")
            
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        Logger.verbose("transaction.transactionDate = \(transactions[0].transactionDate ?? Date())")
        //        for transaction in transactions{
        //            switch transaction.transactionDate {
        //            case .purchasing:
        //                <#code#>
        //            default:
        //                <#code#>
        //            }
        //        }
        
    }
}

extension BuyCreditVC: BuyCreditDelegate {
    func selectedCreditType(_ index: Int, Amount: Int) {
        self.dismiss(animated: true) {
            self.delegate?.selectedCreditType(index, Amount: Amount)
        }
    }
}
