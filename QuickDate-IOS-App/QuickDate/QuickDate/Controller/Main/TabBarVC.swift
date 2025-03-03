//
//  MainTabBarViewController.swift
//  QuickDate
//
//  Created by iMac on 13/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK
import JGProgressHUD

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Properties
    var customTabBarView: TabView!
    var forceHideTabBar = false
    private var progressHUD: JGProgressHUD?
    private let imagePickerController = UIImagePickerController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        self.view.backgroundColor = .clear
        customTabBarView = (Bundle.main.loadNibNamed("TabView", owner: nil, options: nil)!.first as! TabView)
        customTabBarView.delegate = self
        
        var keyWindow: UIWindow?
        if #available(iOS 13.0, *) {
             keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        
        var tabBarHeight: CGFloat = tabBar.frame.size.height
        if #available(iOS 11.0, *) {
            if(keyWindow?.safeAreaInsets.top) ?? 44 > CGFloat(0.0) {
                tabBarHeight += (keyWindow?.safeAreaInsets.bottom) ?? 34
            }
        }
        
        if tabBarHeight < 60 {
            tabBarHeight = 68
        } else {
            tabBarHeight += 20
        }
        
        customTabBarView.frame = CGRect(x: 0.0, y: view.frame.size.height - tabBar.frame.size.height, width: view.frame.size.width, height: tabBarHeight)
        
        view.addSubview(customTabBarView)
        view.backgroundColor = .clear
        
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        
        customTabBarView.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        self.view.leadingAnchor.constraint(equalTo: customTabBarView!.leadingAnchor, constant: 0).isActive = true
        self.view.trailingAnchor.constraint(equalTo: customTabBarView!.trailingAnchor, constant: 0).isActive = true
        self.view.bottomAnchor.constraint(equalTo: customTabBarView!.bottomAnchor, constant: 0).isActive = true
        
        self.view.layoutIfNeeded()
        if forceHideTabBar {
            self.tabBar.isHidden = true
            self.customTabBarView.isHidden = true
        }        
        setupViewControllers()
    }
    
    internal func showProgressDialog(with text: String) {
        progressHUD = JGProgressHUD(style: .dark)
        progressHUD?.textLabel.text = text.localized
        progressHUD?.show(in: self.view)
    }
    
    internal func dismissProgressDialog(completionBlock: @escaping () ->()) {
        progressHUD?.dismiss()
        completionBlock()
        
    }
    
    private func setupViewControllers() {
        var viewControllers = [AnyObject]()
        let navController1: UINavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
        let navController2: UINavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ExploreNav") as! UINavigationController
        let navController3: UINavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "NotificationNav") as! UINavigationController
        let navController4: UINavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ChatNav") as! UINavigationController
        let navController5: UINavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ProfileNav") as! UINavigationController
        
        viewControllers = [navController1, navController2, navController3, navController4, navController5]
        self.viewControllers = viewControllers as? [UIViewController]
    }
    
    func setTabBarHidden(tabBarHidden: Bool, vc: UIViewController?) {
        if tabBarHidden {
            self.tabBar.isHidden = true
            self.customTabBarView.isHidden = tabBarHidden
            vc?.edgesForExtendedLayout = UIRectEdge.bottom
        } else {
            if !forceHideTabBar {
                self.tabBar.isHidden = true
                self.customTabBarView.isHidden = tabBarHidden
                vc?.edgesForExtendedLayout = UIRectEdge.top
            }
        }
    }
}

// MARK: - CustomTabBarViewDelegate
extension MainTabBarViewController: CustomTabBarViewDelegate {
    func tabSelecteAtIndex(tabIndex: Int) {
        let selectedVC = self.viewControllers![tabIndex]
        selectedIndex = tabIndex
        if self.selectedViewController == selectedVC {
            let navVc = self.selectedViewController as! UINavigationController
            navVc.popToRootViewController(animated: false)
        }
        super.selectedViewController = selectedViewController
        if tabIndex == 1 {
            if AppInstance.shared.userProfileSettings?.avatar == "https://quickdatescript.com/upload/photos/d-avatar.jpg" {
                let newVC = R.storyboard.popUps.noProfileVC()
                newVC?.delegate = self
                newVC?.modalTransitionStyle = .coverVertical
                newVC?.modalPresentationStyle = .overFullScreen
                self.present(newVC!, animated: true, completion: nil)
                return
            }
        }
    }
}

extension MainTabBarViewController: NoProfileDelegate {
    func addPhotoBtnAction(_ sender: UIButton) {
        let vc = R.storyboard.popUps.imagePickerPopupVC()
        vc?.delegate = self
        vc?.isOnlyPhoto = true
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true)
    }
}

extension MainTabBarViewController: ImagePickerPopupDelegate {
    func imagePickerType(_ type: Int) {
        imagePickerController.delegate = self
        switch type {
        case 1001:
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = ["public.image"]
        case 1002:
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.view.makeToast("Sorry Camera is not found...")
                return
            }
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = ["public.image"]
        default:
            break
        }
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension MainTabBarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       
        picker.dismiss(animated: true, completion: nil)
        self.updateAvatar(Image: image)
    }
    
    private func updateAvatar(Image:UIImage) {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let avatarImageData = Image.jpegData(compressionQuality: 0.2)
            Async.background({
                UpdateAvatarManager.instance.updateAvatar(AccesToken:accessToken , AvatarData: avatarImageData, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
