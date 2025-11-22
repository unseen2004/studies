# KKD - Assignment 1: Entropy Analyzer

This directory contains a Rust program that performs an entropy analysis on a given file.

## Description

The `entropy_analyzer` program reads a file and calculates various statistical and entropy-related metrics. It is useful for understanding the characteristics of a data source, which is a fundamental step in data compression.

### The program calculates and displays:
*   File size and the number of unique symbols (bytes).
*   A frequency and probability table for the most common symbols.
*   **Total Entropy H(Y):** The average information content per symbol.
*   **Conditional Entropy H(Y|X):** The entropy of a symbol given the preceding symbol.
*   **Information Gain (H(Y) - H(Y|X)):** The reduction in uncertainty about a symbol when the previous symbol is known.

## How to Run

To use this program, you will need to have the Rust toolchain (including `rustc`) installed.

1.  **Compile the program:**
    ```bash
    rustc entropy_analyzer.rs -o entropy_analyzer
    ```

2.  **Run the analysis:**
    Provide the path to a file as a command-line argument:
    ```bash
    ./entropy_analyzer <file_to_analyze>
    ```
    For example, to analyze the provided `pan-tadeusz-czyli-ostatni-zajazd-na-litwie.txt` file:
    ```bash
    ./entropy_analyzer "pan-tadeusz-czyli-ostatni-zajazd-na-litwie.txt"
    ```

## Test Files

This directory includes several files for testing:
*   `pan-tadeusz-czyli-ostatni-zajazd-na-litwie.txt`: A large text file.
*   `test1.bin`, `test2.bin`, `test3.bin`: Binary files with different characteristics.
