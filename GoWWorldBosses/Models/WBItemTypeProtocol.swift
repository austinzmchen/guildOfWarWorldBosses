//
//  WBItemTypeProtocol.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

protocol WBItemTypeProtocol {
    var type: String? {get}
}

extension WBItemTypeProtocol {
    var type1: WBItemType {
        if self.type ~= "armor" {
            return WBItemType.armor
        } else if self.type ~= "weapon" {
            return WBItemType.weapon
        } else {
            return WBItemType.others
        }
    }
}

enum WBItemType {
    case armor
    case weapon
    case others
    
    var isArmor: Bool {
        switch self {
        case .armor:
            return true
        default:
            return false
        }
    }
    
    var isWeapon: Bool {
        switch self {
        case .weapon:
            return true
        default:
            return false
        }
    }
}

