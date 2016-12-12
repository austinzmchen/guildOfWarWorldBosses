//
//  WBJsonMaterialElement.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonMaterialElement: WBJsonBase {
    var category: Int?
    var count: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        category <- map["category"]
        count <- map["count"]
    }
}
