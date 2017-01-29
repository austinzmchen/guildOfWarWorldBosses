//
//  WBMaterialRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol WBMaterialRemoteType {
    func fetchMaterialElements(completion: @escaping (_ result: WBRemoteResult<[WBJsonMaterialElement]?>) -> ())
}

class WBMaterialRemote: WBRemote, WBMaterialRemoteType {
    func fetchMaterialElements(completion: @escaping (_ result: WBRemoteResult<[WBJsonMaterialElement]?>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/account/materials", headers: self.remoteSession?.headers)
        request.responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess,
                let elements = response.result.value as? [AnyObject]
            {
                var resultElements: [WBJsonMaterialElement] = []
                for e in elements {
                    if !(e is NSNull),
                        let ej = e as? [String : Any],
                        let mElement = WBJsonMaterialElement(JSON: ej)
                    {
                        if resultElements.contains(mElement) {
                            let firstOccuranceIndex = resultElements.index(of: mElement)
                            guard let fi = firstOccuranceIndex,
                                let oc = resultElements[fi].count,
                                let nc = mElement.count else {
                                    return
                            }
                            
                            resultElements[fi].count = oc + nc
                        } else {
                            resultElements.append(mElement)
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
