//
//  ArrayPlus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

//extension Array {
//    func splitBy(chunkSize size: Int) -> Array {
//        let chunks = stride(from: 0, through: self.count, by: size).map {
//            let end = self.endIndex
//            let chunkEnd = self.index($0, offsetBy: size, limitedBy: end) ?? end
//            return Array(self[$0..<chunkEnd])
//        }
//        return chunks
//    }
//}


extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqueInPlace()
        return arrayCopy
    }
    
    mutating public func uniqueInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}
