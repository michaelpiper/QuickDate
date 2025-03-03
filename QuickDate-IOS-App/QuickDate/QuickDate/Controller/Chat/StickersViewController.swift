
import UIKit
import RealmSwift
import QuickDateSDK
import Async

protocol GiftDelegate: AnyObject {
    func selectGift(with giftId: Int)
}

protocol StickerDelegate: AnyObject {
    func selectSticker(with stickerId: Int)
}

class StickersViewController: UIViewController, PanModalPresentable {
    
    // MARK: - Views
    // CollectionView
//    internal let flowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: StickerAndGiftCollectionCell.self)
            collectionView.register(cellType: GetPremiumStickerCell.self)
//            flowLayout.minimumInteritemSpacing = 16
//            flowLayout.minimumLineSpacing = 16
//            collectionView.collectionViewLayout = flowLayout
        }
    }
    
    // MARK: - Properties
    private let realm = try? Realm()
    
    var panScrollable: UIScrollView? {
        return collectionView
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(500.0)
    }
        
    private var giftsAndStickers: GiftsAndStickers?
    var delegate: GetPremiumStickerDelegate?
    weak var giftDelegate: GiftDelegate?
    weak var stickerDelegate: StickerDelegate?

    private var stickerList: [Sticker] = []
    private var giftList: [Gift] = []
    
    private var giftListArray: [GiftSuccessModel] = []
    
    var checkStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGiftsAndStickersFromRealm()
        
    }
    
    // MARK: - Services
    private func fetchGiftsAndStickersFromRealm() {
        guard let giftsAndStickers = realm?.object(ofType: GiftsAndStickers.self, forPrimaryKey: 1),
              let giftsData = giftsAndStickers.giftsData,
              let stickersData = giftsAndStickers.stickersData else {
                  Logger.error("getting giftsAndStickers"); return
              }
        do {
            if checkStatus {
                let giftModel = try JSONDecoder().decode(GiftModel.self, from: giftsData)
                self.giftList = giftModel.data//.reversed()
            } else {
                let stickerModel = try JSONDecoder().decode(StickerModel.self, from: stickersData)
                self.stickerList = stickerModel.data.reversed()
            }
            collectionView.reloadData()
        } catch {
            Logger.error(error)
        }
    }
}

// MARK: - DataSource
extension StickersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !(AppInstance.shared.userProfileSettings?.is_pro ?? false) {
            return checkStatus ? giftList.count : stickerList.count
        }else {
            return 11
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !(AppInstance.shared.userProfileSettings?.is_pro ?? false) {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as StickerAndGiftCollectionCell
            cell.stickerLink = checkStatus
            ? self.giftList[indexPath.row].file
            : self.stickerList[indexPath.row].file
            return cell
        }else {
            if indexPath.row == 10 {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as GetPremiumStickerCell
                cell.delegate = self
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as StickerAndGiftCollectionCell
                cell.stickerLink = checkStatus
                ? self.giftList[indexPath.row].file
                : self.stickerList[indexPath.row].file
                return cell
            }
        }
    }
}

// MARK: - Delegate
extension StickersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objectId = checkStatus
        ? self.giftList[indexPath.row].id : self.stickerList[indexPath.row].id
        self.dismiss(animated: true) {
            if self.checkStatus {
                self.giftDelegate?.selectGift(with: objectId)
            } else {
                self.stickerDelegate?.selectSticker(with: objectId)
            }
        }
    }
}

// MARK: - FlowLayout -
extension StickersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !(AppInstance.shared.userProfileSettings?.is_pro ?? false) {
            let width = (collectionView.frame.size.width) / 2
            return CGSize(width: width, height: width)
        }else {
            if indexPath.row == 10 {
                let width = collectionView.frame.size.width
                return CGSize(width: width, height: 130)
            }else {
                let width = (collectionView.frame.size.width) / 2
                return CGSize(width: width, height: width)
            }
        }
    }
}

//MARK: - Get Premium Sticker Delegate -
extension StickersViewController: GetPremiumStickerDelegate {
    func getBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.getBtnAction(sender)
        }
    }
    
    func buyCreditsBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.buyCreditsBtnAction(sender)
        }
    }
}
