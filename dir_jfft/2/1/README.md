# JFFT - Assignment 2, Part 1: Word and Line Counter

This directory contains a lexical analyzer, built with Flex, that counts words and lines in a text file.

## Description

The program reads an input text file, processes it according to a set of rules, and outputs a formatted version of the text. At the end, it prints a summary of the total number of lines and words found.

The formatting rules are:
*   Multiple spaces and tabs are collapsed into a single space.
*   Leading and trailing whitespace on each line is removed.
*   Empty lines are preserved.

## How to Run

To use this program, you will need to have `flex` and a C compiler (like `gcc`) installed.

1.  **Generate the C code from the Flex file:**
    ```bash
    flex -o zadanie1.c zadanie1.l
    ```

2.  **Compile the generated C code:**
    ```bash
    gcc zadanie1.c -o zadanie1 -lfl
    ```
    *Note: The `-lfl` flag may be required on some systems to link the Flex library.*

3.  **Run the program:**
    You can run the program on a text file by providing the filename as a command-line argument:
    ```bash
    ./zadanie1 <input_file.txt>
    ```
    If you run it without an argument, it will read from standard input.

## Test Files

*   `test1.txt`, `my_test1.txt`: Input files for testing.
*   `test1_out.txt`, `my_test1_out.txt`: Corresponding expected output files.
