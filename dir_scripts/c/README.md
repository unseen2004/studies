# C Scripts

This directory contains various utility scripts and examples written in C, primarily demonstrating concepts in system programming.

## Scripts

### `colors.c` - Terminal Color Test

This script attempts to detect the number of colors supported by the terminal and then prints "Hello, World!" in each of those colors.

#### How to Run

1.  **Compile:**
    ```bash
    gcc colors.c -o colors
    ```
2.  **Run:**
    ```bash
    ./colors
    ```

### `lsh.c` - Simple Shell

A basic shell implementation ("lsh" - "lazy shell") that supports executing external commands, built-in `cd` and `exit` commands, input/output/error redirection, piping, and basic signal handling.

#### How to Run

1.  **Compile:**
    ```bash
    gcc lsh.c -o lsh
    ```
2.  **Run:**
    ```bash
    ./lsh
    ```
    You can then type commands at the `lsh> ` prompt.

### `pipeChange.c` - stdout Redirection with ptrace

This program demonstrates how to redirect the standard output (`stdout`) of a *running* process to a specified file. It uses `ptrace` for process control and `dup2` for file descriptor manipulation.

#### How to Run

1.  **Compile:**
    ```bash
    gcc pipeChange.c -o pipeChange
    ```
2.  **Run:**
    First, start a target process (e.g., `sleep 1000 &` to get its PID). Then run `pipeChange` with the target process's PID and the desired output file:
    ```bash
    # In one terminal:
    ./my_program_that_prints > /dev/null & # Or any program you want to redirect
    PID=$! # Get the PID of the background process

    # In another terminal:
    ./pipeChange $PID output.txt
    ```

### `rootBash.c` - Setuid Shell Example

This program is a simple example of a "setuid" program. It attempts to gain root privileges (`setuid(0)`) and then execute `/bin/bash`. This serves as a demonstration of how setuid programs work, which can be a significant security concern if not implemented correctly.

#### How to Run (Caution!)

**WARNING: Running this program as root (e.g., `sudo ./rootBash`) or making it a setuid executable (`sudo chown root rootBash && sudo chmod u+s rootBash`) can give you a root shell. Use with extreme caution and understanding of security implications.**

1.  **Compile:**
    ```bash
    gcc rootBash.c -o rootBash
    ```
2.  **Run (as unprivileged user, it will likely fail):**
    ```bash
    ./rootBash
    ```
3.  **Run (as root, or after making it setuid root):**
    ```bash
    sudo ./rootBash
    ```
    This should open a root shell.

### `signals.c` - Basic Signal Handling

This program demonstrates basic signal handling in C. It registers a handler for most standard signals (excluding `SIGKILL` and `SIGSTOP`) and prints a message when any of these signals are received.

#### How to Run

1.  **Compile:**
    ```bash
    gcc signals.c -o signals
    ```
2.  **Run:**
    ```bash
    ./signals &
    PID=$! # Get the PID
    kill -USR1 $PID # Send a signal
    kill -TERM $PID # Send another signal
    kill -KILL $PID # This one cannot be caught
    ```

### `signals2.c` - Advanced Signal Handling with `sigaction`

This program provides a more robust example of signal handling using the `sigaction` system call. It specifically handles `SIGUSR1`, increments a counter, prints its value, and then sleeps for a few seconds within the handler. This illustrates how `sigaction` can be used for more controlled signal responses and the implications of blocking within a signal handler.

#### How to Run

1.  **Compile:**
    ```bash
    gcc signals2.c -o signals2
    ```
2.  **Run:**
    ```bash
    ./signals2 &
    PID=$! # Get the PID
    kill -USR1 $PID # Send SIGUSR1
    kill -USR1 $PID # Send another SIGUSR1 while the handler is sleeping
    fg # Bring the process to foreground to observe output
    ```
