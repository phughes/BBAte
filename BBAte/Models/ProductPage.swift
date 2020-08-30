//
//  ProductPage.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import Foundation

protocol ProductProvider {
    var currentPage: Int { get }
    var totalPages: Int { get }
    var count: Int { get }
    var loaded: Bool { get }
    var products: [Product] { get }
}

struct ProductPageFault: ProductProvider {
    let currentPage: Int
    let totalPages: Int
    let count: Int = 0
    let loaded: Bool = false
    let products: [Product] = []
}

struct ProductPage: ProductProvider, Codable {
    let currentPage: Int
    let totalPages: Int
    let loaded: Bool = true
    let products: [Product]

    var count: Int {
        return products.count
    }
}
