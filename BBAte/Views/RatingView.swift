//
//  RatingView.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/30/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

class RatingView: UIView {
    @IBOutlet var container: UIView!
    @IBOutlet var containerWidthConstraint: NSLayoutConstraint!

    override func awakeAfter(using coder: NSCoder) -> Any? {
        if self.subviews.count == 0 {
            let view = RatingView.fromNib()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        return self
    }

    var rating: Float = 0 {
        didSet {
            let percent = CGFloat(rating/5.0)
            containerWidthConstraint.constant = self.frame.width * percent
        }
    }
}
