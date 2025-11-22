# Simple GUI Application

This directory contains a simple Java Swing application that provides a graphical interface for running an external command.

## Description

The application consists of a text field, a "run" button, and a text area. When the user enters a command in the text field and clicks "run", the application executes an external program named `program.exe` (which is expected to be in the `src` directory) with the provided text as command-line arguments. The standard output of the executed program is then displayed in the text area.

**Note:** The `program.exe` file is not included in this repository. You will need to provide your own executable with that name in the `src` directory for the application to work correctly.

## How to Run

1.  Place your executable file named `program.exe` in the `src` directory.
2.  Compile the Java code:
    ```bash
    javac src/Main.java
    ```
3.  Run the application:
    ```bash
    java -cp src Main
    ```
