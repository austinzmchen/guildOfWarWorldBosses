//
//  WBStorageBankViewModel.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBStorageBankViewModel: WBStorageTableViewModelType {
    weak var delegate: WBStorageTableViewModelDelegate?
    var items: [WBObject]?
    
    init() {
        let realm = try! Realm()
        
        // Query
        let results = realm.objects(WBBankElement.self)
        self.items = Array(results)
        
        bankProcessor?.sync(completion: { (success, syncedObjects, error) in
            self.delegate?.didComplete(success: success, items: syncedObjects, error: error)
        })
    }
    
    // MARK: instance methods
    
    var bankProcessor: WBBankProcessor? {
        let syncCoord = appDelegate.appConfiguration[kAppConfigurationSyncCoordinator] as? WBSyncCoordinator
        return syncCoord?.bankProcessor
    }
}
