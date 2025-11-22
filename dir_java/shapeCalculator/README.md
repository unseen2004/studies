# Shape Calculator

This directory contains a command-line Java application for calculating the area and perimeter of various geometric shapes.

## Description

The application takes command-line arguments to determine the type of shape and its dimensions, and then prints the calculated area and perimeter to the console. The shape logic is defined using `enum` types within an abstract class.

### Supported Shapes and Arguments

*   **Circle (Koło):**
    *   Argument: `o <radius>`
*   **Pentagon (Pięciokąt):**
    *   Argument: `p <side_length>`
*   **Hexagon (Sześciokąt):**
    *   Argument: `s <side_length>`
*   **Quadrilaterals (Czworokąty):**
    *   Argument: `c` followed by 5 numbers representing the 4 sides and the angle between the first two sides.
    *   **Square (Kwadrat):** If all sides are equal and the angle is 90 degrees.
    *   **Rectangle (Prostokąt):** If opposite sides are equal and the angle is 90 degrees.
    *   **Rhombus (Romb):** If all sides are equal and the angle is not 90 degrees.

## How to Run

1.  **Compile the code:**
    Navigate to the `src` directory and run:
    ```bash
    javac Main.java
    ```

2.  **Run the application:**
    From the `src` directory, run the `java` command with the desired arguments.

    **Examples:**

    *   **Circle with radius 5:**
        ```bash
        java Main o 5
        ```
    *   **Square with side 4:**
        ```bash
        java Main c 4 4 4 4 90
        ```
    *   **Rectangle with sides 4 and 6:**
        ```bash
        java Main c 4 4 6 6 90
        ```
    *   **Pentagon with side 3:**
        ```bash
        java Main p 3
        ```
