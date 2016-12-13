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
    func fetchMaterialElements(completion: @escaping (_ success: Bool, _ elements: [WBJsonMaterialElement]?) -> ())
}

class WBMaterialRemote: WBRemote, WBMaterialRemoteType {
    func fetchMaterialElements(completion: @escaping (_ success: Bool, _ elements: [WBJsonMaterialElement]?) -> ()) {
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
                        let bankElement = WBJsonMaterialElement(JSON: ej)
                    {
                        resultElements.append(bankElement)
                    }
                }
                completion(true, resultElements)
            } else {
                completion(false, nil)
            }
        }
    }
}
