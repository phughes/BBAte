//
//  String+Extensions.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import Foundation

public extension String {

    /// Returns an array of Strings where each element is at least 2 charaters.
    func tokenize() -> [String] {
        return self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .compactMap { (s) -> String? in
                if s.count > 1 {
                    return String(s)
                }
                return nil
        }
    }
}
