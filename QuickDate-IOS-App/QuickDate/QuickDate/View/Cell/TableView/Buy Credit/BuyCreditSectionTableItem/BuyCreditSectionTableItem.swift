//
//  BuyCreditSectionTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit

class BuyCreditSectionTableItem: UITableViewCell {
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!

    var dataSetArray = [dataSet]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.collectionView.isPagingEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func setupUI(){
//        let gradient: CAGradientLayer = CAGradientLayer()
//
//        gradient.colors = [UIColor.Main_StartColor, UIColor.Main_EndColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.bgView.frame.size.width, height: self.bgView.frame.size.height)

       // self.bgView.layer.insertSublayer(gradient, at: 0)
        collectionView.cornerRadiusV = 20
//
//        self.bgView.setGradientBackground(colorOne: .Main_StartColor, colorTwo: .Main_StartColor, horizontal: true)
        self.topLabel.text = NSLocalizedString("Your Quickdate Credits balance", comment: "Your Quickdate Credits balance")
        
        //self.bgView.circleView()
        self.creditLabel.text = "\(AppInstance.shared.userProfileSettings?.balance ?? 0.0) \(NSLocalizedString("Credits", comment: "Credits"))"
//        self.creditLabel.text = "\(AppInstance.shared.userProfile["balance"] as? String ?? "") \(NSLocalizedString("Credits", comment: "Credits"))"
        let bgColor = UIColor(named: "primaryEndColor")
        self.dataSetArray = [
            dataSet(title:NSLocalizedString("Boost your profile", comment: "Boost your profile") , bgColor: bgColor, bgImage: R.image.rocket_ic()),
            dataSet(title:NSLocalizedString("Highlight your messages", comment: "Highlight your messages"), bgColor: bgColor, bgImage: R.image.ic_chat()),
            dataSet(title: NSLocalizedString("send a gift", comment: "send a gift"), bgColor: bgColor, bgImage: R.image.ic_lucide_gift()?.withRenderingMode(.alwaysTemplate)),
            dataSet(title: NSLocalizedString("Get seen 100x in Discover", comment: "Get seen 100x in Discover"), bgColor: bgColor, bgImage: R.image.viewPager_target()),
            dataSet(title: NSLocalizedString("Put your self First in Search", comment: "Put your self First in Search"), bgColor: bgColor, bgImage: R.image.viewPager_crown()),
            dataSet(title: NSLocalizedString("Get additional Stickers", comment: "Get additional Stickers"), bgColor: bgColor, bgImage: R.image.viewPager_sticker()),
            dataSet(title: NSLocalizedString("Double your chances for a friendship", comment: "Double your chances for a friendship"), bgColor: bgColor, bgImage: R.image.viewPager_heart())
        ]
        collectionView.register(UINib(resource: R.nib.buyCreditSectionOneCollectionItem), forCellWithReuseIdentifier: R.reuseIdentifier.buyCreditSectionOneCollectionItem.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
}
extension BuyCreditSectionTableItem:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageView.numberOfPages = self.dataSetArray.count
        return self.dataSetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.buyCreditSectionOneCollectionItem.identifier, for: indexPath) as? BuyCreditSectionOneCollectionItem
        let object = dataSetArray[indexPath.row]
        cell!.bind(object)
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = collectionView.frame.size
        let width = size.width
        let cgFloatValue = collectionView.contentOffset.x / width
        // Works to much that's why I'm checking values
        let numbers = (0...(dataSetArray.count - 1)).map{ CGFloat($0) }
        guard cgFloatValue.controlEqualityAny(numbers) else { return }
        
        let pageIndex = Int(round(cgFloatValue))
        pageView.currentPage = Int(pageIndex)
        
    }
}
extension BuyCreditSectionTableItem: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
