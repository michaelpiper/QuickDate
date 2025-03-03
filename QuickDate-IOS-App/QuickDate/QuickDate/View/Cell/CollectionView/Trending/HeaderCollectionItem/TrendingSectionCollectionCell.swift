//
//  TrendingSectionCollectionCell.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 31.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

enum TrendingSection: String {
    case proUsers = ""//"Pro Users"
    case hot      = "Hot or Not"
    case trending = "Trending"
    
    var viewIsHidden: Bool {
        switch self {
        case .proUsers: return true
        case .hot:      return false
        case .trending: return false
        }
    }
}

class TrendingSectionCollectionCell: UICollectionViewCell {
    
    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    // MARK: - Properties
    
    private let appNavigator: AppNavigator = .shared
    
    var section: TrendingSection? {
        didSet {
            titleLabel.text = section?.rawValue
            viewMoreButton.isHidden = section?.viewIsHidden ?? true
        }
    }
    
//    var userList: [UserProfileSettings]?

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Action
    
//    @IBAction func viewMoreButtonPressed(_ sender: UIButton) {
//        guard let userList = userList else {
//            Logger.error("getting userList"); return
//        }
//        appNavigator.trendingNavigate(to: .hotOrNot(userList: userList))
//    }

}

extension TrendingSectionCollectionCell: NibReusable {}
