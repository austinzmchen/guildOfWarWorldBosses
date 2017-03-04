//
//  WBStorageTableViewModelType.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

protocol WBStorageTableViewModelDelegate: class {
    func didComplete(success: Bool, items: [Any]?, error: Error?)
}

protocol WBStorageTableViewModelType {
    var delegate: WBStorageTableViewModelDelegate? {get set}
    func identifierForSuitableCell(atIndex index: Int) -> String
    var items: [WBObject]? {get}
}

extension WBStorageTableViewModelType {
    func identifierForSuitableCell(atIndex index: Int) -> String {
        return "storageItemTableCell"
    }
}
