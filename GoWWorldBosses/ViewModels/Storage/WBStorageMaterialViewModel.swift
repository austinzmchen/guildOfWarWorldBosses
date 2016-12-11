//
//  WBStorageMaterialViewModel.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBStorageMaterialViewModel {
    weak var delegate: WBStorageTableViewModelDelegate?
    var items: [WBObject]?
    
    init() {
//        let realm = try! Realm()
//        
//        // Query
//        let results = realm.objects(WBWalletElement.self)
//        self.items = Array(results)
    }
}
