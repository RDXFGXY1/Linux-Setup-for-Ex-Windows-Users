# `orion` - A Simple, Modular Package Updater

`orion` is a command-line tool for updating self-contained applications that don't come from your system's main package manager (e.g., applications installed from `.tar.gz` files).

It uses a modular architecture, where each application has its own update script.

## Installation

To install `orion`, run the folloing command:

```bash
curl -fsSL https://raw.githubusercontent.com/RDXFGXY1/Linux-Setup-for-Ex-Windows-Users/main/Scripts/Orion/install.sh | bash
```

This will install the `orion` command to `/usr/local/bin/orion` and its modules to `/usr/local/lib/orion/modules`.

## Uninstallation

To uninstall `orion`, run the `uninstall.sh` script:

```bash
sudo ./uninstall.sh
```

## Usage

### List Available Packages

To see which applications can be updated with `orion`, use the `-l` or `--list` flag:

```bash
orion -l
```

### Update a Package

To update a specific package, use the `-u` or `--update` flag, followed by the package name:

```bash
orion -u discord
```

## How it Works

The `orion` command is a simple dispatcher. When you run `orion -u <package>`, it looks for an executable script named `<package>` in the `/usr/local/lib/orion/modules` directory.

If it finds the script, it executes it.

## Modules

### Discord (v3.0 - Multi-distro Support)

The Discord module has been enhanced with intelligent distribution detection and multi-method installation support.

**Features:**

- Automatic Linux distribution detection (Debian, Fedora, Arch, SUSE)
- Distribution-specific installation methods using native package managers
- Fallback chain: Package Manager → Flatpak → Tarball
- Version detection across different installation methods
- Installation method tracking and logging

**Supported Installation Methods:**

| Distribution Family | Primary Method | Fallback 1 | Fallback 2 |
|-------------------|----------------|------------|------------|
| Debian/Ubuntu | `.deb` via apt | Flatpak | Tarball |
| Fedora/RHEL/CentOS | `.rpm` via dnf | Flatpak | Tarball |
| Arch/Manjaro | AUR (yay/paru) | Flatpak | Tarball |
| openSUSE/SUSE | `.rpm` via zypper | Flatpak | Tarball |
| Other/Unknown | Flatpak | Tarball | - |

**Usage:**

```bash
# Install or update Discord with automatic distribution detection
orion -u discord

# Skip confirmation prompts (useful for scripts/automation)
orion -u discord --yes

# Force tarball installation (bypass package managers)
orion -u discord -t

# Force tarball installation without confirmation
orion -u discord -t -y
```

**Forced Tarball Installation:**

The `--tarball` or `-t` flag allows you to bypass automatic distribution detection and package manager installation methods, installing Discord directly from the tarball distribution. This is useful when:

- You want consistent installation across different distributions
- You encounter issues with distribution-specific package managers
- You prefer a universal installation method independent of system package management
- You're automating installation in containerized or minimal environments

Example usage:
```bash
orion -u discord --tarball           # Update Discord using tarball method
orion -u discord -t                  # Short form of the above
orion -u discord -t -y               # Tarball method without confirmation
```

**Examples by Distribution:**

*Debian/Ubuntu:*

```bash
# The updater will:
# 1. Detect Debian-based system
# 2. Download Discord .deb package
# 3. Install with dpkg and fix dependencies with apt-get
orion -u discord
```

*Fedora/RHEL:*

```bash
# The updater will:
# 1. Detect Fedora-based system
# 2. Download Discord .rpm package
# 3. Install with dnf (or yum on older systems)
orion -u discord
```

*Arch/Manjaro:*

```bash
# The updater will:
# 1. Detect Arch-based system
# 2. Check for AUR helper (yay or paru)
# 3. Install from AUR with full dependency resolution
orion -u discord
```

*openSUSE:*

```bash
# The updater will:
# 1. Detect openSUSE-based system
# 2. Download Discord .rpm package
# 3. Install with zypper
orion -u discord
```

**Troubleshooting:**

- **Missing AUR helper on Arch:** If you see a warning about missing `yay` or `paru`, install one:

  ```bash
  # Install yay
  sudo pacman -S yay
  # OR install paru
  sudo pacman -S paru
  ```

- **Dependency issues on Debian:** The updater automatically runs `apt-get install -f` to fix broken dependencies after installing the .deb.

- **Flatpak fallback:** If your system doesn't have a native package manager setup, the updater will try Flatpak. Ensure `flatpak` is installed:

  ```bash
  # Debian
  sudo apt install flatpak
  # Fedora
  sudo dnf install flatpak
  # Arch
  sudo pacman -S flatpak
  # SUSE
  sudo zypper install flatpak
  ```

- **Tarball fallback:** The original tarball installation method is always available as a final fallback for maximum compatibility.

**Log Location:**

Installation logs are saved to `/var/log/update-discord.log` for debugging and reference.

## Creating New Update Modules

You can easily extend `orion` to update other applications. For multi-distro support, follow the pattern used in the Discord module:

1. **Create a new script** in `/usr/local/lib/orion/modules` with the name `<appname>`.

2. **Add distribution detection:**

   ```bash
   # Add at the beginning after configuration
   source /etc/os-release
   DETECTED_DISTRO=$(detect_distro)  # Use the helper function from the module
   ```

3. **Implement distribution-specific installation functions:**
   - `install_<appname>_debian()`
   - `install_<appname>_fedora()`
   - `install_<appname>_arch()`
   - `install_<appname>_suse()`
   - `install_<appname>_flatpak()` (optional, universal fallback)
   - `install_<appname>_tarball()` (final fallback)

4. **Route installation based on detected distro in your main function**

5. **Make the script executable:**

   ```bash
   sudo chmod +x /usr/local/lib/orion/modules/<appname>
   ```

Now you can run `orion -u <appname>` to update your application with automatic multi-distro support.
