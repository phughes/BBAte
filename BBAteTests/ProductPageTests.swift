//
//  ProductPageTests.swift
//  ProductPageTests
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import XCTest
@testable import BBAte

class ProductPageTests: XCTestCase {

    func testSinglePage() throws {
        let data = try loadFile("pixel_pen_search_results")

        let decoder = JSONDecoder()
        let page = try decoder.decode(ProductPage.self, from: data)

        assert(page.currentPage == 1)
        assert(page.totalPages == 1)
        assert(page.products.count == 8)

        let product = page.products.first!
        assert(product.name == "Google - Pixelbook Pen - Midnight Blue")
        assert(product.price == 99.00)
        assert(product.sku == 6306364)
    }

    func loadFile(_ named: String) throws -> Data {
        let url = Bundle(for: ProductPageTests.self).url(forResource: named, withExtension: "json")!
        return try Data(contentsOf: url)
    }
}
