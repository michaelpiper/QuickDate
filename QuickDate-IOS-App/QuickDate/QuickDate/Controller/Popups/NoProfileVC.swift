//
//  NoProfileVC.swift
//  QuickDate
//
//  Created by iMac on 09/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

protocol NoProfileDelegate {
    func addPhotoBtnAction(_ sender: UIButton)
}

class NoProfileVC: UIViewController {
        
    var delegate: NoProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) {
            self.delegate?.addPhotoBtnAction(sender)
        }
    }
    
    @IBAction func photoLaterBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
}
