//
//  WBTripRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//

import Foundation
import Alamofire

protocol WBBankRemoteType {
    func fetchBanks(completion: @escaping (_ result: WBRemoteResult<[WBJsonBankElement]?>) -> ())
}

class WBBankRemote: WBRemote, WBBankRemoteType {
    
    func fetchBanks(completion: @escaping (_ result: WBRemoteResult<[WBJsonBankElement]?>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/account/bank", headers: self.remoteSession?.headers)
        request.responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess,
                let elements = response.result.value as? [AnyObject]
            {
                var resultElements: [WBJsonBankElement] = []
                for e in elements {
                    if !(e is NSNull),
                        let ej = e as? [String : Any],
                        let bankElement = WBJsonBankElement(JSON: ej)
                    {
                        if resultElements.contains(bankElement) {
                            let firstOccuranceIndex = resultElements.index(of: bankElement)
                            guard let fi = firstOccuranceIndex,
                                let oc = resultElements[fi].count,
                                let nc = bankElement.count else {
                                return
                            }
                            
                            resultElements[fi].count = oc + nc
                        } else {
                            resultElements.append(bankElement)
                        }
                    }
                }
                completion(WBRemoteResult.success(.some(resultElements)))
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
