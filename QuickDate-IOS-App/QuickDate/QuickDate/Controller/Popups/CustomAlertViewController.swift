

import UIKit
import SwiftEventBus

/// - Tag: CustomAlertViewController
class CustomAlertViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var alertBackgroundView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    // MARK: Property Injections
    var titleText: String?
    var messageText: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
    }
    
    // MARK: - Helper
    private func configureUI(){
        alertBackgroundView.setThemeBackgroundColor(.primaryBackgroundColor)
        okButton.setTheme(tint: .primaryEndColor, title: "OK".localized, font: .semiBoldTitle(size: 13))
        
        
        titleLabel.setTheme(text: titleText ?? "Security".localized,
                            themeColor: .primaryEndColor, font: .semiBoldTitle(size: 20))
        
        messageTextLabel.setTheme(text: messageText ?? "", themeColor: .primaryTextColor, font: .regularText(size: 15))
    }
    
    // MARK: - Action
    @IBAction func okPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
