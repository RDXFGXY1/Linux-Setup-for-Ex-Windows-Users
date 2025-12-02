# Managing Software on Debian-Based Systems with `apt`

On Debian-based distributions like Debian, Ubuntu, Kali Linux, and Linux Mint, the standard command-line tool for managing software is `apt` (Advanced Package Tool).

## Basic `apt` Commands

All `apt` commands that install, remove, or update packages must be run with `sudo`.

### 1. Update the System

Updating the system is a two-step process.

First, you must resynchronize the package index files from their sources. This fetches the latest list of available packages.
```bash
sudo apt update
```

Second, you upgrade the installed packages to their new versions.
```bash
sudo apt upgrade
```

You can combine these into a single command:
```bash
sudo apt update && sudo apt upgrade
```

### 2. Install a Package

To install a new package from the repositories:

```bash
sudo apt install <package_name>
```
For example, to install the `htop` process manager:
```bash
sudo apt install htop
```

You can install multiple packages at once:
```bash
sudo apt install htop neofetch
```

### 3. Remove a Package

To uninstall a package:

```bash
sudo apt remove <package_name>
```
This removes the package but leaves its configuration files behind. If you want to remove the package and all its configuration files, use `purge`:
```bash
sudo apt purge <package_name>
```

To automatically remove dependencies that are no longer needed by any installed package, use `autoremove`:
```bash
sudo apt autoremove
```

### 4. Search for a Package

If you're not sure of the exact name of a package, you can search for it in the repositories.

```bash
apt search <search_term>
```
For example, to search for packages related to "browser":
```bash
apt search browser
```

### 5. View Package Information

To see details about a package, such as its version, dependencies, and a description:

```bash
apt show <package_name>
```
This is useful for checking what a package is before you install it.
