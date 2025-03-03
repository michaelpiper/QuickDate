//
//  BuyCreditSectionThreeTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.


import UIKit

class BuyCreditSectionThreeTableItem: UITableViewCell {
    
    @IBOutlet weak var skipLabel: UILabel!
    @IBOutlet weak var skipCreditBtn: UIView!
    
    var vc:BuyCreditVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        self.skipLabel.text = NSLocalizedString("Skip Credit", comment: "Skip Credit")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        skipCreditBtn.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
          self.vc?.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func termsCondition(_ sender: Any) {
//               let vc = R.storyboard.settings.helpVC()
//                         vc?.checkString = "terms"
//        vc?.modalTransitionStyle = .coverVertical
//        vc?.modalPresentationStyle = .fullScreen
//            self.vc?.present(vc!, animated: true, completion: nil)
//    }
}
