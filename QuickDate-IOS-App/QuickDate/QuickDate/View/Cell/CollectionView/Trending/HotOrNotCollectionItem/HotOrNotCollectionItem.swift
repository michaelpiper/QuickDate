//
//  HotOrNotCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import SDWebImage
import CloudKit
import QuickDateSDK

protocol HotOrNotCollectionItemDelegate: AnyObject {
    func deleteCell(at indexPath: IndexPath)
}

class HotOrNotCollectionItem: UICollectionViewCell {
    
    
    // MARK: - Views
    @IBOutlet weak var ProfileImaGE: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    // MARK: - Properties
    var user: UserProfileSettings? {
        didSet {
            self.usernameLabel.text = user?.fullname
            self.ProfileImaGE.sd_setImage(with: user?.avatarURL, placeholderImage: .thumbnail)
            
            if user?.coordinate.latitude == "0" {
                self.userLocationLabel.text = user?.country_txt
            }else {
                GetMapAddress.getAddress(selectedLat: Double(user?.coordinate.latitude ?? "0") ?? 0, selectedLon: Double(user?.coordinate.longitude ?? "0") ?? 0) { stAddress in
                    self.userLocationLabel.text = stAddress
                }
            }
            let isLiked = user?.isLiked ?? false
            self.handleLikeButtonImage(with: isLiked)
            self.likeStatus = isLiked
        }
    }
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    private let appInstance: AppInstance = .shared
    private let notification: NotificationCenter = .default
    private var likeStatus: Bool = false
    var viewController: TrendingVC?
    weak var delegate: HotOrNotCollectionItemDelegate?
    var indexPath: IndexPath?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Services
    private func handleLikeButtonImage(with likeStatus: Bool) {
        let image: UIImage? = likeStatus ? .heartFill : .heartEmpty
        let color: UIColor? = likeStatus ? .heartRed : .white
        self.likeBtn.setImage(image, for: .normal)
        self.likeBtn.tintColor = color
    }
    
    
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
                        self.viewController?.dismissProgressDialog {
                            self.viewController?.view.makeToast(error.localizedDescription)
                            Logger.error("error = \(error)")
                        }
                    })
                case .success(_):
                    Async.main({
                        self.viewController?.dismissProgressDialog {
                            self.likeStatus = !self.likeStatus
                            self.handleLikeButtonImage(with: self.likeStatus)
                        }
                    })
                }
            }
        })
        
    }
    
    
    private func sendAction(with action: Action) {
        
        guard Connectivity.isConnectedToNetwork() else { return }
        
        guard let userId = user?.id,
              let indexPath = indexPath else { // Safety check
            Logger.error("getting user"); return
        }
        
        let params: APIParameters = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.user_id: "\(userId)"
        ]
        
        let urlString = action == .hot
        ? API.USERS_CONSTANT_METHODS.ADD_HOT_API : API.USERS_CONSTANT_METHODS.ADD_NOT_API
        
        Async.background({
            self.networkManager.fetchDataWithRequest(urlString: urlString, method: .post,
                                                     parameters: params, successCode: .status) { response in
                switch response {
                case .failure(let error):
                    Async.main({
                        let data: [String: String] = [
                            UserInfoKey.error.rawValue: error.localizedDescription
                        ]
                        
                        self.notification.post(name: .hotOrNotUserCellError,
                                               object: error.localizedDescription,
                                               userInfo: data)
                    })
                    
                case .success(_):
                    Async.main({
                        let data: [String: Int] = [
                            UserInfoKey.indexPath.rawValue: indexPath.row
                        ]
                        self.notification.post(name: .hotOrNotUserDelete, object: nil, userInfo: data)
                        self.delegate?.deleteCell(at: indexPath)
                    })
                }
            }
        })
    }
    
    // MARK: - Actions
    private enum Action {
        case hot
        case not
    }
    
    @IBAction func heartPressed(_ sender: UIButton) {
//        let uid = user?.id ?? "0"
        self.getLikeOrDislike()
    }
    
    @IBAction func hotPressed(_ sender: UIButton) {
        sendAction(with: .hot)
    }
    
    @IBAction func notPressed(_ sender: UIButton) {
        sendAction(with: .not)
    }
}

extension HotOrNotCollectionItem: NibReusable {}
