# Interactive Yarn Project Reset Utility (`yarn-reset-repo.sh`)

This Bash script provides an interactive and thorough way to clean Yarn (Classic and Modern/Berry) project artifacts recursively, it is especially helpful for monorepos with multiple `node_modules` directories. The script helps in resolving stubborn dependency issues or achieving a completely fresh state by selectively **deleting** `node_modules` directories, `yarn.lock`, Yarn's cache, PnP files, and other build artifacts.

The script prioritizes safety by prompting for confirmation before each deletion.

## Features

* **Interactive Deletion**: Prompts for confirmation before deleting each found artifact, reducing the risk of accidental data loss.
* **Comprehensive Cleaning**: Targets a wide range of common Yarn Classic and Yarn Berry (v2+) artifacts.
* **Recursive `node_modules` Search**: Finds and offers to delete `node_modules` directories anywhere within the project structure (useful for monorepos).
* **User-Friendly Prompts**: Clear yes/no prompts for each action.
* **Initial Guidance**: Suggests trying standard Yarn cleaning commands first, offering an exit path.
* **Customizable Targets**: The list of files and directories to search for can be easily modified within the script.

## Prerequisites

* **Bash**: The script is written for Bash.
* **Standard Unix Utilities**: Requires common commands like `find`, `rm`, `read`, `echo`. These are typically available on any Linux, macOS, or WSL environment. 
* **Project Context**: Designed to be run from the root directory of a Yarn-managed project or monorepo.

## Installation

1. **Download the script**:
    Save the script content as `yarn-reset-repo.sh` (or any other name you prefer) on your system.
      * Example using wget (replace with actual URL when hosted):
    ```bash
      wget https://raw.githubusercontent.com/gabebohlmann/
    ```

1. **Make it executable**:
    ```bash
    chmod +x yarn-reset-repo.sh
    ```

1.  **Place it in your PATH (Optional but Recommended)**:
    For easier access from any project directory, move the script to a directory in your system's `PATH`.
    * Create a bin directory in your home if it doesn't exist
    mkdir -p ~/bin
    * Move the script (you might want to rename it to remove the file extension, e.g., to just 'yarn-reset-repo')
    mv yarn-reset-repo ~/bin 
    * Add ~/bin to your PATH if it's not already there.
    * Add the following line to your shell configuration file (e.g., ~/.bashrc, ~/.zshrc, ~/.profile):
      export PATH="$HOME/bin:$PATH"
      * Copy `export PATH="$HOME/bin:$PATH"` 
      * In termanal nano ~/.bashrc
      * Page to bottom
      * `ctrl+shift+c` to paste
      * `ctrl + O` and `enter` to save and exit
    * Then, source your config file (e.g., in terminal `source ~/.bashrc`) or open a new terminal.

  After this, you can run the script as `yarn-reset-repo` (or whatever you named it) instead of `./yarn-reset-repo`.

## Usage

Navigate to the root directory of your Yarn project/monorepo in your terminal and run the script:

```bash
yarn-reset-repo
```