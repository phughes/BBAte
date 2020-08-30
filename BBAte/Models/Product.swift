//
//  Product.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import Foundation

struct Product: Codable {
    let name: String
    let sku: UInt
    let price: Double
    let rating: Float?
    let ratingCount: Int?
    let imageUrl: URL?
    let description: String?
    let url: URL

    enum CodingKeys: String, CodingKey {
        case name
        case sku
        case price = "salePrice"
        case rating = "customerReviewAverage"
        case ratingCount = "customerReviewCount"
        case imageUrl = "image"
        case description = "longDescription"
        case url
    }
}
