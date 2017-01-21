//
//  WBJsonCharacter.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WBJsonCharacter: Mappable, WBRemoteRecordSyncableType {
    var id: String = ""
    var name: String?
    var race: String?
    var gender: String?
    var profession: String?
    var level: Int?
    var age: Int?
    var death: Int?
    var created: Date?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id = name ?? "" // use name as id
        
        race <- map["race"]
        gender <- map["gender"]
        profession <- map["profession"]
        level <- map["level"]
        age <- map["age"]
        death <- map["death"]
        created <- map["created"]
    }
}

extension WBJsonCharacter: Equatable {
    static func ==(lhs: WBJsonCharacter, rhs: WBJsonCharacter) -> Bool {
        return lhs.id == rhs.id
    }
}
