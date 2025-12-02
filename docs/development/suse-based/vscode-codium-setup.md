# Installing VS Code and VSCodium on openSUSE

This guide covers how to install Visual Studio Code (VS Code) and its open-source version, VSCodium, on openSUSE (both Leap and Tumbleweed).

The recommended method is to add the official or community software repositories, which will allow you to get updates automatically through `zypper`.

## Method 1: Installing Visual Studio Code (Official)

### 1. Add the Microsoft RPM Repository and Key

First, we need to import Microsoft's GPG key and then add their official repository.

```bash
# Import the Microsoft GPG key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add the VS Code repository
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
```

### 2. Install VS Code

Now that the repository is added, you can refresh your repositories and install VS Code.

```bash
# Refresh repositories
sudo zypper refresh

# Install code
sudo zypper install code
```
You can now launch Visual Studio Code from your application menu.

## Method 2: Installing VSCodium (Open Source)

For openSUSE, VSCodium can be installed from a community repository on the Open Build Service (OBS).

### 1. Add the VSCodium Community Repository

The command to add the repository depends on your openSUSE version.

**For openSUSE Tumbleweed:**
```bash
sudo zypper addrepo https://download.opensuse.org/repositories/home:nicotrade/openSUSE_Tumbleweed/home:nicotrade.repo
```

**For openSUSE Leap (e.g., 15.4):**
```bash
# Replace 15.4 with your Leap version if different
sudo zypper addrepo https://download.opensuse.org/repositories/home:nicotrade/openSUSE_Leap_15.4/home:nicotrade.repo
```

### 2. Trust the GPG key and Install VSCodium

Now, refresh the repositories. You will be prompted to trust the new GPG key for the repository. Choose "Always" trust (`a`).

```bash
sudo zypper refresh
sudo zypper install codium
```
You can now launch VSCodium from your application menu.

## Alternative: Download and Install the `.rpm` Package

If you prefer not to add a repository, you can download the `.rpm` package directly from the official websites and install it manually.

1.  Go to the [VS Code download page](https://code.visualstudio.com/Download) or the [VSCodium releases page](https://github.com/VSCodium/vscodium/releases).
2.  Download the `.rpm` file for `x64`.
3.  Open a terminal in your Downloads folder and run the installation command (replacing the filename as appropriate).
    ```bash
    sudo zypper install ./<filename>.rpm
    ```
    Using `zypper` to install the local file will automatically handle any required dependencies. The downside of this method is that you will not receive automatic updates.
