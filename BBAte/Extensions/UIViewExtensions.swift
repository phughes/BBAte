//
//  UIViewExtensions.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/30/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

extension UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }

    class func fromNib<T: UIView>() -> T {
        return self.nib.instantiate(withOwner: nil, options: nil).first as! T
    }
}
