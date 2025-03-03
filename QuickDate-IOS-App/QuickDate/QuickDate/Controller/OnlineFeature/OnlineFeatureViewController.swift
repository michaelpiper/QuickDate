//
//  OnlineFeatureViewController.swift
//  Universal
//
//  Created by Mohit Goyal 
//  Copyright © 2019 Mohit Goyal. All rights reserved.
//

import UIKit
import WebKit

class OnlineFeatureViewController: UIViewController {
    
    @IBOutlet weak var viewStatusBar: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var wkWebView : WKWebView!
    var strTitle: String!
    var strLoadUrl: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Status Bar
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.largeTitleDisplayMode = .never
        viewDidLoadOps()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup before loading the view, typically from a nib.
        viewWillAppearOps()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        viewDidAppearOps()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func viewDidLoadOps() ->Void {
        viewStatusBar.backgroundColor = .white
        viewHeader.backgroundColor = .white
        
        lblHeader.text = strTitle
        lblHeader.textColor = .black
//        lblHeader.font = UIFont.semiBoldFontOfSize(17)
        
        btnBack.setTitleColor(.black, for: .normal)
//        btnBack.titleLabel?.font = UIFont.semiBoldFontOfSize(17)
    }
    
    // MARK:
    // MARK: View will appear operations
    func viewWillAppearOps() ->Void {
        activityIndicator.startAnimating()
        
        btnBack.setTitle("", for: .normal)
        btnBack.setImage(nil, for: .normal)
        if self.isModal {
            btnBack.setTitle("CLOSE".localized, for: [])
        }
        else {
            btnBack.setTitle("Back".localized, for: [])
        }
    }

    // MARK:
    // MARK: View did appear operations
    func viewDidAppearOps() ->Void {
        
        let userScript = WKUserScript(source: strLoadUrl, injectionTime: .atDocumentStart, forMainFrameOnly: true)

        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)

        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = contentController

        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: viewHeader.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height - viewHeader.frame.maxY), configuration: webViewConfiguration)
//        wkWebView.navigationDelegate = self
        self.view.addSubview(wkWebView)
        wkWebView.isHidden = false
        wkWebView.scrollView.bounces = false
        
    }
    
    // MARK:
    // MARK: IBAction
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        if self.isModal {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension OnlineFeatureViewController: WKNavigationDelegate {
//    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        print(error.localizedDescription)
//        activityIndicator.stopAnimating()
//    }
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("Strat to load")
//    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("finish to load")
//        wkWebView.isHidden = false
//        activityIndicator.stopAnimating()
//    }
//
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//
//    }
//
//    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
//        wkWebView.isHidden = false
//        activityIndicator.stopAnimating()
//    }
//
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print(navigationAction.request.url ?? "")
////        let url = navigationAction.request.url!
////        if url == URL(string: strLoadUrl) {
////            decisionHandler(.allow)
////        } else {
////            UIApplication.shared.open(url)
////            decisionHandler(.cancel)
////        }
//        decisionHandler(.allow)
//    }
}
