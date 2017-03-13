//
//  WBJsonItemBaseDetail.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonItemBaseDetail: Mappable {
    var type: String?
    var infusionSlots: [String] = []
    var infixUpgradeAttributes: [WBJsonItemAttribute] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        type <- map["type"]
        infixUpgradeAttributes <- map["infix_upgrade.attributes"]
    }
}

extension Array where Element: WBJsonItemAttribute {
    var toWBTextViewText: String {
        return self.filter {
            $0.attribute != nil
        }.map {
            return "+\($0.modifier ?? 0) \($0.attribute!)"
        }.joined(separator: "\n")
    }
}
