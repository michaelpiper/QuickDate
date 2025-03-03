
import UIKit
import Toast

class VerifyEmailViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var buttonSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    //MARK: - Methods
    func configView() {
        hideNavigation(hide: true)
        buttonSend.layer.cornerRadius = 8
    }

    //MARK: - Actions
    @IBAction func buttonBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSendAction(_ sender: UIButton) {
//        if let email = emailTextfield.text {
//            GeneralHelpers.showLoading(view: view)
//            AuthenticationServices().resendEmail(email: email, completionHandler: {[weak self](response) in
//                GeneralHelpers.hideLoading()
//                self?.view.makeToast("Email sent successfully!", duration: 2, position: CSToastPositionBottom)
//            }) {[weak self](error) in
//                GeneralHelpers.hideLoading()
//                self?.view.showError(error: error!)
//            }
//        }
    }
}
