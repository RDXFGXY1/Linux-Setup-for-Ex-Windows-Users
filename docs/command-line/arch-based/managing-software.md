# Managing Software on Arch-Based Systems with `pacman`

On Arch-based distributions like Arch Linux, Garuda, and EndeavourOS, the primary command-line tool for managing software is `pacman`. It's known for its speed and simplicity.

You will also frequently interact with an **AUR Helper** like `yay` to install software from the Arch User Repository. This guide covers `pacman` for official packages.

## Basic `pacman` Commands

All `pacman` commands must be run with `sudo` because they modify system files.

### 1. Synchronize and Update the System

This is the most common command you will use. It synchronizes your local package database with the server and then applies all available upgrades.

```bash
sudo pacman -Syu
```
*   `-S`: **S**ynchronize packages.
*   `-y`: Refresh local package lists from the server.
*   `-u`: **U**pgrade all out-of-date packages.

It's recommended to run this command regularly to keep your system up-to-date.

### 2. Install a Package

To install a new package from the official repositories:

```bash
sudo pacman -S <package_name>
```
For example, to install the `htop` process manager:
```bash
sudo pacman -S htop
```

You can install multiple packages at once:
```bash
sudo pacman -S htop neofetch
```

### 3. Remove a Package

To uninstall a package:

```bash
sudo pacman -R <package_name>
```
However, it's often better to use the `-Rns` flag, which removes the package, its dependencies that are no longer needed, and its system-wide configuration files.

```bash
sudo pacman -Rns <package_name>
```
*   `-R`: **R**emove package.
*   `-n`: **n**o-save, removes configuration files.
*   `-s`: recur**s**ive, removes unneeded dependencies.

### 4. Search for a Package

If you're not sure of the exact name of a package, you can search for it.

```bash
sudo pacman -Ss <search_term>
```
For example, to search for packages related to "browser":
```bash
sudo pacman -Ss browser
```

### 5. Query Installed Packages

To see if a specific package is installed and check its version:

```bash
sudo pacman -Q <package_name>
```

To list all explicitly installed packages:
```bash
sudo pacman -Qe
```
This is useful for seeing what you have installed yourself, versus dependencies that were pulled in automatically.
