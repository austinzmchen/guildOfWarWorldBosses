//
//  WBStorageTableViewModelType.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-11.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation

protocol WBStorageTableViewModelDelegate: class {
    func didComplete(success: Bool, items: [WBObject]?)
}

protocol WBStorageTableViewModelType {
    //var items: [WBObject]? {get}
    //var delegate: WBStorageTableViewModelDelegate? {get set}
    
    func identifierForSuitableCell(atIndex index: Int) -> String
    func itemsCount() -> Int
    func mainTitleForItem(atIndex index: Int) -> String
    func subTitleForItem(atIndex index: Int) -> String
    func imageUrlStringForItem(atIndex index: Int) -> String
}

extension WBStorageTableViewModelType {
    func identifierForSuitableCell(atIndex index: Int) -> String {
        return "storageItemTableCell"
    }
}
