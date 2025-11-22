# QR Code Queue Management System

This project is a command-line queue management system that uses QR codes to identify and manage participants. It's written in Rust and leverages OpenCV for camera-based QR code scanning.

## Description

This system simulates a real-world queue (like at a doctor's office or a popular restaurant). A user can generate a unique QR code to enter the queue. They can then scan their QR code at any time to see their current position. The system automatically manages the queue, moving the first person out after a set time.

### How It Works

1.  **Generate:** A user runs the `generate` command. This creates a unique ID, embeds it in a QR code, and saves it as a `.png` image file. This is their "ticket".
2.  **Scan:** The user then runs the `scan` command. The application activates the computer's camera.
3.  **Check-in / Status Check:**
    *   If the scanned QR code is new, the user is added to the end of the queue.
    *   If the scanned QR code is already in the queue, the system displays the user's current position.
4.  **Automatic Queue Movement:** The system is designed to automatically remove the person at the front of the queue every 20 seconds, simulating a service being completed.

### Features

*   **Unique QR Code Generation:** Creates unique tickets for each user.
*   **Real-time QR Code Scanning:** Uses OpenCV to access the camera and scan codes.
*   **Automatic Queue Management:** The queue automatically advances.
*   **Status Checking:** Re-scanning a code shows the user's current position.
*   **Interactive CLI:** A simple, text-based interface to interact with the system's functions.

## Prerequisites

This project uses `opencv`, which requires the OpenCV library to be installed on your system.

*   **Windows:**
    1.  Download the latest release from the [OpenCV releases page](https://opencv.org/releases/).
    2.  Set the `OPENCV_DIR` environment variable to the path of your OpenCV build directory (e.g., `C:\opencv\build`).
    3.  Add the `bin` directory (e.g., `C:\opencv\build\x64\vc15\bin`) to your system's `PATH`.

*   **Linux (Ubuntu/Debian):**
    ```bash
    sudo apt-get update
    sudo apt-get install libopencv-dev
    ```

*   **macOS:**
    ```bash
    brew install opencv
    ```

## How to Run

You will also need the Rust toolchain (including `cargo`).

1.  **Build the project:**
    It is recommended to build in release mode for performance.
    ```bash
    cargo build --release
    ```
    The executable will be at `target/release/queue_system`.

2.  **Use the application:**
    The easiest way to use the system is through the interactive mode.

    *   **Run Interactive Mode:**
        ```bash
        cargo run --release -- run
        ```
        This will launch a menu-driven interface where you can generate and scan codes.

    *   **Standalone Commands:**
        You can also use the individual subcommands:

        *   **Generate a QR code:**
            ```bash
            cargo run --release -- generate
            ```
            This will create a `qr_<uuid>.png` file in the project directory.

        *   **Scan a QR code:**
            ```bash
            cargo run --release -- scan
            ```
            This will open your camera. Show it a generated QR code (e.g., on your phone screen).

        *   **Check queue status (from another terminal):**
            ```bash
            cargo run --release -- status
            ```