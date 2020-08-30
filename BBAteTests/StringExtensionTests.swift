//
//  StringExtensionTests.swift
//  BBAteTests
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import XCTest
@testable import BBAte

class StringExtensionTests: XCTestCase {

    func testBasicSplit() throws {
        let split = "samsung tv hdmi".tokenize()

        assert(split.count == 3)
        assert(split == ["samsung", "tv", "hdmi"])
    }

    func testRemoveShortTokens() throws {
        let split = "I want a TV".tokenize()

        assert(split == ["want", "TV"])
    }

    func testSkipExtendedWhitespace() throws {
        let split = "I    am\ncool  \n".tokenize()

        assert(split == ["am", "cool"])
    }
}
