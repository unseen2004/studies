# Balls and Bins Simulation

This project is a C++ simulation of the classic "balls and bins" problem from probability theory.

## Description

The "balls and bins" problem is a fundamental concept in computer science and probability that models various scenarios, including hashing, load balancing, and resource allocation. This program simulates the process of randomly throwing `n` balls into `n` bins and analyzes the resulting distribution.

The simulation likely investigates properties such as:
*   The maximum number of balls in any single bin (maximum load).
*   The number of empty bins.
*   The distribution of balls across the bins.

The project appears to use C++ for the simulation and may leverage Python (specifically NumPy and Matplotlib, given the CMake configuration) to generate plots and visualize the results. The `results_plots.pdf` file likely contains examples of such visualizations.

## How to Run

This is a CMake project. To build and run it, you will need a C++ compiler, CMake, and the Python 3 development libraries (including NumPy).

1.  **Prerequisites:**
    *   Install CMake.
    *   Install a C++ compiler (like `g++`).
    *   Install Python 3, including the development headers (`python3-dev` on Debian/Ubuntu).
    *   Install NumPy (`pip install numpy`).

2.  **Configure and Build:**
    Assuming the source files (`main.cpp`, `experiment.cpp`, etc.) are located in the project's root directory:
    ```bash
    mkdir -p build
    cd build
    cmake ..
    make
    ```

3.  **Run the simulation:**
    The executable `BallsAndBins` will be created in the `build` directory.
    ```bash
    ./BallsAndBins
    ```
    The program may take some time to run the simulations and generate results. Check the `results.txt` file and the `results_plots.pdf` for the output.
