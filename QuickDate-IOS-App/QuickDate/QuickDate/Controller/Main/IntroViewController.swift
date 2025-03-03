

import UIKit

/// - Tag: IntroViewController
class IntroViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var introCollectionView: UICollectionView!
    @IBOutlet var viewNext: UIView!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet var viewPrev: UIView!
    @IBOutlet var buttonPrev: UIButton!
    @IBOutlet var buttonGetStarted: UIButton!
    
    var index = 0
    var introArrays = [
        ["image": "Onboarding_icon1", "title": NSLocalizedString("Swipe Cards", comment: "Swipe Cards"), "content": NSLocalizedString("Swipe cards right and left if you like or dislike someone", comment: "Swipe cards right and left if you like or dislike someone")],
        ["image": "onboarding_ic_2", "title":  NSLocalizedString("Search Nearby", comment: "Search Nearby"), "content":  NSLocalizedString("Connect With Local Singles & Start Your Online Dating Adventure!", comment: "Connect With Local Singles & Start Your Online Dating Adventure!")],
        ["image": "onboarding_ic_3", "title": NSLocalizedString("Chat", comment: "Chat"), "content": NSLocalizedString("Connect with like minded people and exchange your love", comment: "Connect with like minded people and exchange your love")]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }
    
    func configView() {
        self.buttonGetStarted.setTitle(NSLocalizedString("Get Started", comment: "Get Started"), for: .normal)
        viewNext.circleView()
        viewPrev.circleView()
        buttonGetStarted.circleView()
        
        let color1 = UIColor(red: 30/255, green: 99/255, blue: 158/255, alpha: 1.0)
        let color2 = UIColor(red: 60/255, green: 176/255, blue: 162/255, alpha: 1.0)
        view.setGradientBackground(startColor: color1, endColor: color2, direction: .horizontal)
    }
    
    //MARK:- Actions
    @IBAction func buttonPrevAction(_ sender: UIButton) {
        if index > 0 {
            index -= 1
            introCollectionViewHandle()
        }
    }
    
    @IBAction func buttonGetStartedAction(_ sender: UIButton) {
        let appNavigator: AppNavigator = .shared
        appNavigator.navigate(to: .mainTab)
    }
    
    @IBAction func buttonNextAction(_ sender: UIButton) {
        if index < 2 {
            index += 1
            introCollectionViewHandle()
        }
    }
    
    //MARK:- Methods
    func introCollectionViewHandle() {
        pageControl.currentPage = index
        introCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        switch index {
        case 0:
            viewPrev.isHidden = true
            viewNext.isHidden = false
            buttonGetStarted.isHidden = true
            UIView.animate(withDuration: 0.5) {[weak self] in
                let color1 = UIColor(red: 30/255, green: 99/255, blue: 158/255, alpha: 1.0)
                let color2 = UIColor(red: 60/255, green: 176/255, blue: 162/255, alpha: 1.0)
                self?.view.setGradientBackground(startColor: color1, endColor: color2, direction: .horizontal)
            }
        case 1:
            viewPrev.isHidden = false
            viewNext.isHidden = false
            buttonGetStarted.isHidden = true
            UIView.animate(withDuration: 0.5) {[weak self] in
                let color1 = UIColor(red: 154/255, green: 184/255, blue: 211/255, alpha: 1.0)
                let color2 = UIColor(red: 212/255, green: 141/255, blue: 163/255, alpha: 1.0)
                self?.view.setGradientBackground(startColor: color1, endColor: color2, direction: .horizontal)
            }
        case 2:
            viewPrev.isHidden = false
            viewNext.isHidden = true
            buttonGetStarted.isHidden = false
            UIView.animate(withDuration: 0.5) {[weak self] in
                let color1 = UIColor(red: 210/255, green: 65/255, blue: 114/255, alpha: 1.0)
                let color2 = UIColor(red: 224/255, green: 65/255, blue: 55/255, alpha: 1.0)
                self?.view.setGradientBackground(startColor: color1, endColor: color2, direction: .horizontal)
            }
        default:
            return
        }
    }
}

extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCollectionViewCellID", for: indexPath) as! IntroCollectionViewCell
        cell.layer.cornerRadius = 8
        cell.introImage.image = UIImage(named: introArrays[indexPath.row]["image"]!)
        cell.introTitle.text = introArrays[indexPath.row]["title"]
        cell.introContent.text = introArrays[indexPath.row]["content"]
        
        return cell
    }
}

extension IntroViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 48
        let height = collectionView.frame.size.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 48
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        index = introCollectionView.indexPathsForVisibleItems[0].row
        introCollectionViewHandle()
    }
}
