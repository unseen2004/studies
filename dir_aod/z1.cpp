#include <iostream>
#include <vector>
#include <string>
#include <queue>
#include <sstream> // Używane do czytania danych wejściowych

/**
 * @brief Klasa reprezentująca graf i implementująca algorytmy DFS/BFS.
 * * Wybraną reprezentacją jest lista sąsiedztwa,
 * która jest efektywna dla algorytmów DFS/BFS (złożoność O(n+m)).
 */
class Graph {
private:
    int n; // liczba wierzchołków
    int m; // liczba krawędzi
    char graph_type; // 'D' (skierowany) lub 'U' (nieskierowany)
    std::vector<std::vector<int>> adj; // Lista sąsiedztwa

    // Prywatne wektory do przechowywania wyników
    std::vector<bool> visited;
    std::vector<int> visit_order;
    std::vector<int> parent;

    /**
     * @brief Funkcja pomocnicza (rekurencyjna) dla DFS.
     * @param u Aktualnie odwiedzany wierzchołek.
     */
    void dfs_visit(int u) {
        visited[u] = true;
        visit_order.push_back(u);
        for (int v : adj[u]) {
            if (!visited[v]) {
                parent[v] = u;
                dfs_visit(v);
            }
        }
    }

    /**
     * @brief Funkcja pomocnicza do wypisywania wyników.
     * @param method_name Nazwa algorytmu (np. "DFS").
     * @param show_tree Czy wypisać drzewo przeszukiwania.
     */
    void print_results(const std::string& method_name, bool show_tree) {
        std::cout << "--- " << method_name << " ---\n";
        std::cout << "Kolejnosc odwiedzin: ";
        for (size_t i = 0; i < visit_order.size(); ++i) {
            std::cout << visit_order[i] << (i == visit_order.size() - 1 ? "" : " ");
        }
        std::cout << "\n";

        if (show_tree) {
            std::cout << "Drzewo " << method_name << " (krawedzie postaci rodzic -> dziecko):\n";
            for (int i = 1; i <= n; ++i) {
                if (parent[i] != 0) { // 0 oznacza korzeń (lub nieodwiedzony, ale tu filtrujemy)
                    std::cout << parent[i] << " -> " << i << "\n";
                }
            }
        }
        std::cout << "\n";
    }

public:
    /**
     * @brief Wczytuje definicję grafu ze standardowego wejścia.
     */
    void read() {
        std::cin >> graph_type; // Flaga 'D' lub 'U'
        std::cin >> n; // Liczba wierzchołków
        std::cin >> m; // Liczba krawędzi

        // Inicjalizujemy listę sąsiedztwa dla n wierzchołków (indeksowanych od 1)
        adj.resize(n + 1);

        for (int i = 0; i < m; ++i) {
            int u, v;
            std::cin >> u >> v; // Definicja krawędzi
            adj[u].push_back(v);

            // Jeśli graf jest nieskierowany, dodajemy krawędź w obie strony
            if (graph_type == 'U') {
                adj[v].push_back(u);
            }
        }
    }

    /**
     * @brief Wykonuje algorytm DFS (Przeszukiwanie wgłąb).
     * @param show_tree Czy wypisać drzewo przeszukiwania.
     */
    void run_dfs(bool show_tree) {
        // Resetowanie stanu
        visited.assign(n + 1, false);
        parent.assign(n + 1, 0); // 0 oznacza brak rodzica (korzeń)
        visit_order.clear();

        // Pętla po wszystkich wierzchołkach, aby obsłużyć grafy niespójne
        for (int i = 1; i <= n; ++i) {
            if (!visited[i]) {
                dfs_visit(i);
            }
        }

        print_results("DFS", show_tree);
    }

    /**
     * @brief Wykonuje algorytm BFS (Przeszukiwanie wszerz).
     * @param show_tree Czy wypisać drzewo przeszukiwania.
     */
    void run_bfs(bool show_tree) {
        // Resetowanie stanu
        visited.assign(n + 1, false);
        parent.assign(n + 1, 0);
        visit_order.clear();
        std::queue<int> q;

        // Pętla po wszystkich wierzchołkach, aby obsłużyć grafy niespójne
        for (int i = 1; i <= n; ++i) {
            if (!visited[i]) {
                q.push(i);
                visited[i] = true;
                visit_order.push_back(i);
                // parent[i] zostaje 0 (korzeń)

                while (!q.empty()) {
                    int u = q.front();
                    q.pop();

                    for (int v : adj[u]) {
                        if (!visited[v]) {
                            visited[v] = true;
                            parent[v] = u;
                            visit_order.push_back(v);
                            q.push(v);
                        }
                    }
                }
            }
        }

        print_results("BFS", show_tree);
    }
};

/**
 * @brief Funkcja główna programu.
 * * @param argc Liczba argumentów linii poleceń.
 * @param argv Tablica argumentów linii poleceń.
 */
int main(int argc, char* argv[]) {
    // Optymalizacja wejścia/wyjścia
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);

    // Sprawdzenie "odpowiedniego parametru"
    bool show_tree = false;
    if (argc > 1 && (std::string(argv[1]) == "--drzewo" || std::string(argv[1]) == "--tree")) {
        show_tree = true;
    }

    Graph g;
    g.read(); // Wczytanie grafu

    // Uruchomienie algorytmów
    g.run_dfs(show_tree);
    g.run_bfs(show_tree);

    return 0;
}
