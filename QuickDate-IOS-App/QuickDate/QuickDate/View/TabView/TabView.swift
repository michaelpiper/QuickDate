//
//  TabView.swift
//  QuickDate
//
//  Created by iMac on 13/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//


import UIKit
import Async

protocol CustomTabBarViewDelegate: AnyObject {
    func tabSelecteAtIndex(tabIndex: Int)
}

class TabView: UIView {
    
    // MARK:- IBOutlets
    @IBOutlet var viewSubCorner: UIView!
    @IBOutlet var imagviewTabCollection: [UIImageView]!
    @IBOutlet var btnTab: [UIButton]!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet var viewTabCollection: [UIView]!
    @IBOutlet weak var btnProfileImage: UIButton!
    
    //MARK:-Properties
    private var lastIndex = 0
    weak var delegate: CustomTabBarViewDelegate?
    
    override func draw(_ rect: CGRect) {
        viewSubCorner.circleView()
    }
    
    // MARK: - View Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeSetup()
        setTabView()
    }
    
    // MARK: - Methods
    private func initializeSetup() {
        self.viewSubCorner.backgroundColor = Theme.tabBarBackgroundColor.colour
    }
    
    //MARK:-Functions
    private func setTabView(){
        for btn in btnTab {
            let stImageName = btn.imageView?.image
            btn.circleView()
            if lastIndex == btn.tag {
                btn.setImage(stImageName?.tintWithColor(UIColor.hexStringToUIColor(hex: "FF007F")), for: .normal)
                btn.backgroundColor = UIColor.hexStringToUIColor(hex: "FF007F").withAlphaComponent(0.1)
            }
            else {
                btn.setImage(stImageName?.tintWithColor(UIColor.hexStringToUIColor(hex: "4D4D4D")), for: .normal)
                btn.backgroundColor = .white
            }
        }
        self.btnProfileImage.setImage(R.image.no_profile_image(), for: .normal)
        Async.background({
            let userSettings = AppInstance.shared.userProfileSettings
            let url = URL(string: userSettings?.avatar ?? "")
            if url == nil{
                Async.main({
                    self.btnProfileImage.setImage(R.image.no_profile_image(), for: .normal)
                })
                
            }else{
                self.btnProfileImage.sd_setImage(with: url, for: .normal, placeholderImage: R.image.tab_profile_ic())
            }
        })
        self.updateProfileImage()
    }
    
    func updateProfileImage() {
        AppManager.shared.onUpdateProfile = { () in
            Async.background({
                let userSettings = AppInstance.shared.userProfileSettings
                let url = URL(string: userSettings?.avatar ?? "")
                if url == nil{
                    Async.main({
                        self.btnProfileImage.setImage(R.image.no_profile_image(), for: .normal)
                    })
                }else{
                    self.btnProfileImage.sd_setImage(with: url, for: .normal, placeholderImage: R.image.tab_profile_ic())
                }
            })
        }
    }
    
    func selectTabAt(index: Int) {
        lastIndex = index
        setTabView()
        delegate?.tabSelecteAtIndex(tabIndex: lastIndex)
    }
    
    //MARK:- IBAction
    @IBAction func onClickViewTab(_ sender: UIButton) {
        lastIndex = sender.tag
        selectTabAt(index: lastIndex)
    }
}
