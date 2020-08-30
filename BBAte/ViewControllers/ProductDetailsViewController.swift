//
//  ProductDetailsViewController.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/30/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    var product: Product? = nil

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var skuLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var ratingView: RatingView!
    @IBOutlet var ratingCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.imageView.layer.cornerRadius = 10
        
        let nf = NumberFormatter()
        nf.currencySymbol = "$"
        nf.currencyGroupingSeparator = ","
        nf.numberStyle = .currency

        guard let product = product else { return }
        self.imageView.setImage(with: product.imageUrl)
        self.skuLabel.text = "sku# \(product.sku)"
        self.nameLabel.text = product.name
        self.descriptionLabel.text = product.description
        self.priceLabel.text =  nf.string(for: product.price)
        self.ratingView.rating = product.rating ?? 0
        self.ratingCountLabel.text = "(\(product.ratingCount ?? 0))"
    }

    @IBAction func openBrowser(_ sender: UIButton) {
        guard let url = product?.url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
