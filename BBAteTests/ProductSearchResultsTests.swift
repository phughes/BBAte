//
//  ProductFetcherTests.swift
//  BBAteTests
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import XCTest
@testable import BBAte

class ProductSearchResultsTests: XCTestCase {
    var fetcher: ProductSearchResults!
    override func setUpWithError() throws {
        let page = try loadPage("multipage_1")
        fetcher = ProductSearchResults(page: page)
    }

    func testFetcher() throws {
        assert(fetcher.sectionCount == 2)
        assert(fetcher.numberOfProductsInSection(0) == 10)
        assert(fetcher.numberOfProductsInSection(1) == 0)

        let page2 = try loadPage("multipage_2")
        fetcher.updateWith(page: page2)
        assert(fetcher.sectionCount == 2)
        assert(fetcher.numberOfProductsInSection(0) == 10)
        assert(fetcher.numberOfProductsInSection(1) == 8)
    }

    func loadPage(_ named: String) throws -> ProductPage {
        let url = Bundle(for: ProductSearchResultsTests.self).url(forResource: named, withExtension: "json")!
        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let page = try decoder.decode(ProductPage.self, from: data)
        return page
    }

}
