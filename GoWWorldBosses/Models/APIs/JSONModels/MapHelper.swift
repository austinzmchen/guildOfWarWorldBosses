//
//  MapHelper.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-01.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper

final class MapHelper<T> {
    
    let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func mapArrayOfOptionals(field: String) -> [T?] {
        if let values = map[field].value() as [AnyObject]? {
            var resultValues = [T?]()
            for value in values {
                if value is NSNull {
                    resultValues.append(nil)
                } else {
                    resultValues.append(value as? T)
                }
            }
            
            return resultValues
        }
        return []
    }
    
}


final class MapHelper2 {
    
    static func mapArrayWithNullElements<S: Mappable>(elements: [AnyObject]) -> [S] {
        var resultValues = [S]()
        for value in elements {
            if !(value is NSNull),
                let v = value as? S
            {
                resultValues.append(v)
            }
        }
        return resultValues
    }
}
