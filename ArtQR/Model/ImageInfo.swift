//
//  ImageInfo.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import Foundation


struct ImageInfo: Codable {
    let imageName: String
    let fileName: String  // Nowa informacja o nazwie pliku obrazu
    let author: String
    let description: String
}
