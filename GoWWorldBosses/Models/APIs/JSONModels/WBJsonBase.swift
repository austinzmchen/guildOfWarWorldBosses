//
//  WBJsonBase.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonBase: Mappable {
    var id: Int64? // currency id
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
    }
}
