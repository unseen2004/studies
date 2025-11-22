# JFFT - Assignment 2, Part 4: RPN Calculator

This directory contains a simple Reverse Polish Notation (RPN) calculator built with Flex.

## Description

This program functions as a stack-based RPN calculator. It reads expressions from standard input, processes them, and prints the result.

### Supported Operations

*   `+` : Addition
*   `-` : Subtraction
*   `*` : Multiplication
*   `/` : Division
*   `%` : Modulo
*   `^` : Power

### Error Handling

The calculator includes basic error handling for:
*   Division by zero
*   Stack overflow or underflow (too many numbers or operators)
*   Invalid characters in the input
*   Integer overflow during exponentiation

## How to Run

To use this program, you will need to have `flex` and a C compiler (like `gcc`) installed.

1.  **Generate the C code from the Flex file:**
    ```bash
    flex -o zadanie4.c zadanie4.l
    ```

2.  **Compile the generated C code:**
    ```bash
    gcc zadanie4.c -o zadanie4 -lfl
    ```
    *Note: The `-lfl` flag may be required on some systems to link the Flex library.*

3.  **Run the program:**
    ```bash
    ./zadanie4
    ```
    The calculator will then wait for you to enter RPN expressions. Enter one expression per line.

    **Example:**
    ```
    10 5 +
    = 15
    2 3 * 4 +
    = 10
    5 2 ^
    = 25
    ```
    Press `Ctrl+D` to exit.
