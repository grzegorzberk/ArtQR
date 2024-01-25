//
//  ContentView.swift
//  ArtQR
//
//  Created by Grzegorz Berk on 25/01/2024.
//

import SwiftUI
import AVFoundation
import CodeScanner

struct ContentView: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        NavigationView {
            VStack {
                if let code = scannedCode {
                    DisplayInfoView(code: code, dismissAction: {
                        self.scannedCode = nil // Zresetuj zeskanowany kod po powrocie z widoku informacji
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
            CodeScannerView(didFindCode: { result in
                switch result {
                case .success(let code):
                    scannedCode = code
                case .failure(let error):
                    print("Błąd skanowania: \(error.localizedDescription)")
                }
                isShowingScanner = false
            }, codeTypes: [.qr])
        }
    }
}

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


struct ImageInfo: Codable {
    let imageName: String
    let fileName: String  // Nowa informacja o nazwie pliku obrazu
    let author: String
    let description: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
