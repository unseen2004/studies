# JFFT - Assignment 2, Part 3: C/C++ Comment Remover

This directory contains a lexical analyzer built with Flex that removes comments from C-style source code (like C, C++, Java).

## Description

The program reads source code from a file or standard input and removes single-line (`//`) and multi-line (`/* ... */`) comments. It can optionally preserve Doxygen-style documentation comments.

### Features

*   Removes `//` and `/* ... */` comments.
*   Preserves newlines from multi-line comments to maintain line numbering.
*   Optionally keeps Doxygen comments (`/** ... */`, `/*! ... */`, `///`, `//!`) if the `--doxygen` flag is used.

## How to Run

To use this program, you will need to have `flex` and a C compiler (like `gcc`) installed.

1.  **Generate the C code from the Flex file:**
    ```bash
    flex -o comment_remover.c comment_remover.l
    ```

2.  **Compile the generated C code:**
    ```bash
    gcc comment_remover.c -o comment_remover -lfl
    ```
    *Note: The `-lfl` flag may be required on some systems to link the Flex library.*

3.  **Run the program:**
    *   **To remove all comments:**
        ```bash
        ./comment_remover <source_code_file>
        ```
    *   **To keep Doxygen comments:**
        ```bash
        ./comment_remover --doxygen <source_code_file>
        ```
    If you run it without a file argument, it will read from standard input.

## Test File

*   `test3.cpp`: A C++ file with various types of comments for testing.
