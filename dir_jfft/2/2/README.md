# JFFT - Assignment 2, Part 2: Python Comment Remover

This directory contains a lexical analyzer built with Flex that removes comments and multi-line string literals from Python source code.

## Description

The program reads a Python file (`.py`), removes all single-line comments (starting with `#`) and the content of multi-line strings (enclosed in `"""` or `'''`), and then prints the cleaned code to the standard output. Newlines within the multi-line strings are preserved to maintain the original line count.

## How to Run

To use this program, you will need to have `flex` and a C compiler (like `gcc`) installed.

1.  **Generate the C code from the Flex file:**
    ```bash
    flex -o zadanie2.c zadanie2.l
    ```

2.  **Compile the generated C code:**
    ```bash
    gcc zadanie2.c -o zadanie2 -lfl
    ```
    *Note: The `-lfl` flag may be required on some systems to link the Flex library.*

3.  **Run the program:**
    Provide the path to a Python file as a command-line argument:
    ```bash
    ./zadanie2 <python_file.py>
    ```
    If you run it without an argument, it will read from standard input.

## Test Files

*   `test2.py`: An input Python file for testing.
*   `test2_out.py`: The corresponding expected output file after comment removal.
