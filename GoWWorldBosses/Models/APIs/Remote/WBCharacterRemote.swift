//
//  WBCharacterRemote.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol WBCharacterRemoteType {
}

class WBCharacterRemote: WBRemote, WBCharacterRemoteType {
    
    func fetchCharacterNames(completion: @escaping (_ success: Bool, _ names: [String]?) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/characters", headers: self.remoteSession?.headers)
        request.responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess,
                let names = response.result.value as? [String]
            {
                completion(true, names)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func fetchCharacters(byNames names: [String], completion: @escaping (_ success: Bool, _ currencies: [WBJsonCharacter]?) -> ()) {
        
        let idsString = names.map{ $0 }.joined(separator: ",")
        let parameters = "?ids=\(idsString)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        // pass empty dict to trigger custom encoding routines
        let domain: String = self.remoteSession?.domain ?? ""
        
        let request = self.alamoFireManager.request(domain + "/characters" + parameters, headers: self.remoteSession?.headers)
        request.responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess,
                let elements = response.result.value as? [AnyObject]
            {
                var resultElements: [WBJsonCharacter] = []
                for e in elements {
                    if !(e is NSNull),
                        let ej = e as? [String : Any],
                        let bankElement = WBJsonCharacter(JSON: ej)
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
