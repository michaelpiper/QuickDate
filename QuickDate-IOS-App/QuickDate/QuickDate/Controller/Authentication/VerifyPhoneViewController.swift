

import UIKit

class VerifyPhoneViewController: UIViewController {

    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }

    //MARK: - Methods
    func configView() {
        hideNavigation(hide: true)
        continueButton.layer.cornerRadius = 8
    }
    
    //MARK: - Actions
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func otherTimeButtonAction(_ sender: UIButton) {
        
    }
}
