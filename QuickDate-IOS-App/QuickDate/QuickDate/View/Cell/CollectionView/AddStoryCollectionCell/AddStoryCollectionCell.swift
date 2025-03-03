
import UIKit

class AddStoryCollectionCell: UICollectionViewCell {

    // Views
    @IBOutlet weak var profileImage: UIImageView!
    // Property
    var imageURL: URL? {
        didSet {
            self.profileImage.sd_setImage(with: imageURL, placeholderImage: .userAvatar)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  profileImage.circleView()
       // profileImage.borderColorV = .Main_StartColor
    }
    
}

extension AddStoryCollectionCell: NibReusable {}
