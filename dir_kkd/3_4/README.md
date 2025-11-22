# KKD - Assignment 3 & 4: LZW Implementations (C++ and Python)

This directory contains two implementations of the LZW (Lempel-Ziv-Welch) compression algorithm: one in C++ and one in Python.

## Description

Both programs implement the LZW algorithm with a variable-width code size. The dictionary is initialized with all single-byte values, and the width of the output codes increases dynamically as more entries are added to the dictionary.

Both versions support encoding (compression) and decoding (decompression) and print statistics about the compression process.

## C++ Implementation (`lzw.cpp`)

### How to Run

This is a CMake project. To build and run it, you'll need a C++ compiler (like `g++`) and CMake.

1.  **Configure and Build:**
    ```bash
    mkdir -p build
    cd build
    cmake ..
    make
    ```

2.  **Run the program:**
    The executable `lzw` will be created in the `build` directory.

    *   **To encode a file:**
        ```bash
        ./lzw encode <input_file> <output_file>
        ```
    *   **To decode a file:**
        ```bash
        ./lzw decode <input_file> <output_file>
        ```

## Python Implementation (`lzw.py`)

### How to Run

You can run the Python script directly using a Python 3 interpreter.

*   **To encode a file:**
    ```bash
    python3 lzw.py encode <input_file> <output_file>
    ```
*   **To decode a file:**
    ```bash
    python3 lzw.py decode <input_file> <output_file>
    ```

## Test Files

The `test1.lzw`, `test2.lzw`, `test1.decoded.bin`, and `test2.decoded.bin` files are provided for testing purposes.
