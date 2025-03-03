
import UIKit
import XLPagerTabStrip

class LifeStyleFilterVC: BaseViewController {

    @IBOutlet weak var drinkTextFIeld: FloatingTextField!
    @IBOutlet weak var smokeTextField: FloatingTextField!
    @IBOutlet weak var relationShipTextField: FloatingTextField!
    
    @IBOutlet weak var viewRelation: UIView!
    @IBOutlet weak var viewSmoke: UIView!
    @IBOutlet weak var viewDrink: UIView!
    
    
    // MARK: - Properties
    // Property Injections
    private let appNavigator: AppNavigator = .shared
    private var appInstance: AppInstance = .shared
    
    private var filters = Defaults.shared.get(for: .trendingFilter) ?? TrendingFilter()
    // Others
    var drinkStringIndex:String? = ""
    var smokeStringIndex:String? = ""
    var religionStringIndex:String? = ""
   
    var drinkStatus = false
    var smokeStatus = false
    var relationshipStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.resetFilter()
    }
    
    private func resetFilter() {
        AppManager.shared.onResetFilter = { [weak self] () -> Void in
            guard let self = self else { return }
            self.drinkTextFIeld.text = ""
            self.smokeTextField.text = ""
            self.relationShipTextField.text = ""
            appInstance.trendingFilters.lifeStyle.relationship = ""
            appInstance.trendingFilters.lifeStyle.smoke = ""
            appInstance.trendingFilters.lifeStyle.drink = ""
        }
    }
    
    private func setupUI() {
        drinkTextFIeld.setTitle(title: "Drink", isMandatory: false)
        smokeTextField.setTitle(title: "Smoke", isMandatory: false)
        relationShipTextField.setTitle(title: "Relationship", isMandatory: false)
        
        viewRelation.cornerRadiusV = viewRelation.frame.height / 2
        viewRelation.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewRelation.borderWidthV = 1
        
        viewSmoke.cornerRadiusV = viewSmoke.frame.height / 2
        viewSmoke.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewSmoke.borderWidthV = 1
        
        viewDrink.cornerRadiusV = viewDrink.frame.height / 2
        viewDrink.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewDrink.borderWidthV = 1
        
        let filters = appInstance.trendingFilters
        
        switch filters.lifeStyle.relationship {
        case .some(let text): self.relationShipTextField.text = text.capitalized
        case .none:           self.relationShipTextField.placeholder = "RelationShip".localized
        }
        
        switch filters.lifeStyle.drink {
        case .some(let text): self.drinkTextFIeld.text = text.capitalized
        case .none:           self.drinkTextFIeld.placeholder = "Drink".localized
        }
        
        switch filters.lifeStyle.smoke {
        case .some(let text): self.smokeTextField.text = text.capitalized
        case .none:           self.smokeTextField.placeholder = "Smoke".localized
        }
        
    }
    
    @IBAction func drinkPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .drink))
    }
    @IBAction func smokePressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .smoke))
    }
    
    @IBAction func relationShipPressed(_ sender: UIButton) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .relationship))
    } 
}

extension LifeStyleFilterVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("LIFESTYLE", comment: "LIFESTYLE").capitalized)
    }
}

extension LifeStyleFilterVC: DidSetProfilesParamDelegate {
    
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType) {
        if type == .relationship {
            self.relationShipTextField.text = selectedString.capitalized
            appInstance.trendingFilters.lifeStyle.relationship = selectedString
            
        } else if type == .smoke {
            self.smokeTextField.text = selectedString.capitalized
            appInstance.trendingFilters.lifeStyle.smoke = selectedString
            
        } else if type == .drink {
            self.drinkTextFIeld.text = selectedString.capitalized
            appInstance.trendingFilters.lifeStyle.drink = selectedString

        }
    }
    
    
}
