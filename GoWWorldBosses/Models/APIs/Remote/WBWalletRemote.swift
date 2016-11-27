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
    func fetchCurrencies(_ completion: @escaping (_ success: Bool, _ currencies: [WBJsonCurrency]?) -> ())
}

class WBWalletRemote: WBRemote, WBWalletRemoteType {
    
    func fetchCurrencies(_ completion: @escaping (_ success: Bool, _ currencies: [WBJsonCurrency]?) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/trip-manager/history/passenger?passengerId=", headers: nil)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonCurrency]>) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
}
