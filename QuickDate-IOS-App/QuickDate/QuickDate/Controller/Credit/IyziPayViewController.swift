//
//  IyziPayViewController.swift
//  QuickDate
//
//  Created by iMac on 31/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import WebKit

protocol PaystackWebViewDelegate {
    func webView(_ isSuccess: Bool, referanceID: String)
}

protocol AamarPayWebViewDelegate {
    func aamarPayView(_ isSuccess: Bool, referanceID: String)
}

protocol NgeniusPayWebViewDelegate {
    func ngeniusView(_ isSuccess: Bool, referanceID: String, credit: String)
}

class IyziPayViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblHeader: UILabel!
    
    var trackID = ""
    var iyzipayJS = ""
    var paymentType: PaymentName = .paystack
    var paystackDelegate: PaystackWebViewDelegate?
    var aamarPayDelegate: AamarPayWebViewDelegate?
    var ngeniusDelegate: NgeniusPayWebViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if paymentType == .iyziPay {
            self.lblHeader.text = "Iyzi Pay"
            self.setupIyzipayJSPaymet()
        }else if paymentType == .paystack || paymentType == .aamarPay || paymentType == .flutterWave || paymentType == .coinbase || paymentType == .ngenius {
            self.lblHeader.text = " "
            if let url = URL(string: self.iyzipayJS) {
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    func setupIyzipayJSPaymet() {
        let htmlString = """
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        \(self.iyzipayJS)
    </body>
</html>
"""
        self.iyzipayJS = htmlString
        if #available(iOS 11.0, *) {
            webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        }
        self.webView.loadHTMLString(self.iyzipayJS, baseURL: URL(string: "https://sandbox-api.iyzipay.com/"))
    }
}

extension IyziPayViewController {
    @IBAction func onBtnBack(_ sender: UIButton) {
        if paymentType == .paystack || paymentType == .aamarPay || paymentType == .flutterWave || paymentType == .coinbase || paymentType == .ngenius {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension IyziPayViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showProgressDialog(with: "Loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissProgressDialog {
            Logger.verbose("dismissed")
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == "http://cancelurl.com/"{
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
            if url.absoluteString.hasPrefix("https://quickdatescript.com/") {
                let reference = getQueryStringParameter(url: url.absoluteString, param: "reference")
                if let reference = reference {
                    print("reference ID :--- \(reference)")
                    self.dismiss(animated: true) {
                        self.paystackDelegate?.webView(true, referanceID: reference)
                    }
                }
            }
            
            if url.absoluteString.hasPrefix("https://sandbox.aamarpay.com//") {
                let reference = getQueryStringParameter(url: url.absoluteString, param: "track")
                if let reference = reference {
                    print("reference ID :--- \(reference)")
                    self.trackID = reference
                }
            }
            
            if url.absoluteString.hasPrefix("https://quickdatescript.com/aj/aamarpay/success") {
                let reference = getQueryStringParameter(url: url.absoluteString, param: "credit")
                if let reference = reference {
                    print("reference ID :--- \(reference)")
                    self.dismiss(animated: true) {
                        self.aamarPayDelegate?.aamarPayView(true, referanceID: self.trackID)
                    }
                }
            }
            
            if url.absoluteString.hasPrefix("https://quickdatescript.com/aj/coinbase/coinbase_cancel") {
                let reference = getQueryStringParameter(url: url.absoluteString, param: "coinbase_hash")
                if let reference = reference {
                    print("reference ID :--- \(reference)")
                    self.dismiss(animated: true) {
//                        self.aamarPayDelegate?.aamarPayView(true, referanceID: self.trackID)
                    }
                }
            }
            
            if url.absoluteString.hasPrefix("https://quickdatescript.com/aj/ngenius/success") {
                let credit = getQueryStringParameter(url: url.absoluteString, param: "credit")
                let ref = getQueryStringParameter(url: url.absoluteString, param: "ref")
                if let credit = credit, let ref = ref {
                    self.dismiss(animated: true) {
                        self.ngeniusDelegate?.ngeniusView(true, referanceID: ref, credit: credit)
                    }
                }
            }
        }
    }
}

//https://paypage.sandbox.ngenius-payments.com/?outletId=d9a1ed65-f441-42cc-bc75-b2537ee3f006&orderRef=7023d72e-d76c-46f1-a1c3-b355b2f299a4&paymentRef=6bfa6ac2-96db-4c1e-ab9d-2da5515f91b6&state=FAILED&3ds_status=SUCCESS&authResponse_success=true&authResponse_authorizationCode=AB0012
