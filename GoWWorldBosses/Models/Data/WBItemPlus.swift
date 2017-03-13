//
//  WBItemPlus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension WBItem {
    var details: WBJsonItemBaseDetail? {
        if let v = _details,
            let jsonString = String(data: v as Data, encoding: String.Encoding.utf8)
        {
            switch self.type1 {
            case .armor:
                return WBJsonItemArmorDetail(JSONString: jsonString)
            case .weapon:
                return WBJsonItemWeaponDetail(JSONString: jsonString)
            default:
                return nil
            }
        }
        return nil
    }
    
    var adjustedFlags: [String] {
        if let f = self.flags {
            let array = f.components(separatedBy: ",")
            return array.filter { arrayItem in
                return kAdjustedFlags.contains { flag in
                    return flag ~= arrayItem
                }
            }
        }
        return []
    }
}

fileprivate let kAdjustedFlags = ["AccountBindOnUse", "AccountBound", "SoulbindOnAcquire", "SoulBindOnUse"]
