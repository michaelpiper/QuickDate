

import UIKit
import XLPagerTabStrip


class BackgroundFilterVC: BaseViewController {
    
    @IBOutlet weak var languageTextField: FloatingTextField!
    @IBOutlet weak var religionTextField: FloatingTextField!
    @IBOutlet weak var ethnicityTextField: FloatingTextField!
    
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var viewReligion: UIView!
    @IBOutlet weak var viewEthnicity: UIView!
    
    
    // MARK: - Properties
    private let appNavigator: AppNavigator = .shared
    private let appInstance: AppInstance = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.resetFilter()
    }
    
    private func resetFilter() {
        AppManager.shared.onResetFilter = { [weak self] () -> Void in
            guard let self = self else { return }
            self.languageTextField.text = ""
            self.religionTextField.text = ""
            self.ethnicityTextField.text = ""
            appInstance.trendingFilters.background.language = ""
            appInstance.trendingFilters.background.religion = ""
            appInstance.trendingFilters.background.ethnicity = ""
            
        }
    }
    
    private func setupUI() {
        languageTextField.setTitle(title: "Language", isMandatory: false)
        religionTextField.setTitle(title: "Religion", isMandatory: false)
        ethnicityTextField.setTitle(title: "Ethnicity", isMandatory: false)
        
        viewLanguage.cornerRadiusV = viewLanguage.frame.height / 2
        viewLanguage.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewLanguage.borderWidthV = 1
        
        viewReligion.cornerRadiusV = viewReligion.frame.height / 2
        viewReligion.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewReligion.borderWidthV = 1
        
        viewEthnicity.cornerRadiusV = viewEthnicity.frame.height / 2
        viewEthnicity.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewEthnicity.borderWidthV = 1
        
        let filters = appInstance.trendingFilters
        
        self.languageTextField.text = filters.background.language.capitalized
        
        switch filters.background.religion {
        case .some(let text): self.religionTextField.text = text.capitalized
        case .none:           self.religionTextField.placeholder = "Religion".localized
        }
        
        switch filters.background.ethnicity {
        case .some(let text): self.ethnicityTextField.text = text.capitalized
        case .none:           self.ethnicityTextField.placeholder = "Ethnicity".localized
        }
    }
    
    @IBAction func ethnicityPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .ethnicity))
        
    }
    
    @IBAction func languagePressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .language))
        
    }
    
    @IBAction func religionPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .religion))
        
    }
}

extension BackgroundFilterVC:DidSetProfilesParamDelegate{
    
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .language {
            self.languageTextField.text = selectedString.capitalized
            appInstance.trendingFilters.background.language = selectedString
        } else if type == .religion {
            self.religionTextField.text = selectedString.capitalized
            appInstance.trendingFilters.background.religion = selectedString
        } else if type == .ethnicity {
            self.ethnicityTextField.text = selectedString.capitalized
            appInstance.trendingFilters.background.ethnicity = selectedString
        }
    }
    
}
extension BackgroundFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("BACKGROUND", comment: "BACKGROUND").capitalized)
    }
}
