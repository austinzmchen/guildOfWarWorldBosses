//
//  WBJsonItemArmorDetail.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonItemArmorDetail: WBJsonItemBaseDetail {
    var weightClass: String?
    var defense: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        weightClass <- map["weight_class"]
        defense <- map["defense"]
    }
}
