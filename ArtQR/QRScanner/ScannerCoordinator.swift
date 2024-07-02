//
//  ScannerCoordinator.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import Foundation
import AVFoundation

class ScannerCoordinator: NSObject {
    weak var delegate: ScannerCoordinatorDelegate?
    private let metadataOutput = AVCaptureMetadataOutput()

    init(delegate: ScannerCoordinatorDelegate) {
        self.delegate = delegate
        super.init()
    }

    func startScanning() {
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
}

extension ScannerCoordinator: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didFindCode(stringValue)
        }
    }
}
