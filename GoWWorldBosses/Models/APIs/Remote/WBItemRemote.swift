//
//  WBItemRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

class WBItemRemote: WBRemote {
    func fetchItems(byIds ids: [String], completion: @escaping (_ result: WBRemoteResult<[WBJsonItem]?>) -> ()) {
        
        let idsString = ids.map{ $0 }.joined(separator: ",")
        let parameters = "?ids=\(idsString)"
        
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/items" + parameters, headers: self.remoteSession?.headers)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonItem]>) in
            if response.result.isSuccess {
                var items: [WBJsonItem]? = response.result.value
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
}
