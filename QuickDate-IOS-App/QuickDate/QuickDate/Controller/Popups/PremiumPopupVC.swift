//
//  PremiumPopupVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Lottie

protocol PremiumPopupDelegate {
    func renewPremium(_ sender: UIButton)
}

class PremiumPopupVC: UIViewController {
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var delegate: PremiumPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        self.topLabel.text = NSLocalizedString("You are Premium User", comment: "You are Premium User")
        let date = Date(timeIntervalSince1970: TimeInterval(AppInstance.shared.userProfileSettings?.pro_time ?? "") ?? 0)
        self.expirationDateLabel.text = "Expiration date: " + Date().timeAgo(from: date)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
        
    }
    override func viewDidLayoutSubviews() {
        bgView.setGradientBackground(startColor: UIColor.hexStringToUIColor(hexStr: "#7B2BFF"), endColor: UIColor.PrimaryColor, direction: .horizontal)
      }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "Updated: \(dateString)"
    }
    
    
    @IBAction func skipPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) {
            self.delegate?.renewPremium(sender)
        }
    }
}
