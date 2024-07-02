//
//  DisplayInfoView.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 21/04/2024.
//

import SwiftUI

struct DisplayInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    let code: String
    let dismissAction: () -> Void

    var body: some View {
        if let data = code.data(using: .utf8) {
            do {
                let decodedInfo = try JSONDecoder().decode(ImageInfo.self, from: data)

                return AnyView(
                    VStack {
                        if let image = UIImage(named: decodedInfo.fileName) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        } else {
                            Text("Nie można załadować obrazu o nazwie \(decodedInfo.fileName)").bold()
                        }

                        Text("Nazwa obrazu: \(decodedInfo.imageName)").font(.title)
                        //Text("Nazwa pliku: \(decodedInfo.fileName)")
                        Text("Autor: \(decodedInfo.author)").font(.title2)
                        Text("Opis: \(decodedInfo.description)")

                        Button(action: {
                            self.dismissAction()
                        }) {
                            Text("Powrót")
                                .padding()
                        }
                    }
                    .navigationTitle("Informacje o obrazie")
                )
            } catch {
                return AnyView(
                    VStack{
                        Text("Błąd dekodowania informacji: \(error.localizedDescription)")
                        Button(action: {
                            self.dismissAction()
                        }) {
                            Text("Powrót")
                                .padding()
                        }
                    }
                    .navigationTitle("Błąd_01")
                )
            }
        } else {
            return AnyView(
                
                VStack{
                    Text("Błąd konwersji danych kodu QR")
                    Button(action: {
                        self.dismissAction()
                    }) {
                        Text("Powrót")
                            .padding()
                    }
                }
                .navigationTitle("Błąd_02")
            )
        }
    }
}
