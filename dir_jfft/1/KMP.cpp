#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>

/**
 * @brief Wczytuje całą zawartość pliku do łańcucha znaków.
 */
std::string readFile(const std::string& filename) {
    std::ifstream file(filename);
    if (!file) {
        std::cerr << "Błąd: Nie można otworzyć pliku " << filename << std::endl;
        exit(1); // Zakończ program z błędem
    }
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

/**
 * @brief Oblicza funkcję prefiksową (tablica pi) dla algorytmu KMP.
 * pi[q] przechowuje długość najdłuższego właściwego prefiksu P[0..q],
 * który jest jednocześnie sufiksem P[0..q].
 */
std::vector<int> computePrefixFunction(const std::string& P) {
    int m = P.length();
    if (m == 0) return {};

    std::vector<int> pi(m);
    pi[0] = 0; // Zawsze 0 dla pierwszego znaku
    int k = 0; // Długość pasującego prefiksu

    for (int q = 1; q < m; ++q) {
        // Szukamy krótszego prefiksu, który pasuje
        while (k > 0 && P[k] != P[q]) {
            k = pi[k - 1];
        }
        // Jeśli znaki pasują, wydłużamy prefiks
        if (P[k] == P[q]) {
            k++;
        }
        pi[q] = k;
    }
    return pi;
}

/**
 * @brief Wyszukuje wzorzec P w tekście T przy użyciu algorytmu KMP.
 */
void kmpMatcher(const std::string& T, const std::string& P) {
    int n = T.length();
    int m = P.length();
    if (m == 0) return; // Pusty wzorzec

    std::vector<int> pi = computePrefixFunction(P);
    int q = 0; // Liczba dopasowanych znaków (stan w automacie KMP)

    for (int i = 0; i < n; ++i) { // Iteruj przez tekst T
        // Niedopasowanie: użyj tablicy pi, aby przesunąć wzorzec
        while (q > 0 && P[q] != T[i]) {
            q = pi[q - 1];
        }
        // Dopasowanie: przejdź do następnego znaku wzorca
        if (P[q] == T[i]) {
            q++;
        }
        // Znaleziono pełne dopasowanie
        if (q == m) {
            // Dopasowanie kończy się na indeksie i
            int s = i - m + 1; // Indeks początkowy dopasowania
            std::cout << "Wzorzec wystąpił z przesunięciem: " << s << std::endl;

            // Przygotuj się do szukania kolejnego (być może nakładającego się)
            // dopasowania, cofając się do najdłuższego prefiksu-sufiksu
            q = pi[q - 1];
        }
    }
}

int main(int argc, char* argv[]) {
    // Sprawdzenie poprawności argumentów wywołania [cite: 5, 7]
    if (argc != 3) {
         // [cite: 8]
        std::cerr << "Użycie: " << argv[0] << " <wzorzec> <nazwa pliku>" << std::endl;
        return 1;
    }

    std::string pattern = argv[1];
    std::string filename = argv[2];
    std::string text = readFile(filename);

    if (text.empty() && !filename.empty()) {
        std::cerr << "Plik jest pusty lub nie udało się go odczytać." << std::endl;
    }

    std::cout << "--- Wyszukiwanie KMP ---" << std::endl;
    kmpMatcher(text, pattern);
    std::cout << "------------------------" << std::endl;

    return 0;
}
