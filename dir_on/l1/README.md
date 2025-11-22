# ON - Lab 1: Introduction to Numerical Calculations in Julia

This directory contains Julia scripts that solve the problems for the first lab of the "Numerical Calculations" course.

## Description

The scripts explore the properties of floating-point arithmetic in Julia. Each `.jl` file corresponds to a different problem in the lab assignment.

For example, `z1.jl` is a script that experimentally determines and prints a comparison of key floating-point characteristics:
*   Machine Epsilon (`macheps`)
*   The smallest positive number (`eta`)
*   The maximum finite number (`MAX`)

It performs these calculations for `Float16`, `Float32`, and `Float64` types and compares the results with Julia's built-in functions and standard C constants.

The other `z*.jl` files solve different numerical problems as part of the same lab.

## How to Run

To run any of the scripts, you will need to have the [Julia language](https://julialang.org/downloads/) installed.

You can execute a script from your terminal using the `julia` command:

```bash
julia <script_name.jl>
```

**Example:**
```bash
julia z1.jl
```

The output of each script is also saved in the corresponding `.txt` file (e.g., `z1.txt`).
