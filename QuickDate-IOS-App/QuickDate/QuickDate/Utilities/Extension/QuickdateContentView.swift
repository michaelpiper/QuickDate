//
//  QuickdateContentView.swift
//  QuickDate
//
//
//  Copyright © 2020 ScriptSun All rights reserved.
//

import Foundation

class MatchingCardContentView: UIView {
    
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        background.layer.cornerRadius = 20
        return background
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.01).cgColor,
                           UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
//    private let actionLabel: UILabel = {
//        $0.font = Typography.semiBoldTitle(size: 20).font
//        $0.textColor = .white
//        $0.text = "dsadhjdgasjdgajsdasj"
//        return $0
//    }(UILabel())
//
    init(withImage image: URL?) {
        super.init(frame: .zero)
        imageView.sd_setImage(with: image)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func initialize() {
        addSubview(backgroundView)
        backgroundView.backgroundColor = Theme.primaryBackgroundColor.colour
        backgroundView.anchorToSuperview()
        backgroundView.addSubview(imageView)
        imageView.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingBottom: 80)
        applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
        backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let heightFactor: CGFloat = 0.35
        gradientLayer.frame = CGRect(x: 0,
                                     y: (1 - heightFactor) * bounds.height,
                                     width: bounds.width,
                                     height: heightFactor * bounds.height)
    }
}
