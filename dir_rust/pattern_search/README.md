# rgrep - A Rust-powered `grep` Clone

This directory contains `rgrep`, a fast and feature-rich command-line text searching tool, similar to `grep`, written in idiomatic Rust.

## Description

`rgrep` searches for a given pattern in one or more files and prints the lines that contain a match. It is built using the `clap` crate for robust command-line argument parsing and includes several features common to modern `grep` implementations.

### Features

*   Search for a pattern in multiple files.
*   **Case-Insensitive Search:** Use the `-i` or `--ignore-case` flag.
*   **Inverted Match:** Use the `--invert-match` flag to print lines that *do not* match the pattern.
*   **Line Numbers:** Use the `-n` or `--line-number` flag to prepend line numbers to the output.
*   **Count Matches:** Use the `-c` or `--count` flag to print only the total number of matching lines.
*   **JSON Output:** Use the `--json` flag to get the output in a structured JSON format.
*   **Verbose Logging:** Increase logging verbosity with `-v`, `-vv`, etc.

## How to Run

To run this program, you will need to have the Rust toolchain (including `cargo`) installed.

1.  **Build the project:**
    It's recommended to build the project in release mode for better performance.
    ```bash
    cargo build --release
    ```
    The executable will be located at `target/release/rgrep`.

2.  **Run the program:**
    ```bash
    ./target/release/rgrep <pattern> <file1> [file2] [...] [options]
    ```

### Examples

Let's assume you have a file named `example.txt` with the following content:
```
Hello World
hello rust
Goodbye
```

*   **Simple search:**
    ```bash
    ./target/release/rgrep Hello example.txt
    # Output: Hello World
    ```

*   **Case-insensitive search:**
    ```bash
    ./target/release/rgrep -i hello example.txt
    # Output:
    # Hello World
    # hello rust
    ```

*   **Inverted match with line numbers:**
    ```bash
    ./target/release/rgrep --invert-match -n hello example.txt
    # Output: 3:Goodbye
    ```

*   **Count matches:**
    ```bash
    ./target/release/rgrep -c hello example.txt
    # Output: 2
    ```

*   **JSON output:**
    ```bash
    ./target/release/rgrep --json -n hello example.txt
    # Output:
    # {"path":"example.txt","lines":[{"line_number":1,"text":"Hello World"},{"line_number":2,"text":"hello rust"}]}
    ```

## Testing

The project includes a suite of integration tests. You can run them with:
```bash
cargo test
```
