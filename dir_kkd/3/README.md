# KKD - Assignment 3: LZW Compressor

This directory contains a C++ implementation of the LZW (Lempel-Ziv-Welch) compression and decompression algorithm, which can be combined with various universal coding schemes.

## Description

This program uses the LZW algorithm to compress and decompress files. The output codes from the LZW algorithm are then encoded using one of four selectable universal coding methods.

### Features
*   **LZW Compression:** The core dictionary-based compression algorithm.
*   **Universal Codings:** The program supports the following methods for encoding the LZW output stream:
    *   `gamma`: Elias Gamma coding
    *   `delta`: Elias Delta coding
    *   `omega`: Elias Omega coding (default)
    *   `fibonacci`: Fibonacci coding
*   **Statistics:** During encoding, the program outputs statistics, including file sizes, compression ratio, and entropy of the input and output.

## How to Run

This is a CMake project. To build and run it, you'll need a C++ compiler (like `g++`) and CMake.

1.  **Configure and Build:**
    ```bash
    mkdir -p build
    cd build
    cmake ..
    make
    ```

2.  **Run the program:**
    The executable `lzw_compressor` will be created in the `build` directory.

    *   **To encode a file:**
        ```bash
        ./lzw_compressor encode <input_file> <output_file> [coding_type]
        ```
        The `coding_type` is optional and defaults to `omega`.
        Example:
        ```bash
        ./lzw_compressor encode ../tests/test1.bin test1.lzw.gamma gamma
        ```

    *   **To decode a file:**
        ```bash
        ./lzw_compressor decode <input_file> <output_file> [coding_type]
        ```
        You must use the same `coding_type` that was used for encoding.
        Example:
        ```bash
        ./lzw_compressor decode test1.lzw.gamma test1.decoded.bin gamma
        ```
