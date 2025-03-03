//
//  VideoView.swift
//  QuickDate
//
//  Created by iMac on 11/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
    
    static func loadVideoView(audioOnly:Bool) -> PreviewView {
        let view = Bundle.loadView(fromNib: "PreviewView", withType: PreviewView.self)
        view.audioOnly = audioOnly
        return view
    }
}

class PreviewView: UIView {

    @IBOutlet weak var videoView:UIView!
    @IBOutlet weak var placeholderLabel:UILabel!
    @IBOutlet weak var infoLabel:UILabel!
    var audioOnly:Bool = false
    var uid:UInt = 0
    func setPlaceholder(text:String) {
        placeholderLabel.text = text
    }
    
    func setInfo(text:String) {
        infoLabel.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
