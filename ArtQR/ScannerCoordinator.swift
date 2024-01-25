//
//  ScannerCoordinator.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 25/01/2024.
//

import SwiftUI
import Foundation
import AVFoundation

class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: CodeScannerView
    var didFindCode: (String) -> Void

    init(parent: CodeScannerView, didFindCode: @escaping (String) -> Void) {
        self.parent = parent
        self.didFindCode = didFindCode
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            didFindCode(stringValue)
        }
    }
}

struct CodeScannerView: UIViewControllerRepresentable {
    enum ScanError: Error {
        case genericError
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CodeScannerView

        init(parent: CodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.didFindCode(.success(stringValue))
            }
        }
    }

    var didFindCode: (Result<String, ScanError>) -> Void
    var codeTypes: [AVMetadataObject.ObjectType]

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CodeScannerView>) -> UIViewController {
            let viewController = UIViewController()
            let scannerViewController = UIViewController()

            let session = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return viewController
            }

            if (session.canAddInput(videoInput)) {
                session.addInput(videoInput)
            } else {
                return viewController
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)  // Zmiana na główny wątek
                metadataOutput.metadataObjectTypes = codeTypes
            } else {
                return viewController
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = scannerViewController.view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            scannerViewController.view.layer.addSublayer(previewLayer)

            viewController.addChild(scannerViewController)
            viewController.view.addSubview(scannerViewController.view)
            scannerViewController.didMove(toParent: viewController)

            session.startRunning()  // Uruchomienie sesji

            return viewController
        }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CodeScannerView>) {}

    class ScannerViewController: UIViewController {
        var coordinator: Coordinator?
        var didFindCode: (Result<String, CodeScannerView.ScanError>) -> Void = { _ in }
        var codeTypes: [AVMetadataObject.ObjectType]?

        override func viewDidLoad() {
            super.viewDidLoad()

            if let scannerCoordinator = coordinator, let codeTypes = codeTypes {
                let metadataOutput = AVCaptureMetadataOutput()

                if let captureDevice = AVCaptureDevice.default(for: .video) {
                    let session = AVCaptureSession()

                    do {
                        let input = try AVCaptureDeviceInput(device: captureDevice)
                        session.addInput(input)
                    } catch {
                        print(error.localizedDescription)
                        return
                    }

                    if session.canAddOutput(metadataOutput) {
                        session.addOutput(metadataOutput)

                        metadataOutput.setMetadataObjectsDelegate(scannerCoordinator, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = codeTypes

                        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                        previewLayer.frame = view.layer.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        view.layer.addSublayer(previewLayer)

                        session.startRunning()
                    }
                }
            }
        }
    }
}
