//
//  HotOrNotShowTableItem.swift
//  
//
//  Created by ScriptSun on 9/23/20.
//

import UIKit
import Async
import SDWebImage
import QuickDateSDK

protocol HotOrNotShowTableItemDelegate: AnyObject {
    func deleteItem(at indexPath: IndexPath?)
}

class HotOrNotShowTableItem: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var btnUserLocation: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    // MARK: - Properties
    var user: UserProfileSettings? {
        didSet {
            self.profileImageView.sd_setImage(with: user?.avatarURL,
                                          placeholderImage: .thumbnail)
            fullNameLabel.text = user?.fullname
            GetMapAddress.getAddress(selectedLat: Double(user?.coordinate.latitude ?? "0") ?? 0, selectedLon: Double(user?.coordinate.longitude ?? "0") ?? 0) { stAddress in
                self.btnUserLocation.setTitle(stAddress, for: .normal)
            }
            let isLiked = user?.isLiked ?? false
                       self.handleLikeButtonImage(with: isLiked)
                       self.likeStatus = isLiked
        }
    }
    
    var indexPath: IndexPath?
    
    weak var delegate: HotOrNotShowTableItemDelegate?
    private let appInstance: AppInstance = .shared
    private let networkManager: NetworkManager = .shared
    private var likeStatus: Bool = false

    var hotOrNotVC: HotOrNotVC?
//    var userID:Int? = 0
//    var indexPath:Int? = 0
    // MARK: - Lifecycle
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
    // MARK: - Services
    private func handleLikeButtonImage(with likeStatus: Bool) {
           let image: UIImage? = likeStatus ? .heartFill : .heartEmpty
           let color: UIColor? = likeStatus ? .heartRed : .white
           self.likeBtn.setImage(image, for: .normal)
           self.likeBtn.tintColor = color
       }
    
    private func getLikeOrDislike() {
            guard appInstance.isConnectedToNetwork(in: self.hotOrNotVC?.view) else { return }
            
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
                            self.hotOrNotVC?.dismissProgressDialog {
                                self.hotOrNotVC?.view.makeToast(error.localizedDescription)
                                Logger.error("error = \(error)")
                            }
                        })
                    case .success(_):
                        Async.main({
                            self.hotOrNotVC?.dismissProgressDialog {
                                self.likeStatus = !self.likeStatus
                                self.handleLikeButtonImage(with: self.likeStatus)
                            }
                        })
                    }
                }
            })
           
        }

    
    private func sendAction(with action: Action) {
        guard appInstance.isConnectedToNetwork(in: self.hotOrNotVC?.view) else { return }
        guard let userId = user?.id,
              let indexPath = indexPath else { // Safety check
            Logger.error("getting user"); return
        }
        let accessToken = appInstance.accessToken ?? ""
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
                        if let hotOrNotVC = self.hotOrNotVC {
                            hotOrNotVC.dismissProgressDialog {
                                hotOrNotVC.view.makeToast(error.localizedDescription)
                                Logger.error("error = \(error.localizedDescription)")
                            }
                        }
                    })
                    
                case .success(_):
                    self.delegate?.deleteItem(at: indexPath)
                }
            }
        })
    }
    
    // MARK: - Actions
    
    private enum Action {
        case hot
        case not
    }
    
    @IBAction func onBtnLikeDisLike(_ sender: UIButton) {
        getLikeOrDislike()
    }
    @IBAction func hotPressed(_ sender: UIButton) {
        sendAction(with: .hot)
    }
    @IBAction func notPressed(_ sender: UIButton) {
        sendAction(with: .not)
    }
        
}

extension HotOrNotShowTableItem: NibReusable {}
