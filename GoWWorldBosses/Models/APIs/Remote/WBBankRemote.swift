//
//  WBTripRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-23.
//

import Foundation
import Alamofire

protocol WBBankRemoteType {
    func fetchBanks(completion: @escaping (_ success: Bool, _ elements: [WBJsonBankElement]?) -> ())
    func fetchBankItems(byIds ids: [Int64],  completion: @escaping (_ success: Bool, _ currencies: [WBJsonBankItem]?) -> ())
}

class WBBankRemote: WBRemote, WBBankRemoteType {
    
    func fetchBanks(completion: @escaping (_ success: Bool, _ elements: [WBJsonBankElement]?) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/account/bank", headers: self.remoteSession?.headers)
        request.responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess,
                let elements = response.result.value as? [AnyObject]
            {
                let bankElements: [WBJsonBankElement] = MapHelper2.mapArrayWithNullElements(elements: elements)
                completion(true, bankElements)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func fetchBankItems(byIds ids: [Int64], completion: @escaping (_ success: Bool, _ currencies: [WBJsonBankItem]?) -> ()) {
        
        let idsString = ids.map{ String($0) }.joined(separator: ",")
        let parameters = "?ids=\(idsString)"
        
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/items" + parameters, headers: self.remoteSession?.headers)
        request.responseArray(queue: WBRemoteSettings.concurrentQueue) { (response: DataResponse<[WBJsonBankItem]>) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
}
