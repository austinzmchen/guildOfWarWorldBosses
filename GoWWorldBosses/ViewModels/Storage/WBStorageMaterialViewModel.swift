//
//  WBStorageMaterialViewModel.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBStorageMaterialViewModel: WBStorageTableViewModelType {
    weak var delegate: WBStorageTableViewModelDelegate?
    var items: [WBObject]?
    
    init() {
        let realm = try! Realm()
        
        // Query
        let results = realm.objects(WBMaterialElement.self)
        self.items = Array(results)
    }
    
    func itemsCount() -> Int {
        return self.items?.count ?? 0
    }
    
    func mainTitleForItem(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBMaterialElement,
            let bankItem = item.item
        {
            return bankItem.name ?? ""
        } else {
            return ""
        }
    }
    
    func subTitleForItem(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBMaterialElement
        {
            return String(format: "%d", item.count)
        } else {
            return ""
        }
    }
    
    func imageUrlStringForItem(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBMaterialElement,
            let currency = item.item
        {
            return currency.icon ?? ""
        } else {
            return ""
        }
    }
}
