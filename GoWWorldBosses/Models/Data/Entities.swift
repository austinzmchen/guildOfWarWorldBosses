//
//  Entities.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBCurrency: Object {
    dynamic var id: Int64 = -1
    dynamic var name = ""
    dynamic var descriptionText = ""
    dynamic var icon = ""
    dynamic var order = 0
}

class WBBankItem: Object {
    dynamic var id: Int64 = -1
    dynamic var name = ""
    dynamic var descriptionText = ""
    dynamic var icon = ""
    dynamic var type = ""
    dynamic var level = 0
}
