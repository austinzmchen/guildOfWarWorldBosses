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

class WBJsonBase: Mappable, WBRemoteRecordSyncableType {
    var id: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        var idInt: Int?
        idInt <- map["id"]
        
        // use String as identifier type, no matter what type it is converted from
        if let i = idInt  {
            self.id = String(format:"%ld",i)
        }
    }
}
