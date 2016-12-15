//
//  WBAPIKeyEntryViewController+QRCode.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-12-15.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import QRCodeReader
import AVFoundation

extension WBAPIKeyEntryViewController: QRCodeReaderViewControllerDelegate {
    
    func showQRCodeScanner() {
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
