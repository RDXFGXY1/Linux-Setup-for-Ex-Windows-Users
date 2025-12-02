# Managing Software on SUSE-Based Systems with `zypper`

On SUSE-based distributions like openSUSE Leap and Tumbleweed, the powerful command-line tool for managing software is `zypper`.

## Basic `zypper` Commands

All `zypper` commands that install, remove, or update packages must be run with `sudo`.

### 1. Update the System

First, it's good practice to refresh the list of packages from the repositories.
```bash
sudo zypper refresh
```

Then, to apply available updates, run:
```bash
sudo zypper update
```
You can also combine these into a single command:
```bash
sudo zypper refresh && sudo zypper update
```
In `zypper`, you can also use shorthand. `ref` for `refresh` and `up` for `update`.
```bash
sudo zypper ref && sudo zypper up
```

### 2. Install a Package

To install a new package from the repositories:

```bash
sudo zypper install <package_name>
```
Or using the shorthand `in`:
```bash
sudo zypper in htop
```

You can install multiple packages at once:
```bash
sudo zypper in htop neofetch
```

### 3. Remove a Package

To uninstall a package:

```bash
sudo zypper remove <package_name>
```
Or using the shorthand `rm`:
```bash
sudo zypper rm htop
```
To remove a package along with its unneeded dependencies:
```bash
sudo zypper rm -u <package_name>
```

### 4. Search for a Package

If you're not sure of the exact name of a package, you can search for it in the repositories.

```bash
zypper search <search_term>
```
Or using the shorthand `se`:
```bash
zypper se browser
```

### 5. View Package Information

To see details about a package, such as its version, dependencies, and vendor:

```bash
zypper info <package_name>
```
