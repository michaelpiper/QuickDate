//
//  ImagePreviewVC.swift
//  QuickDate
//
//  Created by iMac on 05/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class ImagePreviewVC: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var object: ChatModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if object?.message_type == "media" {
            if let object = object?.media {
                let thumbnailURL = URL.init(string: object)
                self.imageView.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
            }else {
                self.imageView.image = R.image.imagePlacholder()
            }
        }else {
            if let object = object?.sticker {
                let thumbnailURL = URL.init(string: object)
                self.imageView.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
            }else {
                self.imageView.image = R.image.imagePlacholder()
            }
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
}

