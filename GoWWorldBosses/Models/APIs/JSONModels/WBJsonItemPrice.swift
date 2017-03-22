//
//  WBJsonCurrency.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonItemPrice: WBJsonBase {
    var whitelisted: Bool?
    var buysQuantity: Int64?
    var buysUnitPrice: Int?
    var sellsQuantity: Int64?
    var sellsUnitPrice: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        whitelisted <- map["whitelisted"]
        buysQuantity <- map["buys.quantity"]
        buysUnitPrice <- map["buys.unit_price"]
        sellsQuantity <- map["sells.quantity"]
        sellsUnitPrice <- map["sells.unit_price"]
    }
}

