//
//  StringPlus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-07.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

// roughly equal to
func ~= (lhs: String?, rhs: String?) -> Bool {
    guard var l = lhs,
        var r = rhs else { return false } // false if either one is nil
    
    l = l.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    r = r.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return l.lowercased() == r.lowercased()
}
