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
    func fetchWalletElements(_ completion: @escaping (_ success: Bool, _ walletElements: [WBJsonWalletElement]?) -> ())
    func fetchCurrencies(byIds ids: [Int64], completion: @escaping (_ success: Bool, _ currencies: [WBJsonCurrency]?) -> ())
}

class WBWalletRemote: WBRemote, WBWalletRemoteType {
    
    func fetchWalletElements(_ completion: @escaping (_ success: Bool, _ walletElements: [WBJsonWalletElement]?) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/account/wallet", headers: self.remoteSession?.headers)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonWalletElement]>) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
    
    func fetchCurrencies(byIds ids: [Int64], completion: @escaping (_ success: Bool, _ currencies: [WBJsonCurrency]?) -> ()) {
        
        let idsString = ids.map{ String($0) }.joined(separator: ",")
        let parameters = "?ids=\(idsString)"
        
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/currencies" + parameters, headers: self.remoteSession?.headers)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonCurrency]>) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
}
