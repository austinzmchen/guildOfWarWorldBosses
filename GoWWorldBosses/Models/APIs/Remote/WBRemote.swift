//
//  WBRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//

import Foundation
import RealmSwift

protocol WBRemoteRecordSyncableType {
    var id: String { get }
}

enum WBRemoteRecordChange<T: WBRemoteRecordSyncableType, S: WBObject> {
    case found(T, S)
    case inserted(T, S)
    case removed
    
    var isInserted: Bool {
        switch self {
        case .inserted:
            return true
        default:
            return false
        }
    }
    var isFound: Bool {
        switch self {
        case .found:
            return true
        default:
            return false
        }
    }
    var isRemoved: Bool {
        switch self {
        case .removed:
            return true
        default:
            return false
        }
    }
}

import Alamofire

/* remote settings
 */
struct WBRemoteSettings {
    static let serialQueue: DispatchQueue = DispatchQueue(label: "com.ac.GoWWorldBosses.remote-serial-queue", attributes: [])
    static let concurrentQueue: DispatchQueue = DispatchQueue(label: "com.ac.GoWWorldBosses.remote-concurrent-queue", attributes: DispatchQueue.Attributes.concurrent)
}

/// All Remote subclasses fetch remote data ASYNCHRONOUSLY, so be aware the completion block is NOT executed on main thread

class WBRemote: NSObject {
    // domains
    static let domain = "api2.libre-dev.com"
    
    var alamoFireManager: SessionManager
    let remoteSession: WBRemoteSessionType?
    
    init(remoteSession: WBRemoteSession?) {
        self.remoteSession = remoteSession
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            type(of: self).domain: .disableEvaluation
        ]
        alamoFireManager = SessionManager(configuration: URLSessionConfiguration.default,
                                          serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        super.init()
    }
}

// for AlamoFire 4.0 + 

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

