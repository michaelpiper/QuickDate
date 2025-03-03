//
//  QuickdateFooterView.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Async

class MatchingCardFooterView: UIView {
    
    
    private var label = UILabel()
    private var subLabel = UILabel()
    
    private let statusView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        background.layer.cornerRadius = 5
        background.backgroundColor = .systemGreen
        return background
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.spacing = 5
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_check_verify_circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    init(withTitle title: String?, subtitle: UserProfileSettings) {
        super.init(frame: CGRect.zero)
        backgroundColor = Theme.primaryBackgroundColor.colour
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 20
        clipsToBounds = true
        isOpaque = false
        initialize(title: title, subtitle: subtitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func initialize(title: String?, subtitle: UserProfileSettings) {
        if subtitle.coordinate.latitude == "0" {
            let subAttributedText = NSMutableAttributedString(string: subtitle.country_txt,
                                                              attributes: NSAttributedString.Key.subtitleAttributes)
            self.subLabel.numberOfLines = 1
            self.subLabel.attributedText = subAttributedText
            self.layoutSubviews()
            self.layoutIfNeeded()
        }else {
            GetMapAddress.getAddress(selectedLat: (Double(subtitle.coordinate.latitude) ?? 0), selectedLon: (Double(subtitle.coordinate.longitude) ?? 0)) { stAddress in
                let subAttributedText = NSMutableAttributedString(string: stAddress ?? "",
                                                                  attributes: NSAttributedString.Key.subtitleAttributes)
                self.subLabel.numberOfLines = 1
                self.subLabel.attributedText = subAttributedText
                self.layoutSubviews()
                self.layoutIfNeeded()
            }
        }
        
        let attributedText = NSMutableAttributedString(string: (title ?? ""),
                                                       attributes: NSAttributedString.Key.titleAttributes)
        label.numberOfLines = 1
        label.attributedText = attributedText
        addSubview(label)
        addSubview(subLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(statusView)
        
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        statusView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        statusView.widthAnchor.constraint(equalToConstant: 10).isActive = true
                
        stackView.frame.size.width = 35
        stackView.frame.size.height = 20
        
        imageView.isHidden = !subtitle.verified
        statusView.isHidden = !subtitle.online
        
        /*LocationManager.shared.fetchLocation(with: subtitle.coordinate) {  [self] (response: Result<String, LocationManager.LocationError>) in
            switch response {
            case .failure(let error):
                Logger.error(error)
            case .success(let subtitle):
                if !subtitle.isEmpty {
                    let subAttributedText = NSMutableAttributedString(string: subtitle,
                                                                      attributes: NSAttributedString.Key.subtitleAttributes)
                    subLabel.numberOfLines = 1
                    subLabel.attributedText = subAttributedText
                    self.layoutSubviews()
                    self.layoutIfNeeded()
                }
            }
        }*/
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 16
        print("label.intrinsicContentSize.height", label.intrinsicContentSize, subLabel.intrinsicContentSize)
        let width = label.intrinsicContentSize.width < (bounds.width-((padding*2)+45)) ? label.intrinsicContentSize.width : (bounds.width-((padding*2)+30))
        let subWidth = subLabel.intrinsicContentSize.width < (bounds.width-(padding*2)) ? subLabel.intrinsicContentSize.width : (bounds.width-(padding*2))
        label.frame = CGRect(x: padding,
                             y: (bounds.height/2) - 22 - (padding/2),
                             width: width,
                             height: label.intrinsicContentSize.height)
        subLabel.frame = CGRect(x: padding,
                                y: label.frame.maxY + 7,
                                width: subWidth,
                                height: 22)
        stackView.frame.origin.x = label.frame.maxX + 5
        stackView.frame.origin.y = (bounds.height/2) - 20 - (padding/2)
    }
}

extension NSAttributedString.Key {
    
    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        return shadow
    }()
    
    static var titleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: Typography.semiBoldTitle(size: 18).font,
        NSAttributedString.Key.foregroundColor: Theme.primaryTextColor.colour,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]

    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: Typography.regularText(size: 14).font,
        NSAttributedString.Key.foregroundColor: Theme.secondaryTextColor.colour,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
}
