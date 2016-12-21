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
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        self.viewDelegate?.toggleDrawerView()
    }
    
    var characters: [WBCharacter]?
    weak var viewDelegate: WBDrawerMasterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftBarButtonItem = UIBarButtonItem.barButtonItem(withImageName:"icBurger",
                                                              title: "My Characters",
                                                              forTarget: self,
                                                              action: #selector(leftBarButtonTapped(_:)) )
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        
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
//            cell.leftImageView.sd_setImage(with: URL(string: char.icon))
            cell.mainLabel.text = char.race?.uppercased()
            cell.subLabel.text = char.name?.uppercased()
            cell.rightLabel.text = "lvl \(char.level)"
            
            if (indexPath.row % 2) > 0 {
                // odd number
                cell.contentView.backgroundColor = UIColor(red: 10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1)
            } else {
                // even number
                cell.contentView.backgroundColor = UIColor.black
            }
        }
        
        return cell
    }

}
