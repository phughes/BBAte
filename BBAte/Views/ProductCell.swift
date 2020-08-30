//
//  ProductTableViewCell.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var ratingView: RatingView!
}
