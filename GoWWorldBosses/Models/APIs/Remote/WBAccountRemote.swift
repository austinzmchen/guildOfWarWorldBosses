//
//  WBAccountRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol WBAccountRemoteType {
    func fetchAccount(byAPIKey apiKey: String, completion: @escaping (_ success: Bool, _ account: WBJsonAccount?) -> ())
}

class WBAccountRemote: WBSimpleRemote, WBAccountRemoteType {
    
    func fetchAccount(byAPIKey apiKey: String, completion: @escaping (_ success: Bool, _ account: WBJsonAccount?) -> ()) {
        let request = self.alamoFireManager.request(WBSimpleRemote.domain + "/account",
                                                    headers: ["Authorization": "Bearer " + apiKey])
        
        request.responseObject(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<WBJsonAccount>) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
}
