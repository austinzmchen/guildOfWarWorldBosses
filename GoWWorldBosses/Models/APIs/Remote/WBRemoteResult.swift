//
//  WBRemoteResult.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-29.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

enum WBRemoteResult<Value> {
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

enum WBRemoteError: Error {
    case unknown
    case scopePermissionDenied
}

extension WBRemoteError {
    public var errorDescription: String? {
        switch self {
        case .scopePermissionDenied:
            return "scopePermissionDenied"
        default:
            return "unknown"
        }
    }
}
