//
//  TrendingCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import SDWebImage
import RealmSwift
import QuickDateSDK

class TrendingCollectionItem: UICollectionViewCell {
    
    // MARK: - Views
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    // Constraints
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var user: UserProfileSettings? {
        didSet {
            if let user = user {
                self.profileImage.sd_setImage(with: user.avatarURL, placeholderImage: .thumbnail)
                self.userNameLabel.text  = user.fullname
                let date = Date(timeIntervalSince1970: TimeInterval(user.lastseen) ?? 0)
                self.timeLabel.text = Date().timeAgo(from: date)
//                self.timeLabel.text =  setTimestamp(epochTime: user.lastseen)
                let isLiked = user.isLiked
                self.handleLikeButtonImage(with: isLiked)
                self.likeStatus = isLiked
            }
        }
    }
    
    var indexPathRow: Int? {
        didSet {
            guard let indexPathRow = indexPathRow else {
                Logger.error("getting indexPathRow"); return
            }
            let isEven: Bool = indexPathRow % 2 == 0 ? true : false
            leadingConstraint.constant =  isEven ? 16 : 8
            leadingConstraint.isActive = true
            trailingConstraint.constant = isEven ? 8 : 16
            trailingConstraint.isActive = true
            self.layoutIfNeeded()
        }
    }
    
    private let networkManager: NetworkManager = .shared
    private let appInstance: AppInstance = .shared
    
    var viewController: UIViewController?
    
    var baseVC: BaseViewController?
//    var uid: Int? = 0
    private var likeStatus: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Services
    
    private func getLikeOrDislike() {
        guard appInstance.isConnectedToNetwork(in: self.viewController?.view) else { return }
        
        guard let user = user else { // Safety check
            Logger.error("getting user"); return
        }
        let accessToken = AppInstance.shared.accessToken ?? ""
        var params: APIParameters = [API.PARAMS.access_token: accessToken]
        // If true delete like else add like
        switch likeStatus {
        case true:  params[API.PARAMS.user_likeid] = user.id
        case false: params[API.PARAMS.likes] = user.id
        }
        // change url according to likeStatus
        let urlString = likeStatus
        ? API.USERS_CONSTANT_METHODS.DELETE_LIKE_API : API.USERS_CONSTANT_METHODS.ADD_LIKES_API
        
        Async.background({
            self.networkManager.fetchDataWithRequest(urlString: urlString, method: .post,
                                                parameters: params, successCode: .code) { response in
                switch response {
                case .failure(let error):
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.viewController?.view.makeToast(error.localizedDescription)
                            Logger.error("error = \(error)")
                        }
                    })
                case .success(_):
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.likeStatus = !self.likeStatus
                            self.handleLikeButtonImage(with: self.likeStatus)
                        }
                    })
                }
            }
        })
       
    }
    
    // MARK: - Private Functions
    
    private func handleLikeButtonImage(with likeStatus: Bool) {
        let image: UIImage? = likeStatus ? .heartFill : .heartEmpty
        let color: UIColor? = likeStatus ? .heartRed : .white
        self.likeBtn.setImage(image, for: .normal)
        self.likeBtn.tintColor = color
    }
    
    // MARK: - Actions
    
    @IBAction func heartPressed(_ sender: UIButton) {
        self.getLikeOrDislike()
        
    }
}

extension TrendingCollectionItem: NibReusable {}
