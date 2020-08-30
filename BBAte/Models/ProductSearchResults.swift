//
//  ProductFetcher.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import Foundation

/// This class holds multiple pages of results for
/// a single search term.
///
/// For simplicity in dealing with tableviews it places
/// each page in its own section.
class ProductSearchResults {
    init() {
        self.pages = []
    }
    
    init(page: ProductPage) {
        self.pages = []
        self.updateWith(page: page)
    }

    private var pages: [ProductProvider]

    var showInstructions: Bool {
        return self.pages.count == 0
    }

    var showEmptyResults: Bool {
        return self.pages.count > 0 && self.pages.first?.count == 0
    }

    var sectionCount: Int {
        if self.showInstructions {
            return 1
        }
        return self.pages.count
    }

    func reset() {
        self.pages = []
    }
    
    func numberOfProductsInSection(_ section: Int) -> Int {
        if self.showInstructions || self.showEmptyResults {
            return 1
        }

        return self.pages[section].count
    }

    func sectionForPage(_ page: ProductPage) -> Int {
        return page.currentPage - 1
    }

    func isPageLoadedForSection(_ section: Int) -> Bool {
        return self.pages[section].loaded
    }

    func updateWith(page: ProductPage) {
        let index = pages.firstIndex { (pg) -> Bool in
            pg.currentPage == page.currentPage
        }

        if page.currentPage == 1 {
            if page.totalPages > 1 {
                pages = [page] + (1..<page.totalPages).map { ProductPageFault(currentPage: $0 + 1, totalPages: page.totalPages)}
            }
            else {
                pages = [page]
            }
        }
        else if let index = index {
            pages.remove(at: index)
            pages.insert(page, at: index)
        }
        else {
            assertionFailure("Unexpected page addition.")
        }
    }

    /// Returns a product if the page has been loaded, returns nil otherwise.
    func productAtIndexPath(_ indexPath: IndexPath) -> Product? {
        let page = pages[indexPath.section]

        if page.loaded {
            return page.products[indexPath.row]
        }
        return nil
    }
}
