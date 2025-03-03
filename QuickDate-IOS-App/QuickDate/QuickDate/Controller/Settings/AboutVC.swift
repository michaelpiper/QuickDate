//
//  AboutVC.swift
//  QuickDate
//
//  Created by iMac on 21/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class AboutVC: BaseViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    let appStoreReviewURL = URL(string: "https://itunes.apple.com/app/id\(11111111)?mt=8&action=write-review")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addShadow()
        bottomView.addShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar()
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rateAppBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let url = appStoreReviewURL,
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: { (complete) in
            })
        }
    }
    
    @IBAction func termsBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.settings.helpVC()
        vc?.checkString = "terms"
        vc?.isPresent = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func privacyBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.settings.helpVC()
        vc?.checkString = "privacy"
        vc?.isPresent = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func aboutBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = R.storyboard.settings.helpVC()
        vc?.checkString = "about"
        vc?.isPresent = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
