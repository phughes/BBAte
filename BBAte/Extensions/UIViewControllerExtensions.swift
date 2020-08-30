//
//  UIViewControllerExtensions.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

extension UIViewController {

    /// A convenience for loading view controllers from storyboards.
    static func fromStoryboard<T: UIViewController>() -> T {
        let name =  String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: nil)

        return storyboard.instantiateViewController(withIdentifier: name) as! T
    }

    func embedInNavigationController<T: UIViewController>() -> (T, UINavigationController) {
        let nav = UINavigationController(rootViewController: self)
        return (self as! T, nav)
    }
}
