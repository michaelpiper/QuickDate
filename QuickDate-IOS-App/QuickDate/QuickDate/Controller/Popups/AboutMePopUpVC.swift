

import UIKit
import Async
import QuickDateSDK

protocol ReloadTableViewDataDelegate {
    func reloadTableView(Status:Bool)
}
class AboutMePopUpVC: BaseViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutMetextField: UITextField!
    @IBOutlet weak var bottomLineView: UIView!
    
    var delegate:ReloadTableViewDataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    @IBAction func submitPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        updateAboutMe()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        self.aboutMetextField.delegate = self
        self.aboutLabel.text = NSLocalizedString("About", comment: "About")
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel").uppercased(), for: .normal)
        self.submitBtn.setTitle(NSLocalizedString("Submit", comment: "Submit").uppercased(), for: .normal)
        let appInstance: AppInstance = .shared
        self.aboutMetextField.text = appInstance.userProfileSettings?.about
    }
    private func updateAboutMe(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let aboutMeString = self.aboutMetextField.text ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.about: aboutMeString
            ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
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

extension AboutMePopUpVC: UITextFieldDelegate {
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
