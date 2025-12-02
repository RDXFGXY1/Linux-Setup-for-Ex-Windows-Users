# Installing VS Code and VSCodium on Fedora-based Linux

This guide covers how to install Visual Studio Code (VS Code) and its open-source version, VSCodium, on Fedora-based distributions.

The recommended method is to add the official software repositories, which will allow you to get updates automatically through the standard `dnf` update process.

## Method 1: Installing Visual Studio Code (Official)

### 1. Add the Microsoft RPM Repository and Key

First, we need to add Microsoft's repository and import their GPG key.

```bash
# Import the Microsoft GPG key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add the VS Code repository
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

### 2. Install VS Code

Now that the repository is added, check your `dnf` cache and install VS Code.

```bash
sudo dnf check-update
sudo dnf install code
```
You can now launch Visual Studio Code from your application menu.

## Method 2: Installing VSCodium (Open Source)

The process for VSCodium involves adding a third-party repository maintained by `paulcarroty`.

### 1. Add the VSCodium RPM Repository

You can add the repository by running the following command in your terminal. This command downloads the repository file and places it in the correct directory.

```bash
sudo dnf config-manager --add-repo https://download.vscodium.com/repo/rpms/vscodium.repo
```

### 2. Install VSCodium

Now, update your package index and install `codium`.

```bash
sudo dnf install codium
```
You can now launch VSCodium from your application menu.

## Alternative: Download and Install the `.rpm` Package

If you prefer not to add a repository, you can download the `.rpm` package directly from the official websites and install it manually.

1.  Go to the [VS Code download page](https://code.visualstudio.com/Download) or the [VSCodium releases page](https://github.com/VSCodium/vscodium/releases).
2.  Download the `.rpm` file for `x64`.
3.  Open a terminal in your Downloads folder and run the installation command (replacing the filename as appropriate).
    ```bash
    sudo dnf install "./<filename>.rpm"
    ```
    Using `dnf` to install the local file will automatically handle any required dependencies. The downside of this method is that you will not receive automatic updates.
