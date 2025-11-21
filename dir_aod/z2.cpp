#include <iostream>
#include <vector>
#include <string>
#include <list>
#include <sstream>

#define STAN_NIEODWIEDZONY 0
#define STAN_ODWIEDZANY 1
#define STAN_ODWIEDZONY 2

/**
 * @brief Klasa reprezentująca graf na potrzeby Zadania 2.
 */
class Graph {
private:
    int n; // liczba wierzchołków
    int m; // liczba krawędzi
    char graph_type; // 'D' (skierowany) lub 'U' (nieskierowany)
    std::vector<std::vector<int>> adj; // Lista sąsiedztwa

    // Struktury na potrzeby sortowania topologicznego
    std::vector<int> visit_state;
    std::list<int> topological_order;
    bool has_cycle;

    /**
     * @brief Funkcja pomocnicza (rekurencyjna) DFS do wykrywania cykli i sortowania.
     * @param u Aktualnie odwiedzany wierzchołek.
     */
    void dfs_visit(int u) {
        // Jeśli cykl został już gdziekolwiek znaleziony, przerywamy
        if (has_cycle) return;

        // Oznaczamy wierzchołek jako "w trakcie odwiedzania"
        visit_state[u] = STAN_ODWIEDZANY;

        for (int v : adj[u]) {
            if (visit_state[v] == STAN_NIEODWIEDZONY) {
                dfs_visit(v);
                // Propagujemy informację o znalezieniu cyklu w górę rekurencji
                if (has_cycle) return;
            } else if (visit_state[v] == STAN_ODWIEDZANY) {
                // Znaleźliśmy krawędź wsteczną do wierzchołka, który jest
                // na tej samej ścieżce rekurencji. TO JEST CYKL.
                has_cycle = true;
                return;
            }
            // Jeśli visit_state[v] == STAN_ODWIEDZONY,
            // to jest to krawędź poprzeczna lub do przodu, ignorujemy ją.
        }

        // Wszystkie ścieżki z 'u' zostały zbadane, oznaczamy jako w pełni odwiedzony
        visit_state[u] = STAN_ODWIEDZONY;
        // Dodajemy na początek listy - to jest sedno sortowania topologicznego
        topological_order.push_front(u);
    }

public:
    /**
     * @brief Wczytuje definicję grafu ze standardowego wejścia.
     */
    void read() {
        std::cin >> graph_type;
        std::cin >> n;
        std::cin >> m;

        adj.resize(n + 1);

        for (int i = 0; i < m; ++i) {
            int u, v;
            std::cin >> u >> v;
            adj[u].push_back(v);
        }
    }

    /**
     * @brief Uruchamia algorytm sortowania topologicznego z wykrywaniem cyklu.
     */
    void run_topological_sort() {
        // Sortowanie topologiczne jest zdefiniowane tylko dla grafów skierowanych
        if (graph_type == 'U') {
            std::cout << "Blad: Sortowanie topologiczne jest dla grafow skierowanych.\n";
            return;
        }

        // Inicjalizacja
        visit_state.assign(n + 1, STAN_NIEODWIEDZONY);
        topological_order.clear();
        has_cycle = false;

        // Pętla po wszystkich wierzchołkach, aby obsłużyć niespójne grafy
        for (int i = 1; i <= n; ++i) {
            if (visit_state[i] == STAN_NIEODWIEDZONY) {
                dfs_visit(i);
            }
        }

        // Wypisanie wyników zgodnie z poleceniem
        if (has_cycle) {
            std::cout << "Graf zawiera skierowany cykl.\n";
        } else {
            std::cout << "Graf jest acykliczny.\n";

            // Wypisujemy porządek tylko jeśli n <= 200
            if (n <= 200) {
                std::cout << "Porzadek topologiczny: ";
                bool first = true;
                for (int node : topological_order) {
                    if (!first) {
                        std::cout << " ";
                    }
                    std::cout << node;
                    first = false;
                }
                std::cout << "\n";
            }
        }
    }
};

int main() {
    // Optymalizacja wejścia/wyjścia
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);

    Graph g;
    g.read();
    g.run_topological_sort();

    return 0;
}
