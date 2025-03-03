
import UIKit
import Async
import QuickDateSDK


protocol WarningPopupDelegate {
    func yesBtnPressed(_ sender: UIButton, type: String)
    func noBtnPressed(_ sender: UIButton)
}

class WarningPopUpVC: BaseViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    var descriptionSTR: String?
    var type:String? = ""
    var delegate: WarningPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDescription.text = self.descriptionSTR//"Do you want to unblock this user ?"
        if type == "Logout" {
            self.btnNo.setTitle("CANCEL".localized, for: .normal)
            self.btnYes.setTitle("Ok".localized, for: .normal)
        }
    }

    @IBAction func yesPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.yesBtnPressed(sender, type: self.type ?? "")
        }
    }
    
    @IBAction func noPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.noBtnPressed(sender)
        }
    }
}

