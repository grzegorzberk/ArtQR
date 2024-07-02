# ArtQR

"ArtQR" to aplikacja dla iOS, która umożliwia użytkownikom skanowanie kodów QR, aby uzyskać informacje o dziełach sztuki. Dzięki tej aplikacji, użytkownicy mogą natychmiast odczytać ciekawostki, dane autora oraz szczegółowe opisy zeskanowanych obiektów.

## Funkcje

- **Skanowanie kodów QR**: Użytkownicy mogą skanować kody QR, które zawierają zaszyfrowane informacje o dziełach sztuki.
- **Wyświetlanie informacji**: Po zeskanowaniu kodu QR aplikacja wyświetla informacje, takie jak nazwa dzieła, autor, opis oraz obraz dzieła (jeśli dostępny).
- **Interfejs użytkownika**: Prosty i intuicyjny interfejs użytkownika, który ułatwia skanowanie i czytanie informacji.

## Technologie

Aplikacja została zbudowana przy użyciu:

- **SwiftUI**: Nowoczesny framework do tworzenia interfejsu użytkownika w aplikacjach iOS.
- **Swift Package Manager**: Zarządzanie zależnościami i bibliotekami zewnętrznymi.
- **AVFoundation**: Do obsługi skanowania kodów QR.

## Zależności

- [CodeScanner](https://github.com/twostraws/CodeScanner): Biblioteka do obsługi skanowania kodów QR w SwiftUI.

## Instalacja

Aby uruchomić projekt na swoim komputerze, potrzebne będą:

- macOS z zainstalowanym Xcode 12 lub nowszym.
- iOS 14.0 lub nowszy na urządzeniu lub symulatorze.

Kroki instalacji:

1. Sklonuj repozytorium projektu:
    ```
    git clone https://github.com/grzegorzberk/ArtQR.git
    ```
2. Otwórz projekt w Xcode:
    ```
    open ArtQR.xcodeproj
    ```
3. Upewnij się, że wszystkie zależności są poprawnie zainstalowane. W Xcode przejdź do `File > Swift Packages > Update to Latest Package Versions`.
4. Wybierz odpowiedni target dla swojego urządzenia lub symulatora.
5. Uruchom aplikację (Cmd + R).

## Licencja

"ArtQR" jest udostępniony na licencji MIT.

## Kontakt

Jeśli masz jakiekolwiek pytania lub chcesz przyczynić się do projektu, skontaktuj się ze mną poprzez [email](mailto:grzegorzberk70@gmail.com).
