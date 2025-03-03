//
//  AppNavigator+Credit.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 31.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

extension AppNavigator: CreditNavigator {
    
    enum CreditScreen {
        /// [UpgradeAccountVC.swift](x-source-tag://UpgradeAccountVC)
        case upgradeAccount(UICollectionViewCell)
        /// [BankTransferVC](x-source-tag://BankTransferVC)
        case bankTransfer(PayingInformation)
        /// [PayVC](x-source-tag://PayVC)
        case pay(PayingInformation)

        var storyboard: StoryboardName {
            switch self {
            case .upgradeAccount: return .credit
            case .bankTransfer:   return .credit
            case .pay:            return .credit
            }
        }
    }
    
    func creditNavigate(to screen: CreditScreen) {
        
        switch screen {
            
        case .upgradeAccount(let delegate):
            let viewController = UpgradeAccountVC.instantiate(fromStoryboardNamed: screen.storyboard)
            viewController.delegate = delegate as? UpgradeAccountDelegate
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case .bankTransfer(let payInfo):
            
            let viewController = BankTransferVC.instantiate(fromStoryboardNamed: screen.storyboard)
            viewController.payInfo = payInfo
            navigationController?.pushViewController(viewController, animated: true)
            
        case .pay(let payInfo):
//            let viewController = PayVC.instantiate(fromStoryboardNamed: screen.storyboard)
            let viewController = PaymentCardVC.instantiate(fromStoryboardNamed: screen.storyboard)
            viewController.amount = payInfo.amount
            viewController.credits = payInfo.credits
            viewController.memberShipType = payInfo.memberShipType
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
