//
//  QuickdateOverLay.swift
//  QuickDate
//
//
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Shuffle_iOS
import UIKit

class MatchingCardOverlay: UIView {
    
    private var imageWidth: CGFloat = 150
    
    init(direction: SwipeDirection) {
        super.init(frame: .zero)
        self.backgroundColor = direction == .left
        ? "685DF6".toUIColor().withAlphaComponent(0.8)
        : "F54236".toUIColor().withAlphaComponent(0.8)
        
        switch direction {
        case .left:
            createLeftOverlay()
        case .up:
            createUpOverlay()
        case .right:
            createRightOverlay()
        default:
            break
        }
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func createLeftOverlay() {
        let leftTextView = MatchingCardOverlayImageView(with: "multiply", title: "Dislike", color: .white)
        addSubview(leftTextView)
        leftTextView.center(inView: self, width: imageWidth, height: imageWidth)
    }
    
    private func createUpOverlay() {
        let upTextView = MatchingCardOverlayImageView(with: "heart.fill", title: "Super Like", color: .white)
        addSubview(upTextView)
        upTextView.anchor(bottom: bottomAnchor, paddingBottom: 20, width: imageWidth, height: imageWidth)
        upTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func createRightOverlay() {
        let rightTextView = MatchingCardOverlayImageView(with: "heart.fill", title: "Like", color: .white)
        addSubview(rightTextView)
        rightTextView.center(inView: self, width: imageWidth, height: imageWidth)
    }
}

private class MatchingCardOverlayImageView: UIView {
    
    private let actionImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private let actionLabel: UILabel = {
        $0.font = Typography.semiBoldTitle(size: 20).font
        $0.textColor = .white
        return $0
    }(UILabel())
    
    init(with imageName: String, title: String, color: UIColor) {
        super.init(frame: CGRect.zero)
        actionLabel.text = title
        
        addSubview(actionImageView)
        actionImageView.tintColor = color
        actionImageView.image = UIImage(systemName: imageName)
        actionImageView.center(inView: self, width: 100, height: 100)
        
        addSubview(actionLabel)
        actionLabel.centerX(inView: actionImageView, topAnchor: actionImageView.bottomAnchor,
                            paddingTop: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension UIColor {
  fileprivate static var sampleRed = UIColor(red: 252 / 255, green: 70 / 255, blue: 93 / 255, alpha: 1)
  fileprivate static var sampleGreen = UIColor(red: 49 / 255, green: 193 / 255, blue: 109 / 255, alpha: 1)
  fileprivate static var sampleBlue = UIColor(red: 52 / 255, green: 154 / 255, blue: 254 / 255, alpha: 1)
}
