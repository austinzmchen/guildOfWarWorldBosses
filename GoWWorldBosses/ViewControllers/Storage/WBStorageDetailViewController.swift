//
//  WBStorageDetailViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2017-03-02.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBStorageDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var item: WBObject?
}

extension WBStorageDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let itm = item as? WBBankElement else {
            return 0
        }
        if itm.item?.vendorValue ?? 0 > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var h: CGFloat = 0
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                h = 60
            } else if indexPath.row == 1 {
                guard let itm = item as? WBBankElement,
                    let desc = itm.item?.descriptionText else {
                    return h
                }
                
                let size = self.sizeThatFits(attributedString: NSMutableAttributedString(string: desc))
                h = size.height + 30.0
            } else if indexPath.row == 2 {
                if let itm = item as? WBBankElement {
                    var text = itm.item?.type ?? ""
                    if let fs = itm.item?.flags {
                        text += "\n"
                        text += fs.replacingOccurrences(of: ",", with: "\n")
                    }
                    
                    let size = self.sizeThatFits(attributedString: NSMutableAttributedString(string: text))
                    h = size.height
                }
            }
        } else {
            h = 24.0
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
            if indexPath.row == 0 {
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailTitleCell") as! WBStorageDetailTitleTableCell
                if let itm = item as? WBBankElement,
                    let ic = itm.item?.icon {
                    titleCell.imgView.sd_setImage(with: URL(string: ic))
                    titleCell.titleLabel.text = itm.item?.name
                    titleCell.titleLabel.textColor = itm.item?.rarityColor ?? UIColor.white
                    titleCell.countLabel.text = itm.count == 1 ? "" : "(\(itm.count))"
                    titleCell.countLabel.textColor = itm.item?.rarityColor ?? UIColor.white
                }
                cell = titleCell
            } else if indexPath.row == 1 {
                let descCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailDescriptionCell") as! WBStorageDetailDescriptionTableCell
                if let itm = item as? WBBankElement {
                    descCell.textView.text = itm.item?.descriptionText
                }
                cell = descCell
            } else if indexPath.row == 2 {
                let typeCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailTypeCell") as! WBStorageDetailTypeTableCell
                if let itm = item as? WBBankElement {
                    var text = itm.item?.type ?? ""
                    text += "\n"
                    if let it = itm.item {
                        text += it.adjustedFlags.joined(separator: "\n")
                    }
                    typeCell.textView.text = text
                }
                typeCell.bottomSeparator.isHidden = !(tableView.numberOfSections > 1)
                cell = typeCell
            }
        } else {
            if indexPath.row == 0 { // vendor price
                let coinValueCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailCoinValueCell") as! WBStorageDetailCoinValueTableCell
                if let itm = item as? WBBankElement {
                    coinValueCell.titleLabel.text = "Vendor Price:"
                    coinValueCell.coinView.coinValue = itm.item?.vendorValue ?? 0
                }
                cell = coinValueCell
            } else if indexPath.row == 1 { // value
                let coinValueCell = tableView.dequeueReusableCell(withIdentifier: "storageDetailCoinValueCell") as! WBStorageDetailCoinValueTableCell
                if let itm = item as? WBBankElement {
                    coinValueCell.titleLabel.text = "Value:"
                    coinValueCell.coinView.coinValue = (itm.item?.vendorValue ?? 0) * itm.count
                }
                cell = coinValueCell
            }
        }
        return cell
    }
}

extension WBStorageDetailViewController {
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


extension WBItem {
    var rarityColor: UIColor { // race title color depends on profession, not race itself. just be mindful
        var color = UIColor.white
        switch self.rarity {
        case "Junk"?:
            color = UIColor(netHex:0xC7C7C7)
        case "Basic"?:
            color = UIColor(netHex:0xFFFFFF)
        case "Fine"?:
            color = UIColor(netHex:0x0084FF)
        case "Masterwork"?:
            color = UIColor(netHex:0x68C525)
        case "Rare"?:
            color = UIColor(netHex:0xFFE000)
        case "Exotic"?:
            color = UIColor(netHex:0xFF7500)
        case "Ascended"?:
            color = UIColor(netHex:0xFF006A)
        case "Legendary"?:
            color = UIColor(netHex:0x7C00FF)
        default:
            break
        }
        return color
    }
}
