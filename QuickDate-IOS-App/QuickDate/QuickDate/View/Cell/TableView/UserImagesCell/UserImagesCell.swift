//
//  UserImagesCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserImagesCell: UITableViewCell {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: ShowUserDetailsCollectionItem.self)
        }
    }
    
    var mediaFiles = [String]()
    var vc: UIViewController?
    var baseVC: BaseViewController?
    var object: ShowUserProfileModel?
    
    var mediaFilesList: [MediaFile]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: - Delegate
extension UserImagesCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mediaFilesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ShowUserDetailsCollectionItem
        let  url = self.mediaFilesList?[indexPath.row].avatarURL
        cell.bind(url)
        return cell
    }
}


// MARK: - Delegate
extension UserImagesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = self.mediaFilesList?[indexPath.row].avatarURL
        let appNavigator: AppNavigator = .shared
        appNavigator.dashboardNavigate(to: .imageController(imageURL: url))
    }
}

// MARK: - FlowLayout
extension UserImagesCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension UserImagesCell: NibReusable {}
