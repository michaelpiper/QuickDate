//
//  SettingsSectionThreeTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit

class SettingsSectionThreeTableItem: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var switcher2: CustomSwitch!
    @IBOutlet weak var viewMain: UIView!
    
    var searchEngine: Bool?
    var randomUser: Bool?
    var matchProfile: Bool?
    var confirmFollowers: Bool?
    
    var switchStatusValue:Bool = false
    
    var delegate:didUpdateSettingsDelegate?
    var switchDelegate:didUpdateOnlineStatusDelegate?
    var checkStringStatus:String? = ""
    var switchStatus:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.cornerRadiusV = 12
        self.viewMain.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func config(status: Bool) {
        if status {
            self.switcher2.setOn(true, animated: true)
        }else{
            self.switcher2.setOn(false, animated: true)
        }
    }

    @IBAction func switchBtnPressed(_ sender: CustomSwitch) {
        if checkStringStatus == "searchEngine" {
            if switchStatusValue {
                let searchEngineValueInt = 0
                let randomUserValueInt = randomUser ?? false ? 1 : 0
                let matchProfileValueInt = matchProfile ?? false ? 1 : 0
                let confirmFollower = confirmFollowers ?? false ? 1 : 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }else{
                let searchEngineValueInt = 1
                let randomUserValueInt = randomUser ?? false ? 1 : 0
                let matchProfileValueInt = matchProfile ?? false ? 1 : 0
                let confirmFollower = confirmFollowers ?? false ? 1 : 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }
        }else if checkStringStatus == "randomUser" {
            if switchStatusValue {
                let searchEngineValueInt = searchEngine ?? false ? 1 : 0
                let randomUserValueInt = 0
                let matchProfileValueInt = matchProfile ?? false ? 1 : 0
                let confirmFollower = confirmFollowers ?? false ? 1 : 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }else{
                let searchEngineValueInt = searchEngine ?? false ? 1 : 0
                let randomUserValueInt = 1
                let matchProfileValueInt = matchProfile ?? false ? 1 : 0
                let confirmFollower = confirmFollowers ?? false ? 1 : 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }
        }else if checkStringStatus == "matchProfile" {
            if switchStatusValue {
                let searchEngineValueInt = searchEngine ?? false ? 1 : 0
                let randomUserValueInt = randomUser ?? false ? 1 : 0
                let matchProfileValueInt = 0
                let confirmFollower = confirmFollowers ?? false ? 1 : 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }else{
                let searchEngineValueInt = searchEngine ?? false ? 1 : 0
                let randomUserValueInt = randomUser ?? false ? 1 : 0
                let matchProfileValueInt = 1
                let confirmFollower = confirmFollowers ?? false ? 1 : 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }
        }else if checkStringStatus == "confirm_followers" {
            if switchStatusValue {
                let searchEngineValueInt = searchEngine ?? false ? 1 : 0
                let randomUserValueInt = randomUser ?? false ? 1 : 0
                let matchProfileValueInt = matchProfile ?? false ? 1 : 0
                let confirmFollower = 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }else{
                let searchEngineValueInt = searchEngine ?? false ? 1 : 0
                let randomUserValueInt = randomUser ?? false ? 1 : 0
                let matchProfileValueInt = matchProfile ?? false ? 1 : 0
                let confirmFollower = 1
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt, confirmFollower: confirmFollower, switch: switcher2)
            }
        }else if checkStringStatus == "onlineSwitch" {
            if switcher2.isOn {
                self.switchStatus = 1
                self.switchDelegate?.updateOnlineStatus(status:self.switchStatus ?? 0 , switch: switcher2)
            }else{
                  self.switchStatus = 0
                 self.switchDelegate?.updateOnlineStatus(status:self.switchStatus ?? 0 , switch: switcher2)
            }
        }
    }
}

