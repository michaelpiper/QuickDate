//
//  DashboardFilterViewController.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 20.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

protocol DashboardFilterDelegate: AnyObject {
    func applyFilterSettings()
}

enum FilterType {
    case dashboard
    case hotOrNot
}

/// - Tag: DashboardFilterViewController
class DashboardFilterViewController: UIViewController, PanModalPresentable {
    
    // MARK: - Views
    @IBOutlet weak var viewOnline: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewBirthday: UIView!
    @IBOutlet weak var viewApplyFilterButton: UIView!
    // Labels
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet var sectionLabelList: [UILabel]!
    // Others
    @IBOutlet var imageViewList: [UIImageView]!
    @IBOutlet weak var onlineSwitch: UISwitch!
    // Buttons
    @IBOutlet var genderButtonList: [UIButton]!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var resetFilterButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var lblBirthday: UILabel!
    //ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Properties
    var panScrollable: UIScrollView? {
        return scrollView
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(500.0)
    }
    
    private var defaults: Defaults = .shared
    
    var filterType: FilterType = .dashboard
    private var birthDay: Date?

    private var filters: DashboardFilter = DashboardFilter()
    
    //    private var dashboardFilter = Defaults.shared.get(for: .dashboardFilter) ?? DashboardFilter()
    
    private weak var dashboardFilter: DashboardFilter?
    private weak var hotOrNotFilter: DashboardFilter?
    
    weak var delegate: DashboardFilterDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConfigures()
        applyFilterSettings(type: filterType)
        viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 24)
    }
    
    // MARK: - Services
    
    private func applyFilterSettings(type: FilterType) {
        filters = type == .dashboard
        ? defaults.get(for: .dashboardFilter) ?? DashboardFilter()
        : defaults.get(for: .hotOrNotFilter) ?? DashboardFilter()
        
        handleSwitchDesign(with: filters.onlineNow ?? false)
        handleGenderButtonsDesign(with: filters.gender.rawValue)
    }
    
    // MARK: - Private Functions
    
    private func handleGenderButtonsDesign(with buttonIndex: Int) {
        genderButtonList.enumerated().forEach { (index, button) in
            switch index {
            case buttonIndex:
                button.setTheme(background: .primaryEndColor)
                button.tintColor = .white
            default:
                button.setTheme(background: .primaryBackgroundColor, tint: .primaryTextColor)
            }
        }
    }
    
    private func handleSwitchDesign(with isOnline: Bool) {
        let thumbColor: UIColor? = isOnline ? Theme.primaryEndColor.colour : Theme.secondaryBackgroundColor.colour
        onlineSwitch.thumbTintColor = thumbColor
        onlineSwitch.onTintColor = Theme.primaryEndColor.colour.withAlphaComponent(0.3)
        onlineSwitch.isOn = isOnline
    }
    
    // MARK: - Action
    // !!!: Tag Values: 0-girls, 1-boys, 2-both
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        handleGenderButtonsDesign(with: sender.tag)
        filters.gender = Gender(rawValue: sender.tag)
    }
    
    @IBAction func onBtnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func birthdayButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        showBirthDayPicker()
    }
    
    @IBAction func onlineSwitchChanged(_ sender: UISwitch) {
        handleSwitchDesign(with: sender.isOn)
        filters.onlineNow = sender.isOn
    }
    
    @IBAction func resetFilterButtonPressed(_ sender: UIButton) {
        switch filterType {
        case .dashboard: defaults.clear(.dashboardFilter)
        case .hotOrNot:  defaults.clear(.hotOrNotFilter)
        }
        filters = DashboardFilter()
        applyFilterSettings(type: filterType)
        
    }
    
    @IBAction func applyFilterButtonPressed(_ sender: UIButton) {
        switch filterType {
        case .dashboard: defaults.set(filters, for: .dashboardFilter)
        case .hotOrNot:  defaults.set(filters, for: .hotOrNotFilter)
        }
        
        self.dismiss(animated: true) {
            self.delegate?.applyFilterSettings()
        }
    }
}

// MARK: - ThemeLoadable
extension DashboardFilterViewController: LabelThemeLoadable, ButtonThemeLoadable {
    internal func configureButtons() {
        let regular14: Typography = .regularText(size: 14)
        let regular16: Typography = .regularText(size: 16)
        genderButtonList.enumerated().forEach { (index, button) in
            let title = index == 0 ? "GIRLS".localized
            : index == 1 ? "BOYS".localized : "BOTH".localized
            button.setTheme(background: .primaryBackgroundColor,
                            tint: .primaryTextColor,
                            title: title, font: regular14)
        }
        birthdayButton.setTheme(tint: .secondaryTextColor, title: "")
        resetFilterButton.setTheme(tint: .secondaryTextColor,
                                   title: "RESET FILTERS".localized,
                                   font: regular16)
        viewApplyFilterButton.cornerRadiusV = viewApplyFilterButton.frame.height / 2
        viewBirthday.cornerRadiusV = viewBirthday.frame.height / 2
        viewBirthday.borderColorV = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewBirthday.borderWidthV = 1
        viewOnline.cornerRadiusV = viewOnline.frame.height / 2
        viewOnline.borderWidthV = 1
        viewOnline.borderColorV = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
    }
    
    internal func configureLabels() {
        screenTitle.text = "Filter".localized
        //        screenTitle.setTheme(text: "Filter".localized, themeColor: .primaryTextColor, font: .regularText(size: 17))
        
        sectionLabelList.enumerated().forEach { (index, label) in
            let text = index == 0 ? "Who are you looking for?".localized
            : index == 1 ? "Birthday".localized : "Online Now".localized
            label.text = text
        }
    }
    
    internal func configureUIViews() {
        imageViewList.forEach {$0.setThemeTintColor(.secondaryTextColor)}
        onlineSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
    }
    
    internal func setUpConfigures() {
        configureButtons()
        configureLabels()
        configureUIViews()
    }
    
    private func showBirthDayPicker() {
        let alertController = UIAlertController(title: "Birthday\n\n\n\n\n\n\n\n",
                                                message: nil, preferredStyle: .alert)
        let datePicker = createDatePicker()
        datePicker.frame = CGRect(x: 0, y: 25, width: 270, height: 200)
        if let birthDay = birthDay { // show selected birthday
            datePicker.date = birthDay
        }
        alertController.view.addSubview(datePicker)
        let selectAction = UIAlertAction(title: "Ok".localized, style: .default, handler: { _ in
            self.fetchBirthday(datePicker.date)
        })
        alertController.addAction(selectAction)
        alertController.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    private func fetchBirthday(_ date: Date) {
        self.birthDay = date
        let day = date.getFormattedDate(format: "dd-MM-yyyy")
        lblBirthday.text = day
        filters.birthDay = day
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = Theme.primaryBackgroundColor.colour
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return datePicker
    }
}
