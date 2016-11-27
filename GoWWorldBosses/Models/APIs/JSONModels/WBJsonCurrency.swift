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

class WBJsonWallet: WBJsonBase {
    var value: Int64? // The amount of this currency.
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    
        value <- map["value"]
    }
}

class WBJsonCurrency: WBJsonBase {
    var name: String?
    var descriptionText: String?
    var icon: String?
    var order: Int?
    
    override func mapping(map: Map) {
        name <- map["name"]
        descriptionText <- map["description"]
        icon <- map["icon"]
        order <- map["order"]
    }
}

