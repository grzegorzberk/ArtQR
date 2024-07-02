//
//  ScannerCoordinatorDelegate.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import Foundation

protocol ScannerCoordinatorDelegate: AnyObject {
    func didFindCode(_ code: String)
    func didFailWithError(_ error: Error)
}

