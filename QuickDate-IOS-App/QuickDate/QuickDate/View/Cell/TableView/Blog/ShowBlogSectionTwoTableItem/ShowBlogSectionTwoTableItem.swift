//
//  ShowBlogSectionTwoTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
//import WebKit WKNavigationDelegate

class ShowBlogSectionTwoTableItem: UITableViewCell {
    
    @IBOutlet weak var showTextLabel: UILabel!
//        @IBOutlet weak var webView: WKWebView!
    
    var vc : ShowBlogVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.showTextLabel.textColor = UIColor.label
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(_ object:[String:Any]){
        
        let text = object["content"] as? String
        
        let content = text?.htmlAttributedString ?? ""
        
        if let data = content.data(using: .utf8) {
            do {
                let attributedString = try NSMutableAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                
                attributedString.addAttribute(
                    .font,
                    value: UIFont.systemFont(ofSize: 14),
                    range: NSRange(0..<attributedString.length))
                
                let textWithWidth = attributedString
                    .attributedStringWithResizedImages(with: self.frame.width)
                
                showTextLabel.attributedText = textWithWidth
            } catch  {
                Logger.error(error)
            }
        }
    }
    
}

extension NSAttributedString {
    
    func attributedStringWithResizedImages(with maxWidth: CGFloat) -> NSAttributedString {
        let text = NSMutableAttributedString(attributedString: self)
        text.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, text.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                if image.size.width > maxWidth {
                    let newImage = image.resizeImage(scale: maxWidth/image.size.width)
                    let newAttribut = NSTextAttachment()
                    newAttribut.image = newImage
                    text.addAttribute(NSAttributedString.Key.attachment, value: newAttribut, range: range)
                }
            }
        })
        return text
    }
}

extension UIImage {
    
    func resizeImage(scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)

        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
