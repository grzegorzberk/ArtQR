//
//  ContentView.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    @StateObject private var viewModel = QRScannerViewModel()
    @State private var isShowingScanner = false

    var body: some View {
        NavigationView {
            VStack {
                if let code = viewModel.scannedCode {
                    DisplayInfoView(code: code, dismissAction: {
                        viewModel.scannedCode = nil // Zresetuj zeskanowany kod po powrocie z widoku informacji
                    })
                } else {
                    Button("Skanuj kod QR") {
                        isShowingScanner = true
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Odczytywanie QR")
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(delegate: viewModel, codeTypes: [.qr])
        }
    }
}

