# Algorithms and Data Structures (AiSD)

This directory contains solutions for the "Algorithms and Data Structures" course.

## Programs

### `z1.cpp`

This program implements Breadth-First Search (BFS) and Depth-First Search (DFS) graph traversal algorithms.

#### How to Run

1.  Compile the program:
    ```bash
    g++ -std=c++17 z1.cpp -o z1
    ```
2.  Run the program, providing graph data through standard input:
    ```bash
    ./z1 < input.txt
    ```
    You can also run it with the `--tree` flag to display the search tree:
    ```bash
    ./z1 --tree < input.txt
    ```

### `z2.cpp`

This program performs a topological sort on a directed acyclic graph (DAG) and detects cycles in a directed graph.

#### How to Run

1.  Compile the program:
    ```bash
    g++ -std=c++17 z2.cpp -o z2
    ```
2.  Run the program, providing graph data through standard input:
    ```bash
    ./z2 < input.txt
    ```

### Input Format

Both programs expect the graph data in the following format:

```
<graph_type>
<num_vertices> <num_edges>
<v1> <v2>
<v3> <v4>
...
```

*   `<graph_type>`: `D` for directed, `U` for undirected.
*   `<num_vertices>`: The number of vertices in the graph.
*   `<num_edges>`: The number of edges in the graph.
*   `<v1> <v2>`: An edge from vertex `v1` to `v2`.
