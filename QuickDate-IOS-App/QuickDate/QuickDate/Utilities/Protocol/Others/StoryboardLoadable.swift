//
//  StoryboardLoadable.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 18.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

public protocol StoryboardLoadable {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardLoadable where Self: UIViewController {
    
    public static var storyboardName: String {
        return String(describing: self)
    }

    public static var storyboardIdentifier: String {
        return String(describing: self)
    }

    public static func instantiate(fromStoryboardNamed name: StoryboardName? = nil) -> Self {
        let storyboardName = name?.rawValue ?? self.storyboardName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return instantiate(fromStoryboard: storyboard)
    }

    public static func instantiate(fromStoryboard storyboard: UIStoryboard) -> Self {
        let identifier = self.storyboardIdentifier
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            var message = "Failed to instantiate view controller with identifier=\(identifier) from"
            message += " storyboard \( storyboard )"
            fatalError(message)
        }
        return viewController
    }
    
    public static func initial(fromStoryboardNamed name: StoryboardName? = nil) -> Self {
        let storyboardName = name?.rawValue ?? self.storyboardName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return initial(fromStoryboard: storyboard)
    }

    public static func initial(fromStoryboard storyboard: UIStoryboard) -> Self {
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Failed to instantiate initial view controller from storyboard named \( storyboard )")
        }
        return viewController
    }
}

extension StoryboardLoadable {
    
    typealias StoryboardInfo = (storyboard: UIStoryboard, identifier: String)
    
    static func getStoryboard(fromStoryboardNamed name: StoryboardName? = nil) -> StoryboardInfo {
        let identifier = self.storyboardIdentifier
        let storyboardName = name?.rawValue ?? self.storyboardName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return (storyboard, identifier)
    }
    
    public static func getController(
        fromStoryboardNamed name: String? = nil,
        completion: @escaping(UIViewController, NSCoder) -> UIViewController) -> UIViewController {
        
        let identifier = self.storyboardIdentifier
        let storyboardName = name ?? self.storyboardName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        var vcCoder = NSCoder()
        let viewController = storyboard.instantiateViewController(identifier: identifier) { coder in
            vcCoder = coder
            return UIViewController()
        }
        return completion(viewController, vcCoder)
    }
    
}

extension UIViewController: StoryboardLoadable {}
