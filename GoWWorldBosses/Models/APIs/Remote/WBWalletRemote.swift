//
//  WBWalletRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol WBWalletRemoteType {
    func fetchWalletElements(_ completion: @escaping (_ result: WBRemoteResult<[WBJsonWalletElement]?>) -> ())
    func fetchCurrencies(byIds ids: [String], completion: @escaping (_ result: WBRemoteResult<[WBJsonCurrency]?>) -> ())
}

class WBWalletRemote: WBRemote, WBWalletRemoteType {
    
    func fetchWalletElements(_ completion: @escaping (_ result: WBRemoteResult<[WBJsonWalletElement]?>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/account/wallet", headers: self.remoteSession?.headers)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonWalletElement]>) in
            if response.result.isSuccess {
                var items: [WBJsonWalletElement]? = response.result.value
                items?.uniqueInPlace()
                let result = WBRemoteResult.success(items)
                completion(result)
            } else {
                if response.response?.statusCode == 403 {
                    completion(WBRemoteResult.failure(WBRemoteError.scopePermissionDenied))
                } else {
                    completion(WBRemoteResult.failure(response.result.error ?? WBRemoteError.unknown))
                }
            }
        }
    }
    
    func fetchCurrencies(byIds ids: [String], completion: @escaping (_ result: WBRemoteResult<[WBJsonCurrency]?>) -> ()) {
        
        let idsString = ids.map{ $0 }.joined(separator: ",")
        let parameters = "?ids=\(idsString)"
        
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/currencies" + parameters, headers: self.remoteSession?.headers)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonCurrency]>) in
            if response.result.isSuccess {
                let result = WBRemoteResult.success(response.result.value)
                completion(result)
            } else {
                if response.response?.statusCode == 403 {
                    completion(WBRemoteResult.failure(WBRemoteError.scopePermissionDenied))
                } else {
                    completion(WBRemoteResult.failure(response.result.error ?? WBRemoteError.unknown))
                }
            }
        }
    }
}
