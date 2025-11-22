# KKD - LZW Implementation

This directory contains another C++ implementation of the LZW (Lempel-Ziv-Welch) compression and decompression algorithm.

## Description

This is a command-line tool that uses the LZW algorithm with a variable-width code size to compress and decompress files. It is similar in functionality to the other LZW implementations in this repository but with a different internal implementation.

### The program supports:
*   **Encoding (`encode`):** Compresses a file and prints compression statistics.
*   **Decoding (`decode`):** Decompresses a file to its original state.

## How to Run

You will need a C++ compiler (like `g++`) to build and run this program.

1.  **Compile the program:**
    ```bash
    g++ -std=c++17 -O2 -o lzw lzw.cpp
    ```

2.  **Run the program:**
    *   **To encode a file:**
        ```bash
        ./lzw encode <input_file> <output_file>
        ```
    *   **To decode a file:**
        ```bash
        ./lzw decode <input_file> <output_file>
        ```

## Automated Testing

A shell script `test.sh` is provided to automate the compilation and testing process.

To run the tests:
```bash
bash test.sh
```
The script will compile the program, run it on several test cases (simple text, repetitive text, binary data), verify the output, and then clean up the temporary files.
