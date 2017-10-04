//
//  WBSkipButtonModalViewController.swift
//  WorldBosses
//
//  Created by Austin Chen on 2017-10-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class WBSkipButtonModalViewController: UIViewController {
    
    @IBAction func useAPIKeyButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.vc?.textField.becomeFirstResponder()
        })
    }
    @IBAction func confirmSkipButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.vc?.presentLandingView(animated: true) {}
        })
    }
    
    weak var vc: WBAPIKeyEntryViewController?
}
