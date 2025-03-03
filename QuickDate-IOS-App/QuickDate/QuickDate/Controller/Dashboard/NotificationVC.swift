//
//  NotificationVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Async

class NotificationVC: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var Notificationlabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Properties
    private let networkManager: NetworkManager = .shared
    private let appInstance: AppInstance = .shared
    
    private let firstColor = UIColor(red: 220/255, green: 34/255, blue: 80/255, alpha: 1.0)
    
    private var offset: Int?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
        reloadPagerTabStripView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
    }
        
    // MARK: - PagerTabStrip
    
    override func updateIndicator(for viewController: PagerTabStripViewController,
                                  fromIndex: Int, toIndex: Int,
                                  withProgressPercentage progressPercentage: CGFloat,
                                  indexWasChanged: Bool) {
        
        super.updateIndicator(for: viewController, fromIndex: fromIndex,
                                 toIndex: toIndex, withProgressPercentage: progressPercentage,
                                 indexWasChanged: indexWasChanged)
        
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            
            if toIndex == 0 {
               
            } else {
              
            }
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let matchesVC = MatchesVC.instantiate(fromStoryboardNamed: .main)
        
        let visitsVC = VisitsVC.instantiate(fromStoryboardNamed: .main)
        
        let likesVC = LikesVC.instantiate(fromStoryboardNamed: .main)

        let requestVC = RequestVC.instantiate(fromStoryboardNamed: .main)
        
        return [matchesVC, visitsVC, likesVC, requestVC]
    }
    
    // MARK: Helper
    
    private func setupUI(){
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
}
