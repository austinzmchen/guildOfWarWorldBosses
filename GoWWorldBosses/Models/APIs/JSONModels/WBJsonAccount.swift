//
//  WBJsonAccount.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonAccount: Mappable, WBRemoteRecordSyncableType {
    var id: String = ""
    var name: String?
    var world: Int?
//    var created: Date?
    var access: String?
    var commander: Bool?
    var fractalLevel: Int?
    var daily_ap: Int?
    var monthly_ap: Int?
    var wvw_rank: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
        name <- map["name"]
        world <- map["world"]
        access <- map["access"]
        commander <- map["commander"]
        fractalLevel <- map["fractalLevel"]
        daily_ap <- map["daily_ap"]
        monthly_ap <- map["monthly_ap"]
        wvw_rank <- map["wvw_rank"]
    }
}
