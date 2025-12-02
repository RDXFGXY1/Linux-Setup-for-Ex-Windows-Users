# Managing Software on Fedora-Based Systems with `dnf`

On Fedora-based distributions, the command-line tool for managing software is `dnf` (Dandified YUM). It is the successor to `yum`.

## Basic `dnf` Commands

All `dnf` commands that install, remove, or update packages must be run with `sudo`.

### 1. Update the System

`dnf` can check for updates and apply them with a single command.

```bash
sudo dnf upgrade
```
You can also add `--refresh` to force it to update the metadata from the repositories first:
```bash
sudo dnf upgrade --refresh
```

### 2. Install a Package

To install a new package from the repositories:

```bash
sudo dnf install <package_name>
```
For example, to install the `htop` process manager:
```bash
sudo dnf install htop
```

You can install multiple packages at once:
```bash
sudo dnf install htop neofetch
```

### 3. Remove a Package

To uninstall a package:

```bash
sudo dnf remove <package_name>
```
To automatically remove dependencies that are no longer needed, you can run:
```bash
sudo dnf autoremove
```

### 4. Search for a Package

If you're not sure of the exact name of a package, you can search for it in the repositories.

```bash
dnf search <search_term>
```
For example, to search for packages related to "browser":
```bash
dnf search browser
```

### 5. View Package Information

To see details about a package, such as its version, architecture, and a description:

```bash
dnf info <package_name>
```

To list all explicitly installed packages (that were not installed as dependencies):
```bash
dnf repoquery --userinstalled
```
