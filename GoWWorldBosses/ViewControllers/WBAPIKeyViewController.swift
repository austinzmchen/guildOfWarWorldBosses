//
//  WBAPIKeyViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-14.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import RealmSwift

class WBAPIKeyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var accounts: [WBAccount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        let realm = try! Realm()
        let results = realm.objects(WBAccount.self)
        accounts = Array(results)
        self.tableView.reloadData()
    }
}

extension WBAPIKeyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count // shoud just be 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiKeyCell") as! WBAPIKeyTableViewCell
        
        if indexPath.row < self.accounts.count,
            let keyStoreItem = WBKeyStore.keyStoreItem
        {
            let account = self.accounts[indexPath.row]
            cell.mainLabel.text = "CURRNET KEY"
            cell.subLabel.text = account.name
            cell.bodyLabel.text = keyStoreItem.accountAPIKey
        }
        
        return cell
    }
}

extension WBAPIKeyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "Remove API Key", message: "Are you sure you want to remove your API Key?", preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
            let realm = try! Realm()
            try! realm.removeAll(type: WBAccount.self)
            WBKeyStore.keyStoreItem = nil // delete api key
            self.accounts = []
            
            self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic) // FIXME:
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
