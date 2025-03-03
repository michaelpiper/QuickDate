import UIKit
import XLPagerTabStrip
class MoreFilterVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var interestTextField: FloatingTextField!
    @IBOutlet weak var eductionTextField: FloatingTextField!
    @IBOutlet weak var petsTextField: FloatingTextField!
    
    @IBOutlet weak var viewInterest: UIView!
    @IBOutlet weak var viewEduction: UIView!
    @IBOutlet weak var viewPets: UIView!
    
    // MARK: - Properties
    private let appNavigator: AppNavigator = .shared
    private let appInstance: AppInstance = .shared
    
    private var filters = Defaults.shared.get(for: .trendingFilter) ?? TrendingFilter()
    
    var interestStringIndex:String? = ""
    var educationStringIndex:String? = ""
    var petsStringIndex:String? = ""
    
    var interestStatus = false
    var educationStatus = false
    var petsStatus = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interestTextField.delegate = self
        self.setupUI()
        self.resetFilter()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func resetFilter() {
        AppManager.shared.onResetFilter = { [weak self] () -> Void in
            guard let self = self else { return }
            self.interestTextField.text = ""
            self.eductionTextField.text = ""
            self.petsTextField.text = ""
            appInstance.trendingFilters.more.interest = ""
            appInstance.trendingFilters.more.education = ""
            appInstance.trendingFilters.more.pets = ""
        }
    }
    
    @IBAction func educationPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .education))
    }
    
    @IBAction func petsPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .pets))
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppInstance.shared.interest = textField.text ?? ""
    }
    
    private func setupUI(){
        
        interestTextField.setTitle(title: "Interest", isMandatory: false)
        eductionTextField.setTitle(title: "Education", isMandatory: false)
        petsTextField.setTitle(title: "Pets", isMandatory: false)
        
        viewInterest.cornerRadiusV = viewInterest.frame.height / 2
        viewInterest.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewInterest.borderWidthV = 1
        
        viewEduction.cornerRadiusV = viewEduction.frame.height / 2
        viewEduction.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewEduction.borderWidthV = 1
        
        viewPets.cornerRadiusV = viewPets.frame.height / 2
        viewPets.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewPets.borderWidthV = 1
        
        let filters = appInstance.trendingFilters
        
        switch filters.more.interest {
        case .some(let text): self.interestTextField.text = text.capitalized
        case .none: self.interestTextField.placeholder = "Interest".localized
        }
        
        switch filters.more.education {
        case .some(let text): self.eductionTextField.text = text.capitalized
        case .none: self.eductionTextField.placeholder = "Education".localized
        }
        
        switch filters.more.pets {
        case .some(let text): self.petsTextField.text = text.capitalized
        case .none: self.petsTextField.placeholder = "Pets".localized
        }
    }
}
extension MoreFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("MORE", comment: "MORE").capitalized)
    }
}
extension MoreFilterVC:DidSetProfilesParamDelegate{
    
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .interest {
            self.interestTextField.text = selectedString.capitalized
            appInstance.trendingFilters.more.interest = selectedString
            
        } else if type == .education {
            self.eductionTextField.text = selectedString.capitalized
            appInstance.trendingFilters.more.education = selectedString

        } else if type == .pets {
            self.petsTextField.text = selectedString.capitalized
            appInstance.trendingFilters.more.pets = selectedString
        }
    }
}
