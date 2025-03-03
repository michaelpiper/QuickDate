//
//  StartTableItem.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit


class StartTableItem: UITableViewCell {
    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet var firstImage1: UIImageView!
    @IBOutlet var firstImage2: UIImageView!
    @IBOutlet var heartImageView: UIView!
    @IBOutlet var heartImage: UIImageView!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var buttonRegister: UIButton!
    @IBOutlet var backgroundColoredView: UIView!
    
    var vc : StartVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(){
       
        buttonLogin.setTitleColor(.Button_TextColor, for: .normal)
        buttonRegister.setTitleColor(.Button_TextColor, for: .normal)
        
        self.topLabel.text = NSLocalizedString("Swipe right to like someone and if you both like each other? Its a match.", comment: "Swipe right to like someone and if you both like each other? Its a match.")
        
        self.buttonRegister.setTitle(NSLocalizedString("Register", comment: "Register"), for: .normal)
        
        self.buttonLogin.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        
        bottonLabel.text = NSLocalizedString("Flirt, Chat, and meet people around you.", comment: "Flirt, Chat, and meet people around you.")

       
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColoredView.halfCircleView()
        buttonLogin.setGradientBackground(startColor: .Button_StartColor, endColor: .Button_EndColor, direction: .horizontal)
        buttonRegister.setGradientBackground(startColor: .Button_StartColor, endColor: .Button_EndColor, direction: .horizontal)

        firstImage1.circleView()
        firstImage2.circleView()
        heartImageView.circleView()
        heartImage.circleView()
        buttonLogin.layer.cornerRadius = buttonLogin.frame.size.height / 2
        buttonRegister.layer.cornerRadius = buttonRegister.frame.size.height / 2
    }
    
    //MARK: - Actions
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        // push to Login VC
       let vc = R.storyboard.authentication.loginVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func buttonRegisterAction(_ sender: UIButton) {
        let vc = R.storyboard.authentication.registerVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
     
    }
}
