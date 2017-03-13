//
//  WBJsonItemAttribute.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonItemAttribute: Mappable {
    var attribute: String?
    var modifier: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        attribute <- map["attribute"]
        modifier <- map["modifier"]
    }
}
