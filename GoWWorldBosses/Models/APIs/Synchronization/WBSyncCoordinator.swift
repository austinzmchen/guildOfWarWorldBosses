//
//  WBSyncCoordinator.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import RealmSwift

let WBSyncAllCompletedNotification = "kWBSyncAllCompletedNotification"

class WBSyncCoordinator: NSObject {
    
    var syncContext: WBSyncContext = WBSyncContext()
    fileprivate var observerTokens: [NSObjectProtocol] = [] //< The tokens registered with NSNotificationCenter
    
    // MARK - life cycle methods
    
    init(remoteSession: WBRemoteSession) {
        super.init()
        
        self.syncContext = WBSyncContext(remoteSession: remoteSession)
    }
    
    // MARK - instance methods
    
    lazy var walletProcessor: WBWalletProcessor = {
        return WBWalletProcessor(context: self.syncContext)
    }()
    
    func syncAll(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        self.walletProcessor.sync { (success, syncedObjects, error) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: WBSyncAllCompletedNotification), object: nil)
        }
    }
}
