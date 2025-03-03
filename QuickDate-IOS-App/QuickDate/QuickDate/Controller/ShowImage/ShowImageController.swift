//
//  ShowImageController.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/13/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import SDWebImage

/// - Tag: ShowImageController
class ShowImageController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.sd_setImage(with: imageUrl)
    }
    
    @IBAction func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
