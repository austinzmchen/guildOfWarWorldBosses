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
    func authenticate(byApiKey apiKey: String, completion: @escaping (_ success: Bool) -> ())
    func fetchAccount(byApiKey apiKey: String, completion: @escaping (_ success: Bool, _ account: WBJsonAccount?) -> ())
}

class WBAccountRemote: WBSimpleRemote, WBAccountRemoteType {
    
    func authenticate(byApiKey apiKey: String, completion: @escaping (_ success: Bool) -> ()) {
        self.fetchAccount(byApiKey: apiKey) { (success, account) in
            if success && account != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchAccount(byApiKey apiKey: String, completion: @escaping (_ success: Bool, _ account: WBJsonAccount?) -> ()) {
        let request = self.alamoFireManager.request(WBSimpleRemote.domain + "/account",
                                                    headers: ["Authorization": "Bearer " + apiKey])
        
        request.validate(statusCode: 200..<300).responseObject(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<WBJsonAccount>) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
}
