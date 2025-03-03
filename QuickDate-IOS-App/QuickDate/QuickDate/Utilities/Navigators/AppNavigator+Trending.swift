//
//  AppNavigator+Trending.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 1.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

extension AppNavigator: TrendingNavigator {
    
    enum TrendingScreen {
        /// [HotOrNotVC.swift](x-source-tag://HotOrNotVC)
        case hotOrNot(userList: [UserProfileSettings])
        
        var storyboard: StoryboardName {
            switch self {
            case .hotOrNot: return .trending
            }
        }
    }
    
    func trendingNavigate(to screen: TrendingScreen) {
        
        switch screen {
            
        case .hotOrNot(let userList):
            let viewController = HotOrNotVC.instantiate(fromStoryboardNamed: screen.storyboard)
            viewController.hotOrNotUserList = userList
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
