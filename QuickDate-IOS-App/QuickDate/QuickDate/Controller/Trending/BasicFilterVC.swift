
import UIKit

import Async
import WARangeSlider
import XLPagerTabStrip

class BasicFilterVC: BaseViewController {
    
    @IBOutlet weak var lookingForLabel: UILabel!
    // Location
    @IBOutlet weak var locationSectionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    // Gender
    @IBOutlet var genderButtonList: [UIButton]!
    // Age
    @IBOutlet weak var ageSectionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var rangeSlider: RangeSlider!
    // Distance
    @IBOutlet weak var distanceSectionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    // Online
    @IBOutlet weak var onlineNowLabel: UILabel!
    @IBOutlet weak var onlineSwitch: UISwitch!
    // Reset
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    
    private let color = UIColor.Main_StartColor
    private var genderString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        applyFilterSettings(from: appInstance.trendingFilters )
        self.resetFilter()
    }
    
    // MARK: - Services
    
    private func applyFilterSettings(from filters: TrendingFilter) {
        handleLocation(with: filters.basic.location ?? "Turkey")
        handleGenderButtonsDesign(with: filters.basic.gender.rawValue)
        handleAge(from: filters)
        handleDistance(from: filters)
        handleSwitchDesign(with: filters.basic.onlineNow ?? false)
    }
    
    private func handleGenderButtonsDesign(with buttonIndex: Int) {
        genderButtonList.enumerated().forEach { (index, button) in
            switch index {
            case buttonIndex:
                button.backgroundColor = .PrimaryColor
                button.setTitleColor(.white, for: .normal)
            default:
                button.borderWidthV = 1
                button.borderColorV = .hexStringToUIColor(hex: "BDBDBD")
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .clear
            }
        }
    }
    
    private func handleAge(from filters: TrendingFilter) {
        let loverAge = filters.basic.ageFrom
        let upperAge = filters.basic.ageTo
        
        rangeSlider.lowerValue = loverAge/100
        rangeSlider.upperValue = upperAge/100
        
        ageLabel.text = "\(loverAge.toString(with: 0)) - \(upperAge.toString(with: 0))"
    }
    
    private func handleLocation(with location: String) {
        locationLabel.text = location
    }
    
    private func handleDistance(from filters: TrendingFilter) {
        distanceSlider.value = filters.basic.distance
        distanceLabel.text =  "\(filters.basic.distance.toString(with: 0)) km"
    }
    
    private func handleSwitchDesign(with isOnline: Bool) {
        let thumbColor: UIColor? = isOnline ? Theme.primaryEndColor.colour : .systemGray4
        onlineSwitch.thumbTintColor = thumbColor
        onlineSwitch.onTintColor = Theme.primaryEndColor.colour.withAlphaComponent(0.3)
        onlineSwitch.isOn = isOnline
    }
    
    private func resetFilter() {
        AppManager.shared.onResetFilter = { [weak self] () -> Void in
            guard let self = self else { return }
            self.rangeSlider.lowerValue = 0.18
            self.rangeSlider.upperValue = 0.75
            handleGenderButtonsDesign(with: 2)
            self.distanceLabel.text = "35km"
            distanceSlider.value = 35
            
            appInstance.trendingFilters.basic.distance = 32
            appInstance.trendingFilters.basic.gender = Gender(rawValue: 2)
            appInstance.trendingFilters.basic.ageFrom = 0.18
            appInstance.trendingFilters.basic.ageTo = 0.75
        }
    }
    
    // MARK: - Actions
    
    @IBAction func applyFilter(_ sender: UIButton) {
//        self.filter()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        // FIXME: write to country codes
        Logger.debug("location button pressed...")
    }
    
    
    // !!!: Tag Values: 0-girls, 1-boys, 2-both
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        handleGenderButtonsDesign(with: sender.tag)
        appInstance.trendingFilters.basic.gender = Gender(rawValue: sender.tag)
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        let lowerValue = rangeSlider.lowerValue * 100
        let upperValue = rangeSlider.upperValue * 100
        self.ageLabel.text = "\(lowerValue.toString(with: 0)) - \(upperValue.toString(with: 0))"
        appInstance.trendingFilters.basic.ageFrom = lowerValue
        appInstance.trendingFilters.basic.ageTo = upperValue
        
    }
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        appInstance.trendingFilters.basic.distance = sender.value
        self.distanceLabel.text = "\(sender.value.toString(with: 0)) Km"
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        handleSwitchDesign(with: sender.isOn)
    }
}

// MARK: - didSelectCountryDelegate
extension BasicFilterVC: didSelectCountryDelegate {
    func selectCountry(status: Bool, countryString: String) {
//        self.countryLabel.text = countryString
        AppInstance.shared.location = countryString
    }
    
    
}
extension BasicFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("BASICS", comment: "BASICS").capitalized)
    }
}

// MARK: - Helpers

extension BasicFilterVC {
    
    private func createThumbImage(width: CGFloat) -> UIImage {
        let thumb = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        thumb.cornerRadiusV = width / 2
        thumb.backgroundColor = Theme.primaryEndColor.colour
        let renderer = UIGraphicsImageRenderer(bounds: thumb.bounds)
        return renderer.image { rendererContext in
            thumb.layer.render(in: rendererContext.cgContext)
        }
    }
    
    private func changeSliderThumbSize() {
        let thumb = createThumbImage(width: 14)
        let highlightedThumb = createThumbImage(width: 20)
        distanceSlider.setThumbImage(thumb, for: .normal)
        distanceSlider.setThumbImage(highlightedThumb, for: .highlighted)
        
    }
    
    private func setupUI() {
        self.lookingForLabel.text = "Who are you looking for?".localized
        // Location
        locationSectionLabel.text = "Location".localized
        // Gender
        genderButtonList.enumerated().forEach { (index, button) in
            let title = index == 0 ? "GIRLS".localized
            : index == 1 ? "BOYS".localized : "BOTH".localized
            button.setTheme(background: .primaryBackgroundColor,
                            tint: .primaryTextColor,
                            title: title, font: .regularText(size: 13))
        }
        // Age
        self.ageSectionLabel.text = "Age".localized
        self.ageLabel.text = "18-75"
        self.rangeSlider.lowerValue = 0.18
        self.rangeSlider.upperValue = 0.75
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
        // Distance
        self.distanceSectionLabel.text = "Distance".localized
        self.distanceLabel.text = "35km"
        // Online
        self.onlineNowLabel.text = "Online Now".localized
        onlineSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        // Reset
        
        
        changeSliderThumbSize()
    }
}
