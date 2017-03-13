//
//  WBJsonItemWeaponDetail.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonItemWeaponDetail: WBJsonItemBaseDetail {
    var minPower: Int?
    var maxPower: Int?
    var defense: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        minPower <- map["min_power"]
        maxPower <- map["max_power"]
        defense <- map["defense"]
    }
}
