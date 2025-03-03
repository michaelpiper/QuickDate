

import UIKit

class VerifyPhoneNumberVC: UIViewController {
    @IBOutlet weak var toplabel: UILabel!
    
    @IBOutlet weak var noOtherTimeBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var bottomLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    private func setupUI(){
        self.toplabel.text = NSLocalizedString("Verify your Number", comment: "Verify your Number")
         self.bottomLabel.text = NSLocalizedString("Please enter your mobile number to receive a verification code. Carrier rates may apply", comment: "Please enter your mobile number to receive a verification code. Carrier rates may apply")
        
        phoneNumberLabel.placeholder = NSLocalizedString("Phone Number", comment: "Phone Number")
        continueBtn.setTitle(NSLocalizedString("Continue", comment: "Continue"), for: .normal)
        noOtherTimeBtn.setTitle(NSLocalizedString("NO, OTHER TIME", comment: "NO, OTHER TIME"), for: .normal)
    }

    @IBAction func noOtherTimePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
    }
}
