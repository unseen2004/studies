# Java Simple Paint

This directory contains a simple paint application developed using JavaFX.

## Description

This application provides a basic canvas where users can draw and manipulate various shapes.

### Features

*   **Draw Shapes:** Select and draw circles, rectangles, and triangles on the canvas.
*   **Select and Move:** Click on a shape to select it and then drag it to a new position.
*   **Resize:** Use the scroll wheel while a shape is selected to resize it.
*   **Rotate:** Rotate the selected shape by 45-degree increments using the "Obróć" (Rotate) button.
*   **Color Picker:** Right-click on a shape to open a color picker and change its color.
*   **Info Panel:** The "Info" button displays a window with instructions on how to use the application.

## How to Run

This is a Maven project and includes the Maven Wrapper, so you don't need to have Maven installed on your system.

1.  **Build and Run (Linux/macOS):**
    ```bash
    ./mvnw clean javafx:run
    ```
2.  **Build and Run (Windows):**
    ```bash
    .\mvnw.cmd clean javafx:run
    ```

