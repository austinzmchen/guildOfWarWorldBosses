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
            cell.leftImageView.image = char.iconImage
            cell.mainLabel.text = char.race?.uppercased()
            cell.mainLabel.textColor = char.raceFontColor
            cell.subLabel.text = char.name?.uppercased()
            cell.rightLabel.text = "\(char.level)"
            
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

extension WBCharacter {
    var iconImage: UIImage? {
        // local icon file name is eg, "icGuardian"
        let imgName = String(format: "ic%@", self.profession?.capitalized ?? "")
        return UIImage(named: imgName)
    }
    
    var raceFontColor: UIColor { // race title color depends on profession, not race itself. just be mindful
        var color = UIColor.clear
        if self.profession?.lowercased() == "elementalist" {
            color = UIColor(netHex:0xFF1881)
        } else if self.profession?.lowercased() == "engineer" {
            color = UIColor(netHex:0xC0908E)
        } else if self.profession?.lowercased() == "guardian" {
            color = UIColor(netHex:0x2CB3FF)
        } else if self.profession?.lowercased() == "mesmer" {
            color = UIColor(netHex:0xD01FFF)
        } else if self.profession?.lowercased() == "necromancer" {
            color = UIColor(netHex:0x72D15D)
        } else if self.profession?.lowercased() == "ranger" {
            color = UIColor(netHex:0xABD104)
        } else if self.profession?.lowercased() == "revenant" {
            color = UIColor(netHex:0xDC1313)
        } else if self.profession?.lowercased() == "thief" {
            color = UIColor(netHex:0xDE6155)
        } else if self.profession?.lowercased() == "warrior" {
            color = UIColor(netHex:0xFF7400)
        }
        return color
    }
}
