//
//  AppConfigurator.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-19.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

class AppConfigurator: NSObject {

}


let kAppConfigurationRemoteSession = "remoteSession"
let kAppConfigurationSyncCoordinator = "syncCoordinator"

typealias AppConfiguration = NSMutableDictionary // subclass dictionary would require override methods

extension AppConfiguration {
    
    var isValid: Bool {
        get {
            if let _ = self[kAppConfigurationRemoteSession] as? WBRemoteSession,
                let _ = self[kAppConfigurationSyncCoordinator] as? WBSyncCoordinator
            {
                return true
            } else {
                return false
            }
        }
    }
    
    static func appVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    static func appBuild() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    static func versionWithBuild() -> String {
        return String(format: "%@ (%@)", self.appVersion(), self.appBuild())
    }
}
