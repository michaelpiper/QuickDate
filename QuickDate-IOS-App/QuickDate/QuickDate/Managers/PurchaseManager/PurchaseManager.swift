//
//  PurchaseManager.swift
//  
//
//  Created by ScriptSun on 9/30/20.
//

import Foundation
import StoreKit

/// Aliases for completion blocks and product id
public typealias ProductID = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
public typealias ProductPurchaseCompletionHandler = (_ success: Bool, _ productId: ProductID?) -> Void

/// IMPORTANT: Replace the proVersion identifier with the one from App Store connect
/// Also you must replace `com.a4w.Quiz` with your App's Bundle Identifier


public struct InAppProducts {
    public static let proVersion = ""
    public static let store = A4WPurchaseManager(productIDs: InAppProducts.productIDs)
    public static let productIDs: Set<ProductID> = [InAppProducts.proVersion]
}

/// Resource name for product id
public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

// Main Purchase Manager class to handle in-app purchases
public class A4WPurchaseManager: NSObject {

    static let shared = A4WPurchaseManager(productIDs: InAppProducts.productIDs)
    private let productIDs: Set<ProductID>
    private var purchasedProductIDs: Set<ProductID>
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?
    private static var inAppProducts: [SKProduct]?
    var didPurchaseProduct: Bool = false
    
    public init(productIDs: Set<ProductID>) {
        self.productIDs = productIDs
        self.purchasedProductIDs = productIDs.filter { productID in
            let purchased = UserDefaults.standard.bool(forKey: productID)
            if purchased {
                print("Previously purchased: \(productID)")
            } else {
                print("Not purchased: \(productID)")
            }
            return purchased
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    /// Get the value from userDefaults to see if user purchased the pro version before
    var didPurchaseProVersion: Bool {
        return didPurchaseProduct || UserDefaults.standard.bool(forKey: "didPurchaseProVersion")
    }
    
    /// Initialize the purchase manager
    func initialize() {
        if didPurchaseProVersion {
            print("PRO Version has been purchased before")
        }
        InAppProducts.store.requestProducts { (success, products) in
            A4WPurchaseManager.inAppProducts = products
        }
    }
    
    /// Static function to buy pro version
    static func buyProVersion(completion: @escaping (_ success: Bool) -> Void) {
        if let firstProduct = A4WPurchaseManager.inAppProducts?.first {
            A4WPurchaseManager.shared.buyProduct(firstProduct) { (didPurchase, _) in
                completion(didPurchase)
            }
        } else { completion(false) }
    }
    
    /// Static function to restore purchases
    static func restorePurchases(completion: @escaping (_ success: Bool) -> Void) {
        A4WPurchaseManager.shared.restorePurchases { (didRestore, _) in
            completion(didRestore)
        }
    }
    
    /// Static function to present a loading/spinner view when purchasing is in progress
    static func showLoadingView() {
        removeLoadingView()
        let mainView = UIView(frame: UIScreen.main.bounds)
        mainView.backgroundColor = .clear
        let darkView = UIView(frame: mainView.frame)
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.7
        mainView.addSubview(darkView)
        let spinnerView = UIActivityIndicatorView(style: .whiteLarge)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(spinnerView)
        spinnerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        spinnerView.startAnimating()
        mainView.tag = 1991
        (UIApplication.shared.delegate as? AppDelegate)?.window?.addSubview(mainView)
    }
    
    /// Static function to remove the loading/spinner view
    static func removeLoadingView() {
        (UIApplication.shared.delegate as? AppDelegate)?.window?.viewWithTag(1991)?.removeFromSuperview()
    }
}

// MARK: - StoreKit API
extension A4WPurchaseManager {
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct, _ completionHandler: @escaping ProductPurchaseCompletionHandler) {
        A4WPurchaseManager.showLoadingView()
        productPurchaseCompletionHandler = completionHandler
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productID: ProductID) -> Bool {
        return purchasedProductIDs.contains(productID)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases(completionHandler: @escaping ProductPurchaseCompletionHandler) {
        A4WPurchaseManager.showLoadingView()
        productPurchaseCompletionHandler = completionHandler
        SKPaymentQueue.default().restoreCompletedTransactions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            A4WPurchaseManager.removeLoadingView()
        }
    }
}

// MARK: - SKProductsRequestDelegate
extension A4WPurchaseManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        guard !products.isEmpty else {
            print("Product list is empty...!")
            print("Did you configure the project and set up the IAP?")
            productsRequestCompletionHandler?(false, nil)
            return
        }
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        for p in products {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale.current
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(String(describing: currencyFormatter.string(from: p.price)))")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver
extension A4WPurchaseManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            default: break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        productPurchaseCompleted(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        A4WPurchaseManager.removeLoadingView()
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        productPurchaseCompleted(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        A4WPurchaseManager.removeLoadingView()
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        productPurchaseCompletionHandler?(false, nil)
        SKPaymentQueue.default().finishTransaction(transaction)
        clearHandler()
        A4WPurchaseManager.removeLoadingView()
    }
    
    private func productPurchaseCompleted(identifier: ProductID?) {
        guard let identifier = identifier else { return }
        purchasedProductIDs.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.set(true, forKey: "didPurchaseProVersion")
        UserDefaults.standard.synchronize()
        didPurchaseProduct = true
        productPurchaseCompletionHandler?(true, identifier)
        clearHandler()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didPurchasePRO"), object: nil)
        A4WPurchaseManager.removeLoadingView()
    }
    
    private func clearHandler() {
        productPurchaseCompletionHandler = nil
    }
}
