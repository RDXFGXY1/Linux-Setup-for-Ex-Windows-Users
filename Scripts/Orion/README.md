# `pkgup` - A Simple, Modular Package Updater

`pkgup` is a command-line tool for updating self-contained applications that don't come from your system's main package manager (e.g., applications installed from `.tar.gz` files).

It uses a modular architecture, where each application has its own update script.

## Installation

To install `pkgup`, run the `install.sh` script:

```bash
sudo ./install.sh
```

This will install the `pkgup` command to `/usr/local/bin/pkgup` and its modules to `/usr/local/lib/pkgup/modules`.

## Uninstallation

To uninstall `pkgup`, run the `uninstall.sh` script:

```bash
sudo ./uninstall.sh
```

## Usage

### List Available Packages

To see which applications can be updated with `pkgup`, use the `-l` or `--list` flag:

```bash
pkgup -l
```

### Update a Package

To update a specific package, use the `-u` or `--update` flag, followed by the package name:

```bash
pkgup -u discord
```

## How it Works

The `pkgup` command is a simple dispatcher. When you run `pkgup -u <package>`, it looks for an executable script named `update-<package>` in the `/usr/local/lib/pkgup/modules` directory.

If it finds the script, it executes it.

## Creating New Update Modules

You can easily extend `pkgup` to update other applications.

1.  **Create a new script** in `/usr/local/lib/pkgup/modules` with the name `update-<appname>`. For example, to add an updater for Spotify, you would create `update-spotify`.
2.  **Write the update logic** in the script. This will typically involve:
    *   Downloading the latest version of the application.
    *   Extracting it.
    *   Replacing the old installation with the new one.
3.  **Make the script executable**:
    ```bash
    sudo chmod +x /usr/local/lib/pkgup/modules/update-<appname>
    ```

Now you can run `pkgup -u <appname>` to update your application.
