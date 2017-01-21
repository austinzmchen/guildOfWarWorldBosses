//
//  RealmPlus.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


extension Realm {
    // Insert code here to add functionality to your managed object subclass
    func insertItem<S: WBObject>(byId id: String) -> S {
        let item = S()
        item.id = id
        
        /* sometimes response item with the same id is returned
         an exception will be produce if that happens, eg @throw RLMException(@"Can't create object with existing primary key value '%@'.", primaryValue);
         */
        do {
            try self.write {
                self.add(item)
            }
        } catch let e {
            print("\(e)")
        }
            
        return item
    }

    func findFirst<T: WBObject>(withPredicate predicate: NSPredicate, onType type: T.Type) -> T? {
        let localObjects: Results<WBObject> = self.objects(WBObject.self)
            .filter(predicate)
        return localObjects.first as? T
    }
    
    
    /**
     Insert or update mechanism recommended by Apple Doc to minimize the amount of database retrieval. Note: local records not existed remotely are not removed.
     
     - parameter items:     array of PMRemoteRecordSyncable type, remote records to be synced locally
     - parameter type:      managed object entity type
     - parameter uniqueKey: managed object unique id
     
     - returns: array of HARemoteRecordChange type, with which client code can further decided to modify the properties or saving
     
     eg:
     remote: 3, 4, 7, 9, f, g, u
     
     local : 4, 9, a, g, w
     
     1. both indexes point to the beginning of each array
     2. 3 < 4, so insert and increment remoteIndex
     3. 4 == 4, so update, and increment both indexes
     4. 7 < 9, insert and increment remoteIndex
     5. 9 == 9, update and increment both indexes
     6. f > a, remove a, increment localIndex
     7. f < g, insert and increment remoteIndex
     8. g == g, update and increment both
     9. u < w, insert and increment remoteIndex
     10.still local items left, so remove and increment localIndex
     
     */
    func findOrInsert<T: WBRemoteRecordSyncableType, S: WBObject>(_ items: [T],
                      byUniqueKey uniqueKey: String = "id",
                      removeLocalItemsIfNotFoundInRemote shouldRemove: Bool = false) -> [WBRemoteRecordChange<T, S>] {
        
        let sortedRemoteRecords: [T] = items.sorted(by: { (item1: T, item2: T) -> Bool in
            let key1 = item1.id
            let key2 = item2.id
            return key1 < key2
        })
        let sortedRRIds: [String] = sortedRemoteRecords.map({$0.id})
        
        //
        let localObjects: Results<S> = self.objects(S.self)
            .filter(NSPredicate(format: "\(uniqueKey) IN %@", sortedRRIds))
            .sorted(byProperty: uniqueKey, ascending: true)
        
        var results:[WBRemoteRecordChange<T, S>] = []
        var remoteIndex = 0
        var localIndex = 0
        
        // insert, update, or remove according to eg 1 to 9
        while remoteIndex < sortedRemoteRecords.count {
            let remoteRecord = sortedRemoteRecords[remoteIndex]
            let itemKey = remoteRecord.id
            
            if (localIndex < localObjects.count) {
                guard let localItemKey = localObjects[localIndex].value(forKey: uniqueKey) as? String else {
                    print ("error: local item does not have key")
                    continue
                }
                
                if (itemKey < localItemKey) {
                    // insert
                    let insertedItem: S = self.insertItem(byId: itemKey)
                    results.append(WBRemoteRecordChange.inserted(remoteRecord, insertedItem))
                    remoteIndex += 1
                } else if (itemKey == localItemKey) {
                    // update
                    results.append(WBRemoteRecordChange.found(remoteRecord, localObjects[localIndex]))
                    remoteIndex += 1
                    localIndex += 1 // remote obj index has caught up with the local index, so increment 1
                } else {
                    // remove local
                    if (shouldRemove) {
                        self.delete(localObjects[localIndex])
                        results.append(WBRemoteRecordChange.removed)
                    }
                    localIndex += 1 // label as Remove and increment 1
                }
            } else {
                // insert - no more local object to for remote objects to compare to
                let insertedItem: S = self.insertItem(byId: itemKey)
                results.append(WBRemoteRecordChange.inserted(remoteRecord, insertedItem))
                remoteIndex += 1
            }
        }
        
        // remove according to eg 10
        while localIndex < localObjects.count {
            // remove local
            if (shouldRemove) {
                try! self.write {
                    self.delete(localObjects[localIndex])
                }
                results.append(WBRemoteRecordChange.removed)
            }
            localIndex += 1 // label as Remove and increment 1
        }
        
        return results
    }
    
    
    func removeAll<T: WBObject>(type: T.Type) throws {
        let results = self.objects(type)
        try! self.write {
            self.delete(results)
        }
    }
}
