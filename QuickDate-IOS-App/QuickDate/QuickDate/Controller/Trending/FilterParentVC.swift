
import UIKit

import Async
import JGProgressHUD
import XLPagerTabStrip

protocol FilterDelegate: AnyObject {
    func filter(status:Bool)
}

class FilterParentVC: ButtonBarPagerTabStripViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var viewApplyFilter: UIView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private var hud: JGProgressHUD?
    weak var filterDelegate: FilterDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        self.configureUI()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    // MARK: - Private Functions
    private func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
    }
    
    //MARK: TabBar
    func showTabBar() {
        if let tabBarVC = navigationController?.tabBarController as? MainTabBarViewController {
            tabBarVC.setTabBarHidden(tabBarHidden: false, vc: self)
        }
    }
    
    func hideTabBar() {
        if let tabBarVC = navigationController?.tabBarController as? MainTabBarViewController {
            tabBarVC.setTabBarHidden(tabBarHidden: true, vc: self)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnResetFilter(_ sender: UIButton) {
        AppManager.shared.onResetFilter?()
    }
    
    @IBAction func applyFilterPressed(_ sender: UIButton) {
        let defaults: Defaults = .shared
        defaults.set(appInstance.trendingFilters, for: .trendingFilter)
        self.filterDelegate?.filter(status: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let filterVC = BasicFilterVC.instantiate(fromStoryboardNamed: .trending)
        let looksFilterVC = LooksFilterVC.instantiate(fromStoryboardNamed: .trending)
        let backgroundFilterVC = BackgroundFilterVC.instantiate(fromStoryboardNamed: .trending)
        let lifeStyleFilterVC = LifeStyleFilterVC.instantiate(fromStoryboardNamed: .trending)
        let moreFilterVC = MoreFilterVC.instantiate(fromStoryboardNamed: .trending)

        return [filterVC, looksFilterVC ,backgroundFilterVC, lifeStyleFilterVC, moreFilterVC]
    }
    
    private func createMainViewGradientLayer(to view: UIView, startColor: UIColor, endColor: UIColor) {
        view.removeGradientLayer()
        let gradientLayer = createGradient(colors: [startColor, endColor])
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func handleGradientColors() {
        _ = Theme.primaryStartColor.colour
        _ = Theme.primaryEndColor.colour
    }
    
    private func configureUI() {
        self.filterLabel.text = "Filter".localized
        configurePagerTabStrip()
        self.viewApplyFilter.cornerRadiusV = self.viewApplyFilter.bounds.height / 2
    }
    
    private func configurePagerTabStrip() {
        let newCellColor = Theme.primaryEndColor.colour
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = newCellColor
        settings.style.buttonBarItemFont = Typography.regularText(size: 14).font
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarMinimumLineSpacing = 20
        settings.style.buttonBarItemTitleColor = Theme.primaryEndColor.colour
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?,
                                           newCell: ButtonBarViewCell?,
                                           progressPercentage: CGFloat,
                                           changeCurrentIndex: Bool,
                                           animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Theme.primaryTextColor.colour
            newCell?.label.textColor = newCellColor
        }
    }
}

/*
 {
     self.Notificationlabel.text = NSLocalizedString("Notifications", comment: "Notifications")
     let lineColor = UIColor.Main_StartColor
     settings.style.buttonBarItemBackgroundColor = .clear
     settings.style.selectedBarBackgroundColor = lineColor
     settings.style.buttonBarItemFont = Typography.semiBoldTitle(size: 16).font
     settings.style.selectedBarHeight = 0
     settings.style.buttonBarMinimumLineSpacing = 20
     settings.style.buttonBarItemTitleColor = .black
     settings.style.buttonBarItemsShouldFillAvailableWidth = false
     settings.style.buttonBarLeftContentInset = 10
     settings.style.buttonBarRightContentInset = 10
     let newCellColor = Theme.primaryEndColor.colour
     changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
         guard changeCurrentIndex == true else { return }
         oldCell?.label.textColor = Theme.primaryTextColor.colour
         newCell?.label.textColor = newCellColor
     }
 }
 */
