//
//  WBCharactersTableViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-13.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import RealmSwift

class WBCharactersTableViewController: UITableViewController, WBDrawerItemViewControllerType {
    
    var characters: [WBCharacter]?
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let results = realm.objects(WBCharacter.self)
        self.characters = Array(results)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "charactersTableCell", for: indexPath) as! WBCharactersTableViewCell
        
        // Configure the cell...
        if let chars = self.characters,
            indexPath.row < chars.count
        {
            let char = chars[indexPath.row]
            
            cell.mainLabel.text = char.name
        }
        
        return cell
    }

}
