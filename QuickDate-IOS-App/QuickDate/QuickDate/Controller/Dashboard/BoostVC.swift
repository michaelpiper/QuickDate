//
//  BoostVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol BoostViewDelegate {
    func navigateToBuyCredit()
}

class BoostVC: BaseViewController {
    
    var delegate: BoostViewDelegate?
    
    @IBOutlet weak var rocketImage: UIImageView!
    @IBOutlet weak var heartimage: UIImageView!
    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var likesBtn: UIButton!
    @IBOutlet weak var matchesBtn: UIButton!
    @IBOutlet weak var visitsBtn: UIButton!
    @IBOutlet weak var visitLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var popularitylabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var visitCreditLabel: UILabel!
    @IBOutlet weak var likesCreditLabel: UILabel!
    @IBOutlet weak var matchesCreditLabel: UILabel!
    @IBOutlet var viewMainCollection: [UIView]!
    
    private let appNavigator: AppNavigator = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        self.matchesBtn.backgroundColor = .Button_StartColor
        self.matchesBtn.setTitleColor(.Button_TextColor, for: .normal)
        self.lowLabel.text = NSLocalizedString("Very Low", comment: "Very Low")
        self.popularitylabel.text = NSLocalizedString("Popularity", comment: "Popularity")
        self.visitLabel.text = NSLocalizedString("Promote your profile by get more visits, for 5 minutes", comment: "Promote your profile by get more visits, for 5 minutes")
        self.matchesLabel.text = NSLocalizedString("Show more and rise up at the same time, for 4 minutes", comment: "Show more and rise up at the same time, for 4 minutes")
        self.likesLabel.text = NSLocalizedString("Tell everyone you're online and be seen by users who want to chat, for 5 minutes", comment: "Tell everyone you're online and be seen by users who want to chat, for 5 minutes")
        
        self.visitsBtn.setTitle( NSLocalizedString("Get x10 Visits", comment: "Get x10 Visits"), for: .normal)
        self.matchesBtn.setTitle( NSLocalizedString("Get x10 Matches", comment: "Get x3 Matches"), for: .normal)
        self.likesBtn.setTitle( NSLocalizedString("Get x10 Matches", comment: "Get x4 Likes"), for: .normal)
        
        self.visitCreditLabel.text = NSLocalizedString("25 Credits", comment: "25 Credits")
        self.matchesCreditLabel.text = NSLocalizedString("35 Credits", comment: "25 Credits")
        self.likesCreditLabel.text = NSLocalizedString("45 Credits", comment: "25 Credits")
        
        visitsBtn.backgroundColor = .white
        matchesBtn.backgroundColor = .white
        likesBtn.backgroundColor = .white
        
        visitsBtn.borderWidthV = 1
        matchesBtn.borderWidthV = 1
        likesBtn.borderWidthV = 1
        visitsBtn.borderColorV = UIColor(named: "primaryEndColor")
        matchesBtn.borderColorV = UIColor(named: "primaryEndColor")
        likesBtn.borderColorV = UIColor(named: "primaryEndColor")
        visitsBtn.setTitleColor(UIColor(named: "primaryEndColor"), for: .normal)
        likesBtn.setTitleColor(UIColor(named: "primaryEndColor"), for: .normal)
        matchesBtn.setTitleColor(UIColor(named: "primaryEndColor"), for: .normal)
        visitsBtn.cornerRadiusV = visitsBtn.frame.height / 2
        likesBtn.cornerRadiusV = likesBtn.frame.height / 2
        matchesBtn.cornerRadiusV = matchesBtn.frame.height / 2
        
        for vw in viewMainCollection {
            vw.cornerRadiusV = 20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(hide: false)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getTenXVisitsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        managedPopularity(type: "visits")
    }
    
    @IBAction func getx3MatchesPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        managedPopularity(type: "matches")
    }
    
    @IBAction func getx4LikesPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        managedPopularity(type: "likes")
    }
    
    private func managedPopularity(type:String) {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                PopularityManager.instance.managePopularity(AccessToken: accessToken, Type: type) { (success, sessionError, error) in
                    if success != nil {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                AppManager.shared.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.delegate?.navigateToBuyCredit()
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
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
