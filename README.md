---
# Bootutil – Boot Entry Management in Shell

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This project is a shell tool `bootutil`, developed as part of the IOS (Operating Systems) course assignment at FIT VUT in 2025. The author of the project is **Jiří Hroch**. It implements management of boot entries according to a simplified version of the **Boot Loader Specification**.

## Warning
Running as root may affect the system directory `/boot/loader/entries`. It is recommended to test in a safe environment (e.g., a custom test directory) using `./bootutil -b <test_directory>` or by modifying `BOOT_DIR` at the beginning of `bootutil`.

## Assignment
The project was created as part of the IOS 2025 course at FIT VUT. The goal was to develop a tool for managing boot entries in `.conf` files, including commands for listing, removing, duplicating, and setting default boot entries. The full assignment is available at ([HERE](https://jhroch.github.io/IOS_project1_2025/)).

## Command Details
- **`list`:** Displays entries in the format `<title> (<version>, <linux>)`.
  - `-f`: Sorts by file names.
  - `-s`: Sorts by `sort-key` (by file name if no key is present).
  - `-k <kernel_regex>`: Filters by `linux`.
  - `-t <title_regex>`: Filters by `title`.
- **`remove <title-regex>`:** Removes entries based on a regular expression matching `title`.
- **`duplicate [<entry_file_path>]`:** Duplicates an entry (defaults to the default entry if not specified).
  - `-k <kernel_path>`: Sets the kernel path.
  - `-i <initramfs_path>`: Sets the initramfs path.
  - `-t <new_title>`: Changes the title.
  - `-a <cmdline_args>`: Adds arguments to `options`.
  - `-r <cmdline_args>`: Removes arguments from `options`.
  - `-d <destination>`: Specifies the destination file.
  - `--make-default`: Sets as default.
- **`show-default`:** Displays the default entry (non-zero exit code if none exists).
  - `-f`: Shows only the file path.
- **`make-default <entry_file_path>`:** Sets the specified entry as default.

Supports the `-b <boot_entries_dir>` switch to change the default directory (`/boot/loader/entries`).

## Requirements
- Bash (with the `#!/bin/bash` directive).
- Standard UNIX tools: `grep`, `sed`, `sort`, `cut`, `xargs`.
- Tested on Linux (reference IOS VM, user: `ios`, password: `ios-shell`).

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/jhroch/IOS_project1_2025.git
   cd IOS_project1_2025
   ```
2. Ensure the script has executable permissions:
   ```bash
   chmod +x bootutil
   ```

## Usage
```bash
./bootutil [-b <boot_entries_dir>] <command> [arguments]
```

### Examples
- List all entries:
  ```bash
  ./bootutil list
  ```
- Sort by `sort-key`:
  ```bash
  ./bootutil list -s
  ```
- Remove entries with "Fedora" in the title:
  ```bash
  ./bootutil remove "Fedora"
  ```
- Duplicate the default entry with a new title:
  ```bash
  ./bootutil duplicate -t "New Fedora"
  ```
- Display the default entry:
  ```bash
  ./bootutil show-default
  ```

## Implementation Details
- Written in Bash using GNU tools (`sed`, `awk` permitted).
- Kernel command line (`options`) manipulation is handled with `xargs` for proper parsing.
- Sorting is implemented with the `sort` command; filters use `grep -E` for extended regular expressions.
- No temporary files are created outside of `<boot_entries_dir>`.

## Author
- **Jiří Hroch** – FIT VUT student, author of the IOS 2025 project.

## License
This project is distributed under the [GNU General Public License v3.0](LICENSE). See [LICENSE](LICENSE) for more details.

## Notes
- Inspiration: Boot Loader Specification (simplified version for the IOS 2025 assignment).
  
---
