//
//  WBStorageMaterialDetailViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-02.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBStorageMaterialDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var item: WBObject?
    
}

extension WBStorageMaterialDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { // price as the second section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var h: CGFloat = 0
        if indexPath.section == 0 {
            if let be = item as? WBMaterialElement,
                let itm = be.item
            {
                if indexPath.row == 0 {
                    h = 80
                } else if indexPath.row == 1 {
                    if let be = item as? WBMaterialElement,
                        let itm = be.item,
                        let desc = itm.descriptionText, desc.characters.count > 0
                    {
                        let size = self.sizeThatFits(attributedString: NSMutableAttributedString(string: desc))
                        h = size.height + 16
                    }
                }
            }
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 14.0 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = UIView()
        h.backgroundColor = UIColor.clear
        return h
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            if let be = item as? WBMaterialElement,
                let itm = be.item
            {
                if indexPath.row == 0 {
                    let titleCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailTitleCell") as! WBStorageDetailTitleTableCell
                    if let itm = item as? WBMaterialElement,
                        let ic = itm.item?.icon {
                        titleCell.imgView.sd_setImage(with: URL(string: ic))
                        titleCell.titleLabel.text = itm.item?.name
                        titleCell.countLabel.text = itm.count == 1 ? "" : "(\(itm.count))"
                    }
                    cell = titleCell
                } else if indexPath.row == 1 {
                    let descCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailDescriptionCell") as! WBStorageDetailDescriptionTableCell
                    if let be = item as? WBMaterialElement,
                        let itm = be.item {
                        descCell.textView.text = itm.descriptionText
                    }
                    cell = descCell
                }
            }
        }
        return cell
    }
}

extension WBStorageMaterialDetailViewController {
    func sizeThatFits(string: String) -> CGSize {
        let s = string as NSString
        
        let constraintRect = CGSize(width: kTextViewWidth, height: .greatestFiniteMagnitude)
        let font = UIFont.systemFont(ofSize: kTextViewFont, weight: UIFontWeightRegular)
        let boundingBox = s.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.size
    }
    
    func sizeThatFits(attributedString: NSMutableAttributedString) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = kTextViewLineSpace
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: kTextViewFont, weight: UIFontWeightRegular), NSForegroundColorAttributeName: UIColor.white]
        attributedString.addAttributes(attrs, range: NSMakeRange(0, attributedString.length))
        
        let constraintRect = CGSize(width: kTextViewWidth, height: .greatestFiniteMagnitude)
        let boundingBox = attributedString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.size
    }
}

fileprivate let kTextViewFont: CGFloat = 15.0
fileprivate let kTextViewLineSpace: CGFloat = 8
fileprivate let kTextViewWidth: CGFloat = UIScreen.main.bounds.width - 37.5 * 2
