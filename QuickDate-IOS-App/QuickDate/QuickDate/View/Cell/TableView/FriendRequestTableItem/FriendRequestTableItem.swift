//
//  FriendRequestTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

class FriendRequestTableItem: UITableViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var notifyContentLabel: UILabel!
    @IBOutlet var notifyTypeIcon: UIImageView!
    
    var uid: Int?
    var vc:RequestVC?
    var baseVC:BaseViewController?
    var indexPath:Int = 0
    var notification: AppNotification? {
        didSet {
            guard let notification = notification else {
                Logger.error("getting user")
                return
            }
            notifyTypeIcon.image = .heartFillCustom
            notifyContentLabel.text = "Requested to be a friend with you".localized
            avatarImageView.sd_setImage(with: notification.notifierUser.avatarURL,
                                        placeholderImage: .unisexAvatar)
            self.userLabel.text = notification.notifierUser.fullname
            self.uid = Int(notification.notifierUser.id)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.circleView()
        self.notifyTypeIcon.circleView()
          self.notifyTypeIcon.backgroundColor = .Main_StartColor
        self.selectBtn.backgroundColor = .Button_StartColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func AcceptPressed(_ sender: UIButton) {
        approveFriend(uid: self.uid ?? 0)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.disApproveFriend(uid: self.uid ?? 0)
    }
    
    private func approveFriend(uid: Int) {        
        let accessToken = AppInstance.shared.accessToken ?? ""
        Async.background({
            FriendManager.instance.approveFriendRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                            self.vc?.requestList.remove(at: self.indexPath )
                            self.vc?.tableVIew.reloadData()
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            
                            self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    })
                }else {
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.vc?.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
    private func disApproveFriend(uid:Int) {
        
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            FriendManager.instance.disApproveFriendRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                            self.vc?.requestList.remove(at: self.indexPath )
                            self.vc?.tableVIew.reloadData()
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            
                            self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    })
                }else {
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.vc?.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
    
}

extension FriendRequestTableItem: NibReusable {}
