# Monte Carlo Simulations

This project contains a C++ program that uses the Monte Carlo method to perform numerical integration and to approximate the value of Pi.

## Description

The program implements two main types of Monte Carlo simulations:

1.  **Numerical Integration:**
    It approximates the definite integrals of three different functions:
    *   `f(x) = x^(1/3)` from 0 to 8
    *   `f(x) = sin(x)` from 0 to π
    *   `f(x) = 4x(1-x)^3` from 0 to 1

2.  **Pi Estimation:**
    It uses the classic "dartboard" method of randomly sampling points in a square to approximate the value of Pi.

For each simulation, the program runs multiple trials with an increasing number of sample points. It then uses the `matplotlib-cpp` library to generate scatter plots that visualize:
*   The result of each individual simulation run.
*   The average result for each set of trials.
*   A line representing the exact, known value for comparison.

## How to Run

This is a CMake project and requires a C++ compiler, CMake, and Python 3 with its development libraries to be installed.

1.  **Prerequisites:**
    *   Install CMake.
    *   Install a C++ compiler (like `g++`).
    *   Install Python 3, including the development headers (`python3-dev` on Debian/Ubuntu).
    *   Install NumPy and Matplotlib (`pip install numpy matplotlib`).

2.  **Configure and Build:**
    ```bash
    mkdir -p build
    cd build
    cmake ..
    make
    ```

3.  **Run the simulation:**
    The executable `MonteCarlo` will be created in the `build` directory.
    ```bash
    ./MonteCarlo
    ```
    The program will run the simulations and open several plot windows to display the results for each experiment.
