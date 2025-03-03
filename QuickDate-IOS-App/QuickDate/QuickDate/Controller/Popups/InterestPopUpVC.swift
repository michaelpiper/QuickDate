

import UIKit
import Async
import QuickDateSDK

class InterestPopUpVC: BaseViewController {
    
    var delegate:ReloadTableViewDataDelegate?
    
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        self.updateInterest()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel").uppercased(), for: .normal)
        self.submitBtn.setTitle(NSLocalizedString("Submit", comment: "Submit").uppercased(), for: .normal)
        self.interestLabel.text = NSLocalizedString("Interest", comment: "Interest")
        
        self.interestTextField.delegate = self
        let appInstance: AppInstance =  .shared
        self.interestTextField.text = appInstance.userProfileSettings?.interest
    }
    
    private func updateInterest() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let interestString = self.interestTextField.text ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.interest: interestString
                ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.debug("UPDATED")
                                self.dismiss(animated: true) {
                                    self.delegate?.reloadTableView(Status: true)
                                }
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

extension InterestPopUpVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLineView.backgroundColor = .PrimaryColor
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmpty = textField.text?.trimmingCharacters(in: .whitespaces).count == 0
        bottomLineView.backgroundColor = isEmpty ? .lightGray : .PrimaryColor
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
