# rust_cli - A CLI Configuration Management Library

This directory contains `rust_cli`, a Rust library designed to provide command-line interface functionality for managing hierarchical key-value configurations, often referred to as a "Projector" tool.

## Description

This library provides a robust framework for building CLI applications that interact with configuration data stored in a hierarchical manner (e.g., based on directory structure). It allows for defining configuration values at different levels of a project's directory tree, with child directories inheriting or overriding values from parent directories.

The core functionality revolves around managing key-value pairs which are stored in a `projector.json` file.

### Key Concepts

*   **Hierarchical Configuration:** Configuration values can be defined at various levels of a directory tree. When a value is requested, the tool looks for it starting from the current directory and moving up to parent directories until a value is found. This allows for project-specific overrides.
*   **Operations:** The library exposes functionalities for common configuration tasks:
    *   **Print:** Retrieve and display a specific configuration value or all values applicable to the current context.
    *   **Add:** Set a new configuration key-value pair for the current directory.
    *   **Remove:** Delete a configuration key-value pair from the current directory.
*   **File Storage:** Configuration data is persisted in a `projector.json` file, typically located in `$XDG_CONFIG_HOME/projector/`.

## How to Use as a Dependency

This project is intended to be used as a library in other Rust applications that require sophisticated CLI configuration management.

1.  **Add to `Cargo.toml`:**
    Include `rust_cli` as a dependency in your project's `Cargo.toml` file:
    ```toml
    [dependencies]
    rust_cli = { path = "/path/to/this/directory" } # Adjust path as necessary
    # Or, if published to crates.io:
    # rust_cli = "x.y.z"
    ```

2.  **Integrate into your application:**
    You can use the `Opts`, `Config`, and `Projector` modules to build your CLI application.
    An example `main.rs` might look like this:
    ```rust
    use anyhow::Result;
    use clap::Parser;
    use rust_cli::{Opts, Config, Projector, Operation}; // Import necessary components

    fn main() -> Result<()> {
        let opts = Opts::parse();
        let config_data = Config::try_from(opts)?;
        let mut projector = Projector::from_config(config_data.config, config_data.pwd);

        match config_data.operation {
            Operation::Print(key) => {
                if let Some(k) = key {
                    if let Some(val) = projector.get_value(&k) {
                        println!("{}", val);
                    } else {
                        println!("Key '{}' not found.", k);
                    }
                } else {
                    for (key, val) in projector.get_value_all() {
                        println!("{} = {}", key, val);
                    }
                }
            },
            Operation::Add(key, value) => {
                projector.set_value(key, value);
                projector.save()?;
                println!("Added/Updated configuration.");
            },
            Operation::Remove(key) => {
                projector.remove_value(&key);
                projector.save()?;
                println!("Removed configuration.");
            },
        }

        Ok(())
    }
    ```

3.  **Build and Run (your application):**
    Once integrated, you would build and run your application using `cargo`:
    ```bash
    cargo build --release
    ./target/release/your_app_name --help
    ./target/release/your_app_name add my_key my_value
    ./target/release/your_app_name my_key
    ```
