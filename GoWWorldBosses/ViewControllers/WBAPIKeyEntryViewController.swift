//
//  WBAPIKeyEntryViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-02.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation
import RealmSwift

class WBAPIKeyEntryViewController: UIViewController, WBDrawerItemViewControllerType {

    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.toggleDrawerView()
    }
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        let drawerMasterVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerMasterVC")
        self.present(drawerMasterVC, animated: true) {}
    }
    
    @IBAction func qrCodeButtonTapped(_ sender: Any) {
        showQRCodeScanner()
    }
    
    @IBAction func textFieldGoButtonTapped(_ sender: Any) {
        textField.resignFirstResponder()
        
        if let text = self.textField.text {
            self.authenticate(apiKey: text)
        }
    }
    
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = false
        $0.showSwitchCameraButton = false
    })
    
    var syncCoordinator: WBSyncCoordinator?
    var isShownFullscreen: Bool = true
    var viewDelegate: WBDrawerMasterViewControllerDelegate?
    
    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isShownFullscreen {
            self.navigationController?.isNavigationBarHidden = true
            skipButton.isHidden = false
        } else {
            self.navigationController?.isNavigationBarHidden = false
            skipButton.isHidden = true
        }
        
        // dismiss keyboard when tapping off
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappingOffKeyboard))
        view.addGestureRecognizer(tapGR)
        
        UIApplication.showLoader()

        // Do any additional setup after loading the view.
        if let keyItem = WBKeyStore.keyStoreItem,
            !(keyItem.accountAPIKey == "")
        {
            self.authenticate(apiKey: keyItem.accountAPIKey)
        } else {
            UIApplication.hideLoader()
        }
    }
    
    func tappingOffKeyboard() {
        self.view.endEditing(true)
    }
    
    lazy var accountRemote: WBAccountRemote = {
        return WBAccountRemote()
    }()
    
    func authenticate(apiKey: String) {
        // FIXME:
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        let key = apiKey.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.accountRemote.fetchAccount(byAPIKey: key, completion: { (success, account) in
            DispatchQueue.main.async {
                if success {
                    self.syncCoordinator = WBSyncCoordinator(remoteSession: WBRemoteSession(domain: WBRemote.domain, bearer: key))
                    self.syncCoordinator?.syncAll({ (success, error) in
                        let keyItem = WBKeyStore.keyStoreItem
                        WBKeyStore.keyStoreItem = WBKeyStoreItem(likedBosses: (keyItem?.likedBosses ?? Set<String>()), accountAPIKey: key)
                        
                        if self.isShownFullscreen {
                            let drawerMasterVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerMasterVC")
                            self.present(drawerMasterVC, animated: true) {}
                        } else {
                            self.viewDelegate?.drawerItemVCShouldChange()
                        }
                    })
                } else {
                    let alert = UIAlertController(
                        title: "My Tyria",
                        message: String (format:"APIKey failed: %@", apiKey),
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                UIApplication.hideLoader()
            }
        })
        
    }
    
}
