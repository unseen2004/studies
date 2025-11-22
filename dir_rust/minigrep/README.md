# minigrep

This project is a simplified, command-line text-searching tool, similar to `grep`, written in Rust. It is based on the project from the official "The Rust Programming Language" book.

## Description

`minigrep` searches for a given string (the "query") within a specified text file and prints all the lines that contain the query.

### Features

*   Searches for a query string in a file.
*   Case-sensitive search by default.
*   Case-insensitive search can be enabled by setting an environment variable.

## How to Run

To run this program, you will need to have the Rust toolchain (including `cargo`) installed.

1.  **Clone and navigate to the directory:**
    If you haven't already, navigate into the `minigrep` directory.

2.  **Run with `cargo`:**
    You can run the program using `cargo run`, followed by the query and the filename.
    ```bash
    cargo run -- <query> <filename>
    ```

    **Example:**
    There is a sample `poem.txt` file in the `src` directory.
    ```bash
    cargo run -- body src/poem.txt
    ```
    This will output:
    ```
    I'm nobody! Who are you?
    Are you nobody, too?
    How dreary to be somebody!
    ```

3.  **Case-Insensitive Search:**
    To perform a case-insensitive search, set the `IGNORE_CASE` environment variable to any value.

    *   **Linux/macOS:**
        ```bash
        IGNORE_CASE=1 cargo run -- to src/poem.txt
        ```
    *   **Windows (PowerShell):**
        ```powershell
        $env:IGNORE_CASE=1; cargo run -- to src/poem.txt
        ```
        *Note: To unset the variable in PowerShell, use `Remove-Item Env:IGNORE_CASE`.*

## Testing

The project includes unit tests for the search logic. You can run them with:
```bash
cargo test
```
