# Shell Scripts

This directory contains various utility scripts written in Bash.

## Scripts

### `lowercase.sh` - Rename Files to Lowercase

This script renames all files within a specified directory to their lowercase equivalents. It takes the target directory as a command-line argument.

#### How to Run

1.  Make the script executable:
    ```bash
    chmod +x lowercase.sh
    ```
2.  Run the script with the target directory:
    ```bash
    ./lowercase.sh /path/to/your/directory
    ```

### `maze.sh` - Terminal Maze Game

This script generates a maze in the terminal using a randomized Depth-First Search (DFS) algorithm and allows the user to navigate through it using arrow keys.

#### How to Run

1.  Make the script executable:
    ```bash
    chmod +x maze.sh
    ```
2.  Run the script:
    ```bash
    ./maze.sh
    ```
    Use arrow keys to move. Press `q` to quit.

### `psaux.sh` - Custom Process Monitor

A custom implementation of a process information utility similar to `ps aux`. It lists details for all running processes by reading from the `/proc` filesystem.

#### How to Run

1.  Make the script executable:
    ```bash
    chmod +x psaux.sh
    ```
2.  Run the script:
    ```bash
    ./psaux.sh
    ```

### `systemInfo.sh` - Real-time System Information Dashboard

This script provides a real-time, refreshing display of various system statistics directly in your terminal, including network usage, CPU utilization, uptime, battery status, system load, and memory usage.

#### How to Run

1.  Make the script executable:
    ```bash
    chmod +x systemInfo.sh
    ```
2.  Run the script:
    ```bash
    ./systemInfo.sh
    ```
    Press `Ctrl+C` to exit.

### `useAPI.sh` - API Interaction Examples

This script demonstrates how to fetch data from external web APIs using `curl` and process JSON responses with `jq`. It fetches a random cat image and a random Chuck Norris joke. It attempts to display the cat image in the terminal using `catimg` or `img2txt` if available.

#### How to Run

1.  Make the script executable:
    ```bash
    chmod +x useAPI.sh
    ```
2.  Ensure `curl` and `jq` are installed:
    ```bash
    sudo apt-get install curl jq # On Debian/Ubuntu
    # or
    brew install curl jq # On macOS
    ```
3.  (Optional) Install `catimg` or `img2txt` to display images in the terminal.
4.  Run the script:
    ```bash
    ./useAPI.sh
    ```
