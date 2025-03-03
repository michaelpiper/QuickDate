//
//  ImagePickerPopupVC.swift
//  QuickDate
//
//  Created by iMac on 27/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

protocol ImagePickerPopupDelegate {
    func imagePickerType(_ type: Int)
}

class ImagePickerPopupVC: UIViewController {
        
    @IBOutlet weak var btnImageGallery: UIButton!
    @IBOutlet weak var btnVideoGallery: UIButton!
    @IBOutlet weak var btnPhotoFromCamera: UIButton!
    @IBOutlet weak var btnVideoFromCamera: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var delegate: ImagePickerPopupDelegate?
    var isOnlyPhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnVideoGallery.isHidden = isOnlyPhoto
        self.btnVideoFromCamera.isHidden = isOnlyPhoto
    }
    
    @IBAction func imageFromGalleryPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            self.delegate?.imagePickerType(1001)
        }
    }
    
    @IBAction func imageFromCameraPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            self.delegate?.imagePickerType(1002)
        }
    }
    
    @IBAction func videoFromGalleryPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            self.delegate?.imagePickerType(1003)
        }
    }
    
    @IBAction func videoFromCameraPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true) { [self] in
            self.delegate?.imagePickerType(1004)
        }
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
