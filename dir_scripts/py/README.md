# Python Scripts

This directory contains utility scripts written in Python.

## `combine_files.py` - File Combiner

This script recursively traverses a specified input directory, reads all text-based files, and concatenates their content into a single output file. It automatically adds a comment header for each included file, indicating its relative path and using a comment style appropriate for the file's extension (e.g., `//` for C++, `#` for Python, `<!--` for HTML). Binary files are automatically skipped.

### How to Run

To run this script, you will need a Python 3 interpreter.

```bash
python3 combine_files.py <input_directory> [output_file]
```

*   `<input_directory>`: The directory to traverse and combine files from.
*   `[output_file]`: (Optional) The name of the output file. If not provided, it defaults to `combined_files.txt`.

**Example:**

To combine all files in the current directory (`.`) into `all_code.txt`:
```bash
python3 combine_files.py . all_code.txt
```
