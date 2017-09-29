//
//  STTabsHeaderView.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STTabsHeaderViewDelegate: class {
    func didSelectTab(atIndex idx: Int, animated: Bool)
}

class STTabsHeaderView: UIView {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // constants
    var cellWidth: CGFloat = 180 //UIScreen.main.bounds.width / 2.0 // custom set
    
    var tabTitles: [String] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var selectedIndex: Int = 0
    
    var tabMinX: CGFloat = 0
    var allowBounce: Bool = false
    weak var delegate: STTabsHeaderViewDelegate?
    var style: STTabsHeaderViewStyle = .leftTab
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add the missing contrainst between xib contentView to self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // set up datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "STTabHeaderCollectionViewCell", bundle: Bundle(for: type(of: self))),
                                forCellWithReuseIdentifier: "kTabHeaderCollectionCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
}

extension STTabsHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        switch style {
        case .leftTab:
            return CGSize.zero
        case .centerTab:
            return CGSize(width: headerWidthForCenterTabStyle, height: self.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        switch style {
        case .leftTab:
            return CGSize.zero
        case .centerTab:
            return CGSize(width: headerWidthForCenterTabStyle, height: self.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth, height: self.bounds.size.height);
    }
}

extension STTabsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "kTabHeaderCollectionCell", for: indexPath) as! STTabHeaderCollectionViewCell
        item.tag = indexPath.row
        
        // hight light selected cell
        if selectedIndex == indexPath.row {
            item.headerTitleLabel.textColor = UIColor.white
        } else {
            item.headerTitleLabel.textColor = UIColor(white: 1, alpha: 0.6)
        }
        item.headerTitleLabel.text = self.tabTitles[indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.animateScroll(toIndex: indexPath.row)
        
        if indexPath.row >= 0 && indexPath.row < tabTitles.count {
            self.delegate?.didSelectTab(atIndex: indexPath.row, animated: true)
        }
    }
}
