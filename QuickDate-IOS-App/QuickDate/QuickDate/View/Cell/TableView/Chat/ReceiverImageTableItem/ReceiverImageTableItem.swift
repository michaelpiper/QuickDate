//
//  ReceiverImageTableItem.swift
//  DeepSoundiOS
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage

class ReceiverImageTableItem: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var showBtn: UIButton!
    
    var delegate: ChatImageShowDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ object: ChatModel) {
        if object.message_type == "media" {
            let thumbnailURL = URL.init(string: object.media)
            let indicator = SDWebImageActivityIndicator.medium
            self.thumbnailImage.sd_imageIndicator = indicator
            DispatchQueue.global(qos: .userInteractive).async {
                self.thumbnailImage.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
            }
        }else{
            let thumbnailURL = URL.init(string: object.sticker)
            let indicator = SDWebImageActivityIndicator.medium
            self.thumbnailImage.sd_imageIndicator = indicator
            DispatchQueue.global(qos: .userInteractive).async {
                self.thumbnailImage.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
            }
        }
        let seen = object.created_at
        self.dateLabel.text = getDate(unixdate: seen, timezone: "GMT")
    }
    
    @IBAction func showImageAction(_ sender: UIButton) {
        if let image = self.thumbnailImage {
            self.delegate?.showImageBtn(sender, imageView: image)
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
