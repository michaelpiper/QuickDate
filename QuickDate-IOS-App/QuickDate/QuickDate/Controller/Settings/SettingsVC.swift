//
//  SettingsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK
import SafariServices

class SettingsVC: BaseViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    
    // MARK: - Properties
    private let appManager: AppManager = .shared
    private var userSettings = AppInstance.shared.userProfileSettings
    private var switchStatus:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            self.settingsTableView.sectionHeaderTopPadding = 0
            self.settingsTableView.isPrefetchingEnabled = false
        }
        hideNavigation(hide: true)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.setupUI()
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
        // createMainViewGradientLayer(to: upperPrimaryView,
        //                startColor: startColor,
        //          endColor: endColor)
    }
    
    private func onUpdateProfileData() {
        AppManager.shared.onUpdateProfile = { () in
            Async.main {
                self.userSettings = AppInstance.shared.userProfileSettings
                self.settingsTableView.reloadData()
            }
        }
    }
    
    deinit {
        Logger.debug("deinit was worked")
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func setupUI() {
        self.settingsLabel.text = NSLocalizedString("Settings", comment: "Settings")
        self.settingsTableView.separatorStyle = .none
        self.settingsTableView.register(UINib(resource:R.nib.settingsSectionTableItem), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier)
        self.settingsTableView.register(UINib(resource:R.nib.settingsSectionTwoTableItem), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier)
        self.settingsTableView.register(UINib(resource:R.nib.settingsSectionThreeTableItem), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier)
        self.onUpdateProfileData()
    }
    
    private func logoutUser(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                UserManager.instance.logout(AccessToken: accessToken, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                UserDefaults.standard.removeObject(forKey: Local.USER_SESSION.User_Session)
                                
                                let defaults: Defaults = .shared
                                defaults.set(false, for: .didLogUserIn)
                                defaults.clear(.accessToken)
                                defaults.clear(.userID)
                                defaults.clear(.dashboardFilter)
                                defaults.clear(.trendingFilter)
                                defaults.clear(.hotOrNotFilter)
                                let appNavigator: AppNavigator = .shared
                                appNavigator.start(from: .authentication)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
    
    func removeCache() {
        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let path = String(format:"%@/%@/Cache.db-wal",caches, appId)
        do {
            try FileManager.default.removeItem(atPath: path)
            self.view.makeToast("Cache Cleared")
        } catch {
            print("ERROR DESCRIPTION: \(error)")
        }
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*
        if indexPath == IndexPath(row: 1, section: 0) {
            return 56
        } else if indexPath == IndexPath(row: 0, section: 1) {
            return 56//95
        } else if indexPath.section == 4{
            return 56//UITableView.automaticDimension
        } else if indexPath.section == 2 {
            return 56
        }else if indexPath.section == 3 {
            // TODO: change after custom mode is completed
            // Now app dark mode works only according to system settings
            return 0
        }
        else if indexPath.section == 6 {
            return UITableView.automaticDimension
        }
        else {
            return 56
        }*/
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 { // my account
                if AppInstance.shared.userProfileSettings?.phone_verified ?? false {
                    let vc = R.storyboard.settings.myAccountVC()
                    self.navigationController?.pushViewController(vc!, animated: true)
                    break
                }else {
                    let vc = R.storyboard.settings.phoneNumberVerificationVC()
                    vc?.delegate = self
                    vc?.modalTransitionStyle = .coverVertical
                    vc?.modalPresentationStyle = .overFullScreen
                    self.present(vc!, animated: true, completion: nil)
                    break
                }
            }  else if indexPath.row == 1 { // social links
                let vc = R.storyboard.settings.socialLinkVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 2 {
                let vc = R.storyboard.settings.blockUserVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 3 {
                let vc = R.storyboard.settings.myAffliatesVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                let vc = R.storyboard.settings.withdrawalsVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 1 {
                let viewController = TransactionsListViewController.instantiate(fromStoryboardNamed: .settings)
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 2:
            if indexPath.row == 0 { // change password
                let vc = R.storyboard.settings.changePasswordVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else   if indexPath.row == 1 { // change password
                let vc = R.storyboard.settings.twoFactorUpdateVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 2 { // change password
                let vc = R.storyboard.settings.sessionsVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
        case 3: self.themeOptionsAlert()
        case 4: break
        case 5: break
        case 6: self.clearCacheAlert()
        case 7:
            switch indexPath.row {
            case 0:
                let vc = R.storyboard.settings.helpVC()
                vc?.checkString = "help"
                self.navigationController?.pushViewController(vc!, animated: true)
            case 1:
                let vc = R.storyboard.settings.aboutVC()
//                vc?.checkString = "about"
                self.navigationController?.pushViewController(vc!, animated: true)
            case 2: // delete account
                let vc = R.storyboard.settings.deleteAccountVC()
                navigationController?.pushViewController(vc!, animated: true)
            case 3: // logout
                self.showLogoutAlert()
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
        view.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.size.width, height: 45))
        label.setTheme(font: .regularText(size: 18))
        label.textColor = .PrimaryColor
        switch section {
        case 0: label.text = NSLocalizedString("General", comment: "General")
        case 1: label.text = NSLocalizedString("Payment", comment: "Payment")
        case 2: label.text = NSLocalizedString("Security", comment: "Security")
        case 3: label.text = NSLocalizedString("Display", comment: "Display")
        case 4: label.text = NSLocalizedString("Messenger", comment: "Messenger")
        case 5: label.text = NSLocalizedString("Support", comment: "Support")
        case 6: label.text = NSLocalizedString("Storage", comment: "Storage")
        case 7: label.text = NSLocalizedString("Privacy", comment: "Privacy")
        default: break
        }
        if !(label.text ?? "").isEmpty {
            view.addSubview(label)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return 2//1
        case 2: return 3
        case 3: return 1
        case 4: return 1
        case 5: return 4
        case 6: return 1
        case 7: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0: cell.titleLabel.text = NSLocalizedString("My Account", comment: "My Account")
            case 1: cell.titleLabel.text = NSLocalizedString("Social Links", comment: "Social Links")
            case 2: cell.titleLabel.text = NSLocalizedString("Blocked Users", comment: "Blocked Users")
            case 3: cell.titleLabel.text = NSLocalizedString("My Affliates", comment: "My Affliates")
            default: break
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0: cell.titleLabel.text = NSLocalizedString("Withdrawals", comment: "Withdrawals")
            case 1: cell.titleLabel.text = NSLocalizedString("Transactions", comment: "Transactions")
            default:
                return UITableViewCell()
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0: cell.titleLabel.text = NSLocalizedString("Password", comment: "Password")
            case 1: cell.titleLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
            case 2: cell.titleLabel.text = NSLocalizedString("Manage Sessions", comment: "Manage Sessions")
            default:
                break
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            cell.titleLabel.text =  NSLocalizedString("Theme", comment: "Theme")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            cell.titleLabel.text =  NSLocalizedString("Show when you're active", comment: "Show when you're active")
            cell.checkStringStatus = "onlineSwitch"
            let status = self.userSettings?.online ?? false
            cell.config(status: status)
            cell.switchDelegate = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Show my profile on search engines?", comment: "Show my profile on search engines?")
                let status = userSettings?.privacy_show_profile_on_google ?? false
                cell.config(status: status)
                cell.switchStatusValue = status
                cell.checkStringStatus = "searchEngine"
                cell.delegate = self
                cell.randomUser = userSettings?.privacy_show_profile_random_users
                cell.matchProfile = userSettings?.privacy_show_profile_match_profiles
                cell.searchEngine = userSettings?.privacy_show_profile_on_google
                cell.confirmFollowers = userSettings?.confirm_followers
            case 1:
                cell.titleLabel.text = NSLocalizedString("Show my profile in random users?", comment: "Show my profile in random users?")
                let status = userSettings?.privacy_show_profile_random_users ?? false
                cell.config(status: status)
                cell.switchStatusValue = status
                cell.checkStringStatus = "randomUser"
                cell.delegate = self
                cell.randomUser = userSettings?.privacy_show_profile_random_users
                cell.matchProfile = userSettings?.privacy_show_profile_match_profiles
                cell.searchEngine = userSettings?.privacy_show_profile_on_google
                cell.confirmFollowers = userSettings?.confirm_followers
            case 2:
                cell.titleLabel.text =  NSLocalizedString("Show my profile in find match page?", comment: "Show my profile in find match page?")
                let status = userSettings?.privacy_show_profile_match_profiles ?? false
                cell.config(status: status)
                cell.switchStatusValue = status
                cell.checkStringStatus = "matchProfile"
                cell.delegate = self
                cell.randomUser = userSettings?.privacy_show_profile_random_users
                cell.matchProfile = userSettings?.privacy_show_profile_match_profiles
                cell.searchEngine = userSettings?.privacy_show_profile_on_google
                cell.confirmFollowers = userSettings?.confirm_followers
            case 3:
                cell.titleLabel.text =  NSLocalizedString("Confirm request when someone request to be a friend with you?", comment: "Confirm request when someone request to be a friend with you?")
                let status = userSettings?.confirm_followers ?? false
                cell.config(status: status)
                cell.switchStatusValue = status
                cell.checkStringStatus = "confirm_followers"
                cell.delegate = self
                cell.randomUser = userSettings?.privacy_show_profile_random_users
                cell.matchProfile = userSettings?.privacy_show_profile_match_profiles
                cell.searchEngine = userSettings?.privacy_show_profile_on_google
                cell.confirmFollowers = userSettings?.confirm_followers
            default:
                break
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            cell.titleLabel.text = NSLocalizedString("Clear Cache", comment: "Clear Cache")
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Help", comment: "Help")
            case 1:
                cell.titleLabel.text = NSLocalizedString("About", comment: "About")
            case 2:
                cell.titleLabel.text = NSLocalizedString("Delete account", comment: "Delete account")
            case 3:
                cell.titleLabel.text = NSLocalizedString("Logout", comment: "Logout")
            default:
                break
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
extension SettingsVC:didUpdateSettingsDelegate {
    func updateSettings(searchEngine: Int, randomUser: Int, matchProfile: Int, confirmFollower: Int, switch: CustomSwitch) {
        if Connectivity.isConnectedToNetwork() {
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.privacy_show_profile_on_google: searchEngine,
                API.PARAMS.privacy_show_profile_random_users: randomUser,
                API.PARAMS.privacy_show_profile_match_profiles: matchProfile,
                API.PARAMS.confirm_followers: confirmFollower
                ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                self.appManager.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                }
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}

extension SettingsVC:didUpdateOnlineStatusDelegate {
    func updateOnlineStatus(status: Int, switch: CustomSwitch) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                OnlineSwitchManager.instance.getNotifications(AccessToken: accessToken, status: status, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.appManager.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
                
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}

extension SettingsVC {
    
    func themeOptionsAlert() {
        let vc = R.storyboard.popUps.themePopupVC()
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func clearCacheAlert() {
        let vc = R.storyboard.popUps.warningPopUpVC()
        vc?.descriptionSTR = "The files will be deleted. Are you sure?".localized
        vc?.type = "Clear_Caches"
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func showLogoutAlert() {
        let vc = R.storyboard.popUps.warningPopUpVC()
        vc?.descriptionSTR = "Are you sure you want to logout?".localized
        vc?.type = "Logout"
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

extension SettingsVC: WarningPopupDelegate {
    func yesBtnPressed(_ sender: UIButton, type: String) {
        if type == "Clear_Caches" {
            self.removeCache()
        }else if type == "Logout" {
            self.logoutUser()
        }
    }
    
    func noBtnPressed(_ sender: UIButton) {
        
    }
}

extension SettingsVC: PhoneNumberVerificationDelegate {
    func continueBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let newVC = R.storyboard.settings.codeVerificationVC() else { return }
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
