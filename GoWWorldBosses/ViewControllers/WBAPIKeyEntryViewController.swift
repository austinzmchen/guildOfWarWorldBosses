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
        
        // Do any additional setup after loading the view.
        if let keyItem = WBKeyStore.keyStoreItem,
            !(keyItem.accountAPIKey == "")
        {
            self.authenticate(apiKey: keyItem.accountAPIKey)
        }
    }
    
    func tappingOffKeyboard() {
        self.view.endEditing(true)
    }
    
    lazy var accountRemote: WBAccountRemote = {
        return WBAccountRemote()
    }()
    
    func authenticate(apiKey: String) {
        UIApplication.showLoader()
        
        let key = apiKey.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.accountRemote.authenticate(byApiKey: key) { (success) in
            DispatchQueue.main.async {
                if success {
                    // FIXME:
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
                    
                    let keyItem = WBKeyStore.keyStoreItem
                    WBKeyStore.keyStoreItem = WBKeyStoreItem(likedBosses: (keyItem?.likedBosses ?? Set<String>()), accountAPIKey: key)
                    
                    let syncCoordinator = WBSyncCoordinator(remoteSession: WBRemoteSession(domain: WBRemote.domain, bearer: key))
                    
                    // create app configuration
                    appDelegate.appConfiguration.setObject(syncCoordinator, forKey: kAppConfigurationSyncCoordinator as NSCopying)
                    
                    syncCoordinator.syncAll({ (success, error) in
                        self.presentLandingView(completion: { 
                            UIApplication.hideLoader()
                        })
                    })
                } else {
                    self.presentErrorView()
                    UIApplication.hideLoader()
                }
            }
        }
        
    }
    
}

extension WBAPIKeyEntryViewController {
    func presentLandingView(completion: @escaping () -> () ) {
        if self.isShownFullscreen {
            let drawerMasterVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerMasterVC")
            self.present(drawerMasterVC, animated: true) {
                completion()
            }
        } else {
            self.viewDelegate?.drawerItemVCShouldChange()
            completion()
        }
    }
    
    func presentErrorView() {
        let alert = UIAlertController(
            title: "My Tyria",
            message: String (format:"API Key authentication failed."),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
