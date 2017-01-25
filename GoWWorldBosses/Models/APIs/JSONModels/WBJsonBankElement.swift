//
//  WBJsonBankElement.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonBankElement: WBJsonBase {
    var count: Int?
    var binding: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        count <- map["count"]
        binding <- map["binding"]
    }
}
