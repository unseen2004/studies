# Simple Client-Server Application with a Binary Search Tree

This directory contains a simple multi-threaded client-server application that allows clients to interact with a binary search tree (BST) on the server.

## Description

The application consists of three main parts:

*   **`Server.java`**: A multi-threaded server that listens for client connections on port 4444. For each client, it spawns a new thread to handle communication.
*   **`Threat.java`**: (Note: There is a typo in the filename; it should likely be `Thread.java`). This class handles the logic for a single client connection. It receives commands from the client to manipulate a BST.
*   **`client.java`**: A simple command-line client that connects to the server and allows the user to send commands.
*   **`Tree.java`**: A generic implementation of a binary search tree that supports `insert`, `delete`, `search`, and `draw` operations.

### Commands

The client can send the following commands to the server:

*   `type <type>`: Sets the data type of the tree. Supported types are `Integer`, `Double`, and `String`.
*   `insert <value>`: Inserts a value into the tree.
*   `delete <value>`: Deletes a value from the tree.
*   `search <value>`: Searches for a value in the tree.
*   `draw`: Prints a string representation of the tree.
*   `bye`: Disconnects the client from the server.

## How to Run

1.  **Compile the code:**
    Open a terminal in the `server` directory and compile all the Java files:
    ```bash
    javac *.java
    ```

2.  **Run the Server:**
    In the same terminal, start the server:
    ```bash
    java Server
    ```
    The server will then be listening for connections on port 4444.

3.  **Run the Client:**
    Open a *new* terminal and run the client:
    ```bash
    java Client
    ```
    You can then start sending commands to the server from the client's console.
