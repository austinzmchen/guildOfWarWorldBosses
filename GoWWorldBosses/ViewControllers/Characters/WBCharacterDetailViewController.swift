//
//  WBCharacterDetailViewController.swift
//  WorldBosses
//
//  Created by Austin Chen on 2018-02-02.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class WBCharacterDetailViewController: UIViewController {
    
    @IBAction func xButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerBgImageView: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet var currentGearsTableCell: UITableViewCell!
    @IBOutlet weak var currentGearsCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellNib(WBStorageItemTableViewCell.self)
    }
}

extension WBCharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // + inventory
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        } else if indexPath.row == 1 {
            return 100
        } else if indexPath.row == 2 {
            return 45
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: WBCharacterSectionHeaderTableCell = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel?.text = "Current Gear".uppercased()
            return cell
        } else if indexPath.row == 1 {
            return currentGearsTableCell
        } else if indexPath.row == 2 {
            let cell: WBCharacterSectionHeaderTableCell = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel?.text = "Inventory".uppercased()
            return cell
        } else {
            let cell: WBStorageItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}

extension WBCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kWBCharacterCurrentGearCollectionCell", for: indexPath)
        return cell
    }
}

extension WBCharacterDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 25, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 25, height: 0)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if accounts.count == 1 {
//            return CGSize(width: UIScreen.main.bounds.width - 20 * 2, height: 210)
//        } else if accounts.count == 2 {
//            let w = (UIScreen.main.bounds.width - 20 * 2 - 10) / 2.0
//            return CGSize(width: w, height: 210)
//        } else {
//            let w = (UIScreen.main.bounds.width - 20 - 10 * 2) / 2.5
//            return CGSize(width: w, height: 210)
//        }
//    }
}

