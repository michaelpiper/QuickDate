//
//  UserSocialLinkCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import SafariServices

class UserSocialLinkCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var socialInfoLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var userSocialData = [[String:Any]]()
    var superVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.register(UINib(nibName: "SocialInfoCell", bundle: nil), forCellWithReuseIdentifier: "SocialInfoCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindOtherUser(data: OtherUser){
        self.userSocialData.removeAll()
        let google = data.userDetails.socialMedia.google
        let facebook = data.userDetails.socialMedia.facebook
        let insta = data.userDetails.socialMedia.instagram
        let web = data.userDetails.socialMedia.webSite
        let linkedin = data.userDetails.socialMedia.linkedin
        let twitter = data.userDetails.socialMedia.twitter
        //
        //linkedin
        if !google.isEmpty {
            self.userSocialData.append(["google":google])
        }
        if !facebook.isEmpty {
            self.userSocialData.append(["facebook":facebook])
        }
        if linkedin != ""{
            self.userSocialData.append(["linkedin":linkedin])
        }
        if twitter != ""{
            self.userSocialData.append(["twitter":twitter])
        }
        if !insta.isEmpty {
            self.userSocialData.append(["instagram":insta])
        }
        if !web.isEmpty {
            self.userSocialData.append(["website":web])
        }
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userSocialData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialInfoCell", for: indexPath) as! SocialInfoCell
        let index = self.userSocialData[indexPath.row]
        if let _ = index["facebook"] as? String{
            cell.SocialImage.image = UIImage(named: "facebooks")
            cell.roundViews.borderColor = .blue
        }
        if let _ = index["google"] as? String{
            cell.SocialImage.image = UIImage(named: "google-glas")
            cell.roundViews.borderColor = .brown
        }
        if let _ = index["linkedin"] as? String{
            cell.SocialImage.image = UIImage(named: "ic_linkedin")
            cell.roundViews.borderColor = UIColor.hexStringToUIColor(hex: "096D00")
        }
        if let _ = index["twitter"] as? String{
            cell.SocialImage.image = UIImage(named: "ic_twitter")
            cell.roundViews.borderColor = UIColor.hexStringToUIColor(hex: "10A1EE")
        }
        if let _ = index["instagram"] as? String{
            cell.SocialImage.image = UIImage(named: "instagramss")
            cell.roundViews.borderColor = .magenta
        }
        if let _ = index["website"] as? String{
            cell.SocialImage.image = UIImage(named: "world")
            cell.roundViews.borderColor = .gray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.userSocialData[indexPath.item]
        if let face = index["facebook"] as? String{
            let link = face
            let url = URL(string: "\("https://www.facebook.com/")\(link)")
            if UIApplication.shared.canOpenURL(url!) {
                 UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "\("https://www.facebook.com/")\(link)") {
                    self.superVC?.present(SFSafariViewController(url: url), animated: true)
                }
            }
        }
        if let twit = index["twitter"] as? String{
            let link = twit
            let url = URL(string: "\("https://twitter.com/")\(link)")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "\("https://twitter.com/")\(link)") {
                    self.superVC?.present(SFSafariViewController(url: url), animated: true)
                }
            }
        }
        if let linkd = index["linkedin"] as? String{
            let link = linkd
            let url = URL(string: "\("https://www.linkedin.com/")\(link)")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "\("https://www.linkedin.com/")\(link)") {
                    self.superVC?.present(SFSafariViewController(url: url), animated: true)
                }
            }
        }
        if let google = index["google"] as? String{
            let link = google
            let url = URL(string: link)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                guard let url = URL(string: "https://plus.google.com/\(link)") else { return }
                self.superVC?.present(SFSafariViewController(url: url), animated: true)
            }
        }
        if let insta = index["instagram"] as? String{
            let link = insta
            let url = URL(string: link)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                guard let url = URL(string: "https://www.instagram.com/\(link)") else { return }
                self.superVC?.present(SFSafariViewController(url: url), animated: true)
            }
        }
        
        if let web = index["website"] as? String{
            let link = web
            if let url = URL(string: link) {
                self.superVC?.present(SFSafariViewController(url: url), animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension UserSocialLinkCell: NibReusable {}
