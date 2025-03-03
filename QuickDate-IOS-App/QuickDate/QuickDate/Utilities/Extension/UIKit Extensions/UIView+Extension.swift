//
//  UIView+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.01.2022.
//  Copyright © 2022 Lê Việt Cường. All rights reserved.
//

import UIKit
import Toast

extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi)
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

public extension UIView {
    
    /// SwifterSwift: Shake directions of a view.
    ///
    /// - horizontal: Shake left and right.
    /// - vertical: Shake up and down.
    enum ShakeDirection {
        /// Shake left and right.
        case horizontal
        
        /// Shake up and down.
        case vertical
    }
    
    /// SwifterSwift: Shake animations types.
    ///
    /// - linear: linear animation.
    /// - easeIn: easeIn animation.
    /// - easeOut: easeOut animation.
    /// - easeInOut: easeInOut animation.
    enum ShakeAnimationType {
        /// linear animation.
        case linear
        
        /// easeIn animation.
        case easeIn
        
        /// easeOut animation.
        case easeOut
        
        /// easeInOut animation.
        case easeInOut
    }
    
    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
    
    /// SwifterSwift: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func setBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
    
    func setBlurEffect(style: UIBlurEffect.Style) {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
    func setShadow(scale: Bool = true, color: UIColor, offSet: CGSize, opacity: Float, radius: CGFloat) {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.opacity = opacity
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    enum GradientDirection {
        case horizontal
        case vertical
    }
    
    /// handle orientation you have to remove and reinstall layer
    func removeGradientLayer() {
        if let sublayers = layer.sublayers {
            for subLayer in sublayers {
                if subLayer is CAGradientLayer {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, direction: GradientDirection) {
        if let sublayers = layer.sublayers {
            for subLayer in sublayers {
                if subLayer is CAGradientLayer {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        let isHorizontal = direction == .horizontal
        gradientLayer.startPoint = isHorizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = isHorizontal ? CGPoint(x: 1.2, y: 0.5) : CGPoint(x: 1, y: 0)
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func circleView() {
        clipsToBounds = true
        if frame.size.width == frame.size.height {
            layer.cornerRadius = frame.size.width / 2
        } else {
            layer.cornerRadius = frame.size.height / 2
        }
    }
    
    // Add line to view
    func addLine(color: UIColor, width: CGFloat) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        layer.addSublayer(bottomLine)
    }
    
    // create half circle purple background
    func halfCircleView() {
        
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: bounds.size.width / 2, y: 0), radius: bounds.size.height, startAngle: 0.0, endAngle: .pi, clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        layer.mask = circleShape
        
        setGradientBackground(startColor: Theme.primaryStartColor.colour,
                              endColor: Theme.primaryEndColor.colour,
                              direction: .horizontal)
        
    }
    // show error toast
    func showError(error: String) {
        self.makeToast(error, duration: 2, position: CSToastPositionBottom)
    }
    
    func applyShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize,
                     color: UIColor = .black) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
        }
        if width > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if height > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        anchors.forEach { $0.isActive = true }
        
        return anchors
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                isActive: Bool = true) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = isActive
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = isActive
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = isActive
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = isActive
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = isActive
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = isActive
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil, isActive: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = isActive
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = isActive
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = isActive
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = isActive
        }
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil,
                 bottomAnchor: NSLayoutYAxisAnchor? = nil,
                 paddingTop: CGFloat? = 0,
                 paddingBottom: CGFloat? = 0,
                 width: CGFloat? = nil,
                 height: CGFloat? = nil,
                 isActive: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = isActive
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = isActive
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom!).isActive = isActive
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = isActive
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = isActive
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 rightAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0,
                 paddingRight: CGFloat = 0, constant: CGFloat = 0,
                 isActive: Bool = true) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = isActive
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
        
        if let right = rightAnchor {
            anchor(right: right, paddingRight: paddingRight)
        }
        
    }
    
    func setDimensions(height: CGFloat, width: CGFloat, isActive: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = isActive
        widthAnchor.constraint(equalToConstant: width).isActive = isActive
    }
    
    func setHeight(_ height: CGFloat, isActive: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = isActive
    }
    
    func setWidth(_ width: CGFloat, isActive: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = isActive
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func fillSuperViewSafeArea(padding: CGFloat = 0, isActive: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.safeAreaLayoutGuide.topAnchor,
               left: view.safeAreaLayoutGuide.leftAnchor,
               bottom: view.safeAreaLayoutGuide.bottomAnchor,
               right: view.safeAreaLayoutGuide.rightAnchor,
               paddingTop: padding, paddingLeft: padding,
               paddingBottom: padding, paddingRight: padding,
               isActive: isActive)
    }
    
    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor,
                      left: superview?.leftAnchor,
                      bottom: superview?.bottomAnchor,
                      right: superview?.rightAnchor)
    }
    
    // MARK: Animation
    // execute animation for related view
    func setSizeAnimation(scaleXY sxy: CGFloat, duration: TimeInterval) {
        // animation of zooming / popping
        UIView.animate(withDuration: duration) {
            // scale by 30% -> 1.3
            self.transform = CGAffineTransform(scaleX: sxy, y: sxy)
        } completion: { _ in
            // return the initial state
            UIView.animate(withDuration: duration) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func setRoundCornersBY(corners : CACornerMask , cornerRaduis : CGFloat = 15) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRaduis
        self.layer.maskedCorners = corners
    }

    func addShadow(offset: CGSize = .zero, color: UIColor = .lightGray, radius: CGFloat = 2.0, opacity: Float = 0.25) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = self.cornerRadiusV
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension UIView {

    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true

    }
}


func topCorner(bgView:UIView, maskToBounds: Bool, cornerRadius: CGFloat = 40) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
    bgView.layer.shadowRadius = 2
    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = cornerRadius
    bgView.layer.masksToBounds = maskToBounds
}

func topCornerWithShadow(bgView:UIView, maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    bgView.layer.shadowOffset = CGSize(width: 0, height: -10);
    bgView.layer.shadowOpacity = 0.5;
    bgView.layer.shadowRadius = 5;
    bgView.layer.shadowColor = UIColor.red.cgColor
    bgView.layer.cornerRadius =  25
    bgView.layer.masksToBounds = maskToBounds
}

func topCorners(bgView:UIView, cornerRadius: CGFloat ,maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    //    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
    //    bgView.layer.shadowRadius = 2
    //    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = cornerRadius
    bgView.layer.masksToBounds = maskToBounds
}

extension UIViewController  {
    func showAlert(title: String? = nil, message: String, textAlignment: NSTextAlignment = .center) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        if let messageLabel = alertController.view.value(forKeyPath: "_messageLabel") as? UILabel {
            messageLabel.textAlignment = textAlignment
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
