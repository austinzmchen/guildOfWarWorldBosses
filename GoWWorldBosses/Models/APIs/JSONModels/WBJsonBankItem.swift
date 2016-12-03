//
//  WBJsonBankItem.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonBank: Mappable {
    var bankElements: [WBJsonBankElement?]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
         bankElements = MapHelper<WBJsonBankElement>(map: map).mapArrayOfOptionals(field: "items")
    }
}

class WBJsonBankElement: WBJsonBase {
    var count: Int?
    var binding: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        count <- map["count"]
        binding <- map["binding"]
    }
}

class WBJsonBankItem: WBJsonBase {
    var name: String?
    var descriptionText: String?
    var icon: String?
    var type: String?
    var level: Int?
    var rarity: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        descriptionText <- map["description"]
        type <- map["type"]
        icon <- map["icon"]
        level <- map["order"]
        rarity <- map["rarity"]
    }
}
