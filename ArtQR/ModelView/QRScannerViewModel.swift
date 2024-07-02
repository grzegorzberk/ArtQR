//
//  QRScannerViewModel.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import Foundation

class QRScannerViewModel: ObservableObject {
    @Published var scannedCode: String?
    
    func handleScannedCode(_ code: String?) {
        DispatchQueue.main.async { // Zaktualizuj na głównym wątku
                    self.scannedCode = code
                }
    }
    
    func handleScannerError(_ error: Error) {
        // Obsługa błędów skanowania
        print("Błąd skanowania: \(error.localizedDescription)")
    }
    
}

extension QRScannerViewModel: ScannerCoordinatorDelegate {
    func didFindCode(_ code: String) {
        handleScannedCode(code)
    }
    
    func didFailWithError(_ error: Error) {
        handleScannerError(error)
    }
}
