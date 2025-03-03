//
//  TutorialViewVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit

/// - Tag: TutorialViewVC
class TutorialViewVC: UIViewController {
    
    @IBOutlet weak var letsEasyLabel: UILabel!
    @IBOutlet var tutorialView: UIView!
    @IBOutlet var tutorialBgrView: UIView!
    @IBOutlet var tutorialContentLabel: UILabel!
    @IBOutlet var tutorialIcon: UIImageView!
    @IBOutlet var skipTutorialButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    // MARK: - Properties
    // Property Injections
    private let defaults: Defaults = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    private func setupUI(){
        self.letsEasyLabel.text = NSLocalizedString("Let's Easy", comment: "Let's Easy")
        self.tutorialContentLabel.text = NSLocalizedString("If you like this person and keep in touch, Swipe Right", comment: "If you like this person and keep in touch, Swipe Right")
        self.skipTutorialButton.setTitle(NSLocalizedString("Skip Tutorial", comment: "Skip Tutorial"), for: .normal)
        
         self.nextButton.setTitle(NSLocalizedString("Next", comment: "Next"), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        tutorialBgrView.setGradientBackground(startColor: .SecondaryColor, endColor: .PrimaryColor, direction: .horizontal)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        if skipTutorialButton.isHidden {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.tutorialView.alpha = 0
            }) { [weak self](_) in
                self?.defaults.set(true, for: .wasDoneFirstLoading)
                self?.tutorialView.removeFromSuperview()
                self?.dismiss(animated: true)
            }
        } else {
            /*UIView.transition(with: tutorialBgrView, duration: 0.5, options: .transitionCrossDissolve, animations: {[weak self] in*/
                self.tutorialContentLabel.text = NSLocalizedString("If you dislike this person and you don't want to keep in touch Swipe Left", comment: "If you dislike this person and you don't want to keep in touch Swipe Left")
                self.tutorialIcon.image = UIImage(named: "tutorial_ic_2")
                self.skipTutorialButton.isHidden = true
                self.nextButton.setTitle("Finish", for: .normal)
                self.nextButton.setTitleColor(UIColor.white, for: .normal)
                self.nextButton.backgroundColor = UIColor.clear
                self.nextButton.layer.borderWidth = 1
                self.nextButton.layer.borderColor = UIColor.white.cgColor
                /*}, completion: nil)*/
        }
    }
    
    @IBAction func skipTutorialButtonAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.tutorialView.alpha = 0
        }) { [weak self](_) in
            self?.defaults.set(true, for: .wasDoneFirstLoading)
            self?.tutorialView.removeFromSuperview()
            self?.dismiss(animated: true)
        }
    }
}
