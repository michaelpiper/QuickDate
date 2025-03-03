//
//  ChatPopupVC.swift
//  QuickDate
//
//  Created by iMac on 01/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

protocol ChatsPopupDelegate {
    func btnPressed(_ sender: UIButton)
}

class ChatPopupVC: UIViewController {
    
    
    @IBOutlet weak var btnDeleteChats: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    var delegate: ChatsPopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func deleteChatsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            self.delegate?.btnPressed(sender)
        }
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
