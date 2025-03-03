//
//  ThemePopupVC.swift
//  QuickDate
//
//  Created by iMac on 21/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class ThemePopupVC: BaseViewController {
    
    
    @IBOutlet weak var btnLight: UIButton!
    @IBOutlet weak var btnDark: UIButton!
    @IBOutlet weak var btnBatterySave: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    let keyWindow = UIApplication.shared.connectedScenes
           .filter({$0.activationState == .foregroundActive})
           .compactMap({$0 as? UIWindowScene})
           .first?.windows
           .filter({$0.isKeyWindow}).first
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = UserDefaults.standard.getDarkMode(Key: "darkMode")
        let isSystemTheme = UserDefaults.standard.getSystemTheme(Key: "SystemTheme")
        if isSystemTheme {
            self.btnBatterySave.setTitleColor(.PrimaryColor, for: .normal)
            self.btnLight.setTitleColor(.darkGray, for: .normal)
            self.btnDark.setTitleColor(.darkGray, for: .normal)
        }else {
            if status {
                self.btnBatterySave.setTitleColor(.darkGray, for: .normal)
                self.btnLight.setTitleColor(.darkGray, for: .normal)
                self.btnDark.setTitleColor(.PrimaryColor, for: .normal)
            } else {
                self.btnBatterySave.setTitleColor(.darkGray, for: .normal)
                self.btnLight.setTitleColor(.PrimaryColor, for: .normal)
                self.btnDark.setTitleColor(.darkGray, for: .normal)
            }
        }
    }
    
    @IBAction func lightPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            keyWindow?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.setDarkMode(value: false, ForKey: "darkMode")
            UserDefaults.standard.setSystemTheme(value: false, ForKey: "SystemTheme")
        }
    }
    
    @IBAction func darkPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            keyWindow?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.setDarkMode(value: true, ForKey: "darkMode")
            UserDefaults.standard.setSystemTheme(value: false, ForKey: "SystemTheme")
        }
    }
    
    @IBAction func setBatterySaverPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            keyWindow?.overrideUserInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            UserDefaults.standard.setSystemTheme(value: true, ForKey: "SystemTheme")
        }
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
