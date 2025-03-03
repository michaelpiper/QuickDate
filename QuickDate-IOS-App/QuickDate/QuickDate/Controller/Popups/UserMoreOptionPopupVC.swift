//
//  UserMoreOptionPopupVC.swift
//  QuickDate
//
//  Created by iMac on 18/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class UserMoreOptionPopupVC: UIViewController {
    
    @IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    var delegate : UserOptionPopupDelegate?
    var index:Int = 0
    var paymentStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if index == 1001 {
            self.shareBtn.isHidden = true
            self.reportBtn.setTitle("Clear Chat", for: .normal)
        }else if index == 1002 {
            self.shareBtn.isHidden = true
            self.reportBtn.isHidden = true
            self.blockBtn.setTitle("Delete All Chat", for: .normal)
        }
    }
    
    @IBAction func blockPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.blockBtn(sender)
        }
    }
    
    @IBAction func reportPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.reportBtn(sender)
        }
    }
    @IBAction func sharePressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.shareBtn(sender)
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

 
