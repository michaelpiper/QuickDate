//
//  MyAffliatesVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import QuickDateSDK

class MyAffliatesVC: BaseViewController {
    @IBOutlet weak var clickLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var myAffliatesLabel: UILabel!
    
    // MARK: - Properties
    
    private let appInstance: AppInstance = .shared
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myAffliatesLabel.text = NSLocalizedString("My Affliates", comment: "My Affliates")
        self.topLabel.text = NSLocalizedString("Earn upto $ for each user your refer to us!", comment: "Earn upto $ for each user your refer to us!")
        self.shareBtn.setTitle(NSLocalizedString("Share to", comment: "Share to"), for: .normal)
        self.clickLabel.text = "https://quickdatescript.com/register?ref=\(appInstance.userProfileSettings?.username ?? "")"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(_:)))
        clickLabel.isUserInteractionEnabled = true
        clickLabel.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClicLabel(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        openUrl(urlString: "\(API.baseURL)register?ref=\(appInstance.userProfileSettings?.username ?? "")")
    }
    
    @IBAction func shareToPressed(_ sender: UIButton) {
        self.shareAcitvity()
    }
    
    func openUrl(urlString: String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func shareAcitvity() {
        self.view.endEditing(true)
        let myWebsite = URL(string:"https://quickdatescript.com/register?ref=\(appInstance.userProfileSettings?.username ?? "")")!
        let shareAll = [ myWebsite]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
