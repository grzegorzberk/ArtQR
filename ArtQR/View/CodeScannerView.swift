//
//  CodeScannerView.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import SwiftUI
import AVFoundation

struct CodeScannerView: UIViewControllerRepresentable {
    weak var delegate: ScannerCoordinatorDelegate?
    var codeTypes: [AVMetadataObject.ObjectType]

    func makeCoordinator() -> Coordinator {
        return Coordinator(delegate: delegate)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let scannerViewController = ScannerViewController(delegate: context.coordinator, codeTypes: codeTypes)
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        weak var delegate: ScannerCoordinatorDelegate?

        init(delegate: ScannerCoordinatorDelegate?) {
            self.delegate = delegate
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let stringValue = metadataObject.stringValue {
                delegate?.didFindCode(stringValue)
            }
        }
    }

    class ScannerViewController: UIViewController {
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        var codeTypes: [AVMetadataObject.ObjectType]?
        weak var delegate: Coordinator?

        init(delegate: Coordinator?, codeTypes: [AVMetadataObject.ObjectType]) {
            self.delegate = delegate
            self.codeTypes = codeTypes
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = codeTypes
            } else {
                return
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)

            captureSession.startRunning()
        }
    }
}
