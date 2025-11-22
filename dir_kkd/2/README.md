# KKD - Assignment 2: Arithmetic Coder

This directory contains a C++ implementation of an adaptive arithmetic coder and decoder.

## Description

This program uses an adaptive model and arithmetic coding to compress and decompress files. The adaptive model, implemented using a Fenwick tree (Binary Indexed Tree), dynamically adjusts symbol probabilities based on the input data, which generally leads to better compression for files with non-uniform data distributions.

### The program supports two modes:
*   **Compression (`-c`):** Encodes a file, reducing its size. It also prints statistics like the model's entropy and the resulting compression ratio.
*   **Decompression (`-d`):** Decodes a previously compressed file, restoring it to its original state.

## How to Run

To use this program, you will need a C++ compiler that supports C++11 or later (like `g++`).

1.  **Compile the program:**
    ```bash
    g++ -std=c++11 arithmetic_coder.cpp -o coder
    ```

2.  **Run the program:**
    The program takes three arguments: the mode (`-c` or `-d`), the input file, and the output file.

    *   **To compress a file:**
        ```bash
        ./coder -c <input_file> <compressed_output_file>
        ```
        Example:
        ```bash
        ./coder -c pan-tadeusz-czyli-ostatni-zajazd-na-litwie.txt pt.compressed
        ```

    *   **To decompress a file:**
        ```bash
        ./coder -d <compressed_input_file> <decompressed_output_file>
        ```
        Example:
        ```bash
        ./coder -d pt.compressed pt.decompressed.txt
        ```

## Test Files

This directory includes several files for testing compression and decompression:
*   `pan-tadeusz-czyli-ostatni-zajazd-na-litwie.txt`
*   `test1.bin`, `test2.bin`, `test3.bin`

The `.compressed` and `.decompressed.bin`/`.decompressed.txt` files are examples of the output you can expect.
