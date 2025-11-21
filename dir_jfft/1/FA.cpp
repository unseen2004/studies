#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <array>
#include <cctype> // Dodano do obsługi std::isspace

// Używamy tablicy 256-elementowej dla pełnego zakresu ASCII (unsigned char)
const int ALPHABET_SIZE = 256;
using TransitionTable = std::vector<std::array<int, ALPHABET_SIZE>>;

/**
 * @brief Wczytuje całą zawartość pliku do łańcucha znaków,
 * POMIJAJĄC wszystkie białe znaki (spacje, tabulatory, nowe linie).
 */
std::string readFile(const std::string& filename) {
    std::ifstream file(filename);
    if (!file) {
        std::cerr << "Błąd: Nie można otworzyć pliku " << filename << std::endl;
        exit(1); // Zakończ program z błędem
    }

    std::string content;
    char c;

    // Czytaj plik znak po znaku
    while (file.get(c)) {
        // Użyj std::isspace do sprawdzenia, czy znak jest biały
        // static_cast jest potrzebny dla bezpieczeństwa
        if (!std::isspace(static_cast<unsigned char>(c))) {
            // Jeśli to NIE jest biały znak, dodaj go do stringa
            content += c;
        }
    }
    return content;
}

/**
 * @brief Oblicza funkcję prefiksową (pomocnicza dla computeTransitionFunction).
 * To jest implementacja z algorytmu KMP.
 */
std::vector<int> computePrefixFunction(const std::string& P) {
    int m = P.length();
    if (m == 0) return {};
    std::vector<int> pi(m);
    pi[0] = 0;
    int k = 0;
    for (int q = 1; q < m; ++q) {
        while (k > 0 && P[k] != P[q]) {
            k = pi[k - 1];
        }
        if (P[k] == P[q]) {
            k++;
        }
        pi[q] = k;
    }
    return pi;
}

/**
 * @brief Buduje tablicę przejść automatu skończonego dla wzorca P.
 * Złożoność: O(m * |Sigma|), gdzie m = P.length()
 */
TransitionTable computeTransitionFunction(const std::string& P, int m) {
    // Automat ma m+1 stanów (0 do m)
    TransitionTable delta(m + 1);
    if (m == 0) return delta;

    std::vector<int> pi = computePrefixFunction(P);

    // Obliczanie przejść
    for (int q = 0; q <= m; ++q) {
        for (int a_val = 0; a_val < ALPHABET_SIZE; ++a_val) {
            unsigned char a = static_cast<unsigned char>(a_val);

            if (q < m && a == static_cast<unsigned char>(P[q])) {
                // Dopasowanie: przejdź do następnego stanu
                delta[q][a_val] = q + 1;
            } else {
                // Niedopasowanie: użyj funkcji prefiksowej
                // Przejdź do stanu, który odpowiada przejściu
                // z najdłuższego prefiksu-sufiksu.
                if (q == 0) {
                    delta[q][a_val] = 0; // W stanie 0, jeśli nie pasuje P[0]
                } else {
                    delta[q][a_val] = delta[pi[q - 1]][a_val];
                }
            }
        }
    }

    // Specjalny przypadek dla stanu 0 i P[0]
    if (m > 0) {
        delta[0][static_cast<unsigned char>(P[0])] = 1;
    }

    return delta;
}

/**
 * @brief Wyszukuje wzorzec P w tekście T przy użyciu automatu skończonego.
 */
void finiteAutomatonMatcher(const std::string& T, const std::string& P) {
    int n = T.length();
    int m = P.length();
    if (m == 0) return; // Pusty wzorzec

    TransitionTable delta = computeTransitionFunction(P, m);
    int q = 0; // Stan początkowy

    for (int i = 0; i < n; ++i) {
        // Użyj unsigned char, aby poprawnie indeksować tablicę (0-255)
        unsigned char c = T[i];
        q = delta[q][c]; // Następny stan

        if (q == m) {
            // Osiągnięto stan akceptujący (m)
            // Dopasowanie kończy się na indeksie i
            int s = i - m + 1; // Indeks początkowy dopasowania
            std::cout << "Wzorzec wystąpił z przesunięciem: " << s << std::endl;
            // Automat automatycznie przechodzi do kolejnego stanu
            // (obsługując nakładające się wzorce) dzięki temu, jak
            // obliczyliśmy przejścia dla stanu q=m
        }
    }
}

int main(int argc, char* argv[]) {
    [cite_start]// Sprawdzenie poprawności argumentów wywołania [cite: 5, 6]
    if (argc != 3) {
        [cite_start]// [cite: 8]
        std::cerr << "Użycie: " << argv[0] << " <wzorzec> <nazwa pliku>" << std::endl;
        return 1;
    }

    std::string pattern = argv[1];
    std::string filename = argv[2];
    std::string text = readFile(filename);

    if (text.empty() && !filename.empty()) {
        std::cerr << "Plik jest pusty lub nie udało się go odczytać." << std::endl;
        // Kontynuuj, jeśli plik jest pusty, wyszukiwanie nic nie znajdzie
    }

    std::cout << "--- Wyszukiwanie automatem skończonym (FA) ---" << std::endl;
    finiteAutomatonMatcher(text, pattern);
    std::cout << "-----------------------------------------------" << std::endl;

    return 0;
}