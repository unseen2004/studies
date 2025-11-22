# JFFT - Assignment 1: String Searching Algorithms

This directory contains implementations of two string searching algorithms: the Finite Automaton (FA) matcher and the Knuth-Morris-Pratt (KMP) algorithm.

## Programs

### `FA.cpp` - Finite Automaton Matcher

This program builds a finite automaton from a given pattern and uses it to find all occurrences of that pattern in a text file. This implementation ignores all whitespace characters in the input file.

#### How to Run

1.  **Compile:**
    ```bash
    g++ -std=c++17 FA.cpp -o FA
    ```

2.  **Run:**
    ```bash
    ./FA <pattern> <filename>
    ```
    *   `<pattern>`: The string to search for.
    *   `<filename>`: The path to the text file to search within.

### `KMP.cpp` - Knuth-Morris-Pratt Algorithm

This program implements the KMP algorithm to efficiently find all occurrences of a pattern in a text file.

#### How to Run

1.  **Compile:**
    ```bash
    g++ -std=c++17 KMP.cpp -o KMP
    ```

2.  **Run:**
    ```bash
    ./KMP <pattern> <filename>
    ```
    *   `<pattern>`: The string to search for.
    *   `<filename>`: The path to the text file to search within.

## Test Files

*   `test.txt`: A sample text file for testing the algorithms.
*   `cases/`: A directory containing more specific test cases.
