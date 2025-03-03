//
//  HelpVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import WebKit
import QuickDateSDK

class HelpVC: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var helpLabel: UILabel!
    var checkString:String? = ""
    var isPresent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpLabel.text = NSLocalizedString("Help", comment: "Help")
        hideNavigation(hide: true)
        initWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    private func handleGradientColors() {
//        let startColor = Theme.primaryStartColor.colour
//        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    // MARK: - Methods
    func initWebView() {
        if checkString == "help" {
            webView.navigationDelegate = self
            self.statusLabel.text = "Help"
            let url = URL(string: ControlSettings.help_app)
            let urlRequest = URLRequest(url: url!)
            webView.load(urlRequest)
        }else if checkString == "about"{
            self.statusLabel.text = "About"
            let url = URL(string: ControlSettings.aboutUS)
            let urlRequest = URLRequest(url: url!)
            webView.load(urlRequest)
        } else if checkString == "terms" {
            self.statusLabel.text = "Terms And Condition"
            let url = URL(string: ControlSettings.terms)
            let urlRequest = URLRequest(url: url!)
            webView.load(urlRequest)
        } else if checkString == "privacy" {
            self.statusLabel.text = "Privacy Policy"
            let url = URL(string: ControlSettings.privacy)
            let urlRequest = URLRequest(url: url!)
            webView.load(urlRequest)
        }
    }
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        if checkString == "terms" && isPresent {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension HelpVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showProgressDialog(with: "Loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissProgressDialog {
            Logger.verbose("dismissed")
        }
    }
}
