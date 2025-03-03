//
//  UpdateTwoFactorSettingPopupVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class UpdateTwoFactorSettingPopupVC: BaseViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if self.codeTextField.text!.isEmpty{
            self.view.makeToast(NSLocalizedString("Please enter code", comment: "Please enter code"))
        }else{
            self.verifyCode(code: self.codeTextField.text ?? "", Type: "verify")
        }
    }
    private func verifyCode(code:String,Type:String){
        self.showProgressDialog(with: NSLocalizedString("Loading...", comment: "Loading..."))
//        let userID = AppInstance.shared.userId ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        let params = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.two_factor_email_code: code
            ] as [String : Any]
        
        Async.background({
            ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                            let appManager: AppManager = .shared
                            appManager.fetchUserProfile()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
                            
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
}
