
import UIKit
import Async

/// - Tag: ForgetPasswordVC
class ForgetPasswordVC: BaseViewController {
    
    // MARK: - View
    // NavBar
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forgetLabel: UILabel!
    
    @IBOutlet weak var emailTextField: FloatingTextField!
    
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewSend: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConfigures()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createMainViewGradientLayer()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            createMainViewGradientLayer()
        }
    }
    
    // MARK: - Services
    // TODO: try this func
    // !!!: can not try due to server error
    private func send() {
        self.showProgressDialog(with: "Loading...")
        let email = emailTextField.text?.trim() ?? ""
        Async.background({
            UserManager.instance.forgetPassword(Email: email, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success)")
                            let vc = R.storyboard.authentication.twoFactorVC()
                            vc?.email = email
                            vc?.isForgotpassword = true
                            self.navigationController?.pushViewController(vc!, animated: true)
                            //                            self.view.makeToast(success)
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                            securityAlertVC?.titleText  = "Security"
                            securityAlertVC?.messageText = sessionError?.errors?.errorText ?? ""
                            self.present(securityAlertVC!, animated: true, completion: nil)
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            
                            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
                            securityAlertVC?.titleText  = "Security"
                            securityAlertVC?.messageText = error?.localizedDescription ?? ""
                            self.present(securityAlertVC!, animated: true, completion: nil)
                        }
                    })
                }
            })
        })
    }
    
    // MARK: - Actions
    @IBAction func buttonBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if self.emailTextField.text!.isEmpty{
            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.messageText = "Please enter email."
            self.present(securityAlertVC!, animated: true, completion: nil)
            
        }else if !self.emailTextField.text!.isEmail{
            let securityAlertVC = R.storyboard.popUps.customAlertViewController()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.messageText = "Email is badly formatted."
            self.present(securityAlertVC!, animated: true, completion: nil)
            
        }else{
            self.send()
        }
    }
    
    // MARK: - Helpers
    
    private func createMainViewGradientLayer() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
        let gradientLayer = createGradient(colors: [startColor, endColor])
        gradientLayer.frame = sendButton.bounds
        gradientLayer.cornerRadius = sendButton.layer.cornerRadius
        viewSend.cornerRadiusV = viewSend.bounds.height / 2
    }
    
    private func setupUI(){
        self.forgetLabel.text = "Forget Password".localized
        self.explanationLabel.text = "Please enter your email address. We will send you a link to reset password.".localized
    }
}

// MARK: - ThemeLoadable
extension ForgetPasswordVC: LabelThemeLoadable, ButtonThemeLoadable {
    internal func configureButtons() {
        backButton.setTheme(tint: .primaryTextColor, title: "")
        lblSend.text = "Send".localized
    }
    
    internal func configureLabels() {
        forgetLabel.setTheme(text: "Forget Password".localized,
                             themeColor: .primaryTextColor, font: .semiBoldTitle(size: 20))
        
        let text = "Please enter your email address. We will send you a link to reset password.".localized
        explanationLabel.setTheme(text: text, themeColor: .primaryTextColor, font: .regularText(size: 13))
        emailTextField.setTitle(title: "Email")
    }
    
    internal func configureUIViews() {
    }
    
    internal func setUpConfigures() {
        configureButtons()
        configureLabels()
        configureUIViews()
    }
}
