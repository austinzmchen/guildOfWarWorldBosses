//
//  WBStorageWalletViewModel.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

class WBStorageWalletViewModel: WBStorageTableViewModelType {
    weak var delegate: WBStorageTableViewModelDelegate?
    
    var items: [WBObject]?
    
    init() {
        let realm = try! Realm()
        
        // Query
        let results = realm.objects(WBWalletElement.self)
        self.items = Array(results)
        
        walletProcessor?.sync(completion: { (success, syncedObjects, error) in
            self.delegate?.didComplete(success: success, items: syncedObjects, error: error)
        })
    }
    
    // MARK: instance methods 
    
    var walletProcessor: WBWalletProcessor? {
        let syncCoord = appDelegate.appConfiguration[kAppConfigurationSyncCoordinator] as? WBSyncCoordinator
        return syncCoord?.walletProcessor
    }
    
    // MARK: interface impl
    
    func identifierForSuitableCell(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBWalletElement,
            let currency = item.currency,
            currency.name?.lowercased() == "coin"
        {
            return "walletCoinTableCell"
        }
        return "storageItemTableCell"
    }
    
    func itemsCount() -> Int {
        return self.items?.count ?? 0
    }
    
    func mainTitleForItem(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBWalletElement,
            let currency = item.currency
        {
            return currency.name ?? ""
        } else {
            return ""
        }
    }
    
    func subTitleForItem(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBWalletElement
        {
            return String(format: "%d", item.value)
        } else {
            return ""
        }
    }
    
    func imageUrlStringForItem(atIndex index: Int) -> String {
        if let item = self.items?[index] as? WBWalletElement,
            let currency = item.currency
        {
            return currency.icon ?? ""
        } else {
            return ""
        }
    }
    
    
    // FIXME: to be removed
    
    func coinValueForItem(atIndex index: Int) -> Int
    {
        if let item = self.items?[index] as? WBWalletElement,
            let currency = item.currency,
            currency.name?.lowercased() == "coin"
        {
            return item.value
        }
        return -1
    }
}
