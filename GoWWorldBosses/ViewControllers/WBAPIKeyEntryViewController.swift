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

class WBAPIKeyEntryViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        let drawerMasterVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerMasterVC")
        self.present(drawerMasterVC, animated: true, completion: {
            
        })
    }
    
    @IBAction func qrCodeButtonTapped(_ sender: Any) {
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.delegate = self
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            present(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
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
    
    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func authenticate(apiKey: String) {
        let key = apiKey.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.syncCoordinator = WBSyncCoordinator(remoteSession: WBRemoteSession(domain: "https://api.guildwars2.com/v2", bearer: key))
        self.syncCoordinator?.syncAll({ (success, error) in
            if success {
                let drawerMasterVC = WBStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerMasterVC")
                self.present(drawerMasterVC, animated: true, completion: {
                    
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
        })
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        reader.dismiss(animated: true) {
            self.authenticate(apiKey: result.value)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {}
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
