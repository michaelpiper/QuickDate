
import UIKit

protocol SelectGenderPopUpViewControllerDelegate: AnyObject {
    func setGender(to gender: GenderOfUser?)
}

typealias GenderOfUser = (code: String, name: String)

/// - Tag: SelectGenderPopUpViewController
class SelectGenderPopUpViewController: UIViewController {
        
    // MARK: - Views
    @IBOutlet weak var popBackgroundView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: SelectGenderPopUpViewControllerDelegate?
    
    private var genderList: [GenderOfUser] = []
    
    // MARK: - LifeCycle
    var delegateOld : selectGenderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchGenderList()
        handleStackViewButtons()

    }
    
    // MARK: - Services
    
    private func fetchGenderList() {
        let appInstance: AppInstance = .shared
        guard let genderList = appInstance.adminSettings?.gender else {
            Logger.error("getting gender list"); return
        }
        genderList.forEach { element in
            self.genderList.append((element.key, element.value))
        }
    }
    
    
    // MARK: - Private Functions
    
    private func createGenderButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTheme(tint: .primaryTextColor, title: title, font: .regularText(size: 15))
        button.contentHorizontalAlignment = .left
        button.tag = tag
        button.addTarget(self, action: #selector(genderButtonPressed), for: .touchUpInside)
        return button
    }
    
    private func handleStackViewButtons() {
        stackView.removeAllArrangedSubviews()
        genderList.enumerated().forEach { (index, gender) in
            let button = createGenderButton(title: gender.name, tag: index)
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Action
    
    @objc private func genderButtonPressed(_ sender: UIButton) {
        let index = sender.tag
        self.dismiss(animated: true) {
            self.delegate?.setGender(to: self.genderList[safe: index])
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        popBackgroundView.setThemeBackgroundColor(.primaryBackgroundColor)
        screenTitleLabel.setTheme(text: "Gender".localized,
                                  themeColor: .primaryEndColor, font: .semiBoldTitle(size: 20))
        cancelButton.setTheme(tint: .primaryEndColor, title: "Cancel".localized, font: .regularText(size: 20))
    }
    
}
