//
//  Defaults+Key.swift
//
//  Created by Nazmi Yavuz on 3.10.2021.
//  Copyright © 2021 Nazmi Yavuz. All rights reserved.
//

import Foundation

extension DefaultsKey {
    
    static let didLogUserIn = Key<Bool>("didLogUserIn")
    
    // 1: light, 2: dark
    static let userInterfaceStyle = Key<Int>("userInterfaceStyle")
    // User Session
    static let accessToken = Key<String>("accessToken")
    static let userID = Key<Int>("userID")

    // Show Tutorial
    static let wasDoneFirstLoading = Key<Bool>("wasDoneFirstLoading")
    
    // Dashboard Filter
    static let dashboardFilter = Key<DashboardFilter>("dashboardFilter")
    
    // Trending Filter
    static let trendingFilter = Key<TrendingFilter>("trendingFilter")
    
    // Trending Filter
    static let hotOrNotFilter = Key<DashboardFilter>("hotOrNotFilter")
}
