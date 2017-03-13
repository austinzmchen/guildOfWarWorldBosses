//
//  WBJsonItem.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonItem: WBJsonBase, WBItemTypeProtocol {
    var name: String?
    var descriptionText: String?
    var icon: String?
    var type: String?
    var level: Int?
    var rarity: String?
    var flags: [String]?
    var vendorValue: Int?
    var details: WBJsonItemBaseDetail?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        descriptionText <- map["description"]
        type <- map["type"]
        icon <- map["icon"]
        level <- map["order"]
        rarity <- map["rarity"]
        flags <- map["flags"]
        vendorValue <- map["vendor_value"]
        
        switch self.type1 {
        case .armor:
            var d: WBJsonItemArmorDetail?
            d <- map["details"]
            details = d
        case .weapon:
            var d: WBJsonItemWeaponDetail?
            d <- map["details"]
            details = d
        default:
            details <- map["details"]
        }
    }
}
